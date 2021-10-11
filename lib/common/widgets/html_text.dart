import 'dart:async';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:habar/common/controllers/html_text_ctrl.dart';
import 'package:habar/common/controllers/settings_ctrl.dart';
import 'package:habar/common/util.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

class HtmlText extends StatelessWidget {
  final SettingsCtrl _settingsCtrl = Get.find();
  final _ctrl = Get.put(HtmlTextCtrl());

  final String htmlText;

  HtmlText({
    Key? key,
    required this.htmlText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Html(
        data: htmlText,
        shrinkWrap: true,
        style: {
          'body': Style(fontSize: FontSize(_settingsCtrl.settings.value.postTextSize)),
          'blockquote':
              Style(fontStyle: FontStyle.italic, fontSize: FontSize(_settingsCtrl.settings.value.postTextSize - 2)),
          'pre': Style(
            fontStyle: FontStyle.normal,
            fontSize: const FontSize(14),
          ),
          'figure': Style(margin: const EdgeInsets.all(0), padding: const EdgeInsets.all(0)),
          'img': Style(margin: const EdgeInsets.all(0), padding: const EdgeInsets.all(0)),
          'a': Style(textDecoration: TextDecoration.none),
        },
        customRender: {
          'figure': (RenderContext ctx, Widget child) {
            for (final tag in ctx.tree.children) {
              if (tag.name == 'img') {
                String imgUrl = tag.element!.attributes['data-src'] ?? '';

                return GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Image.network(imgUrl),
                  ),
                  onTap: () async => await _showImage(context, imgUrl),
                );
              }
            }
          },
          'img': (RenderContext ctx, Widget child) {
            String? fullImg = ctx.tree.element?.attributes['data-src'];

            if (fullImg == null || fullImg.isEmpty) {
              fullImg = ctx.tree.element?.attributes['src'] ?? '';
            }

            return GestureDetector(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Image.network(fullImg),
              ),
              onTap: () async => await _showImage(context, fullImg ?? ''),
            );
          },
          'pre': (RenderContext ctx, Widget child) {
            return Scrollbar(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      color: Get.isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: child,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
        onLinkTap: (String? url, RenderContext ctx, Map<String, String> attributes, element) async {
          if (url != null) {
            print(url);
            await Util.launchInternal(url);
          }
        });
  }

  Future _showImage(BuildContext context, String url) async {
    await showDialog(
        context: context,
        builder: (ctx) {
          return GestureDetector(
            onTap: () => Get.back(),
            child: Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  Center(
                    child: InteractiveViewer(
                      clipBehavior: Clip.none,
                      constrained: true,
                      scaleEnabled: true,
                      maxScale: 20,
                      child: Image.network(url),
                    ),
                  ),
                  Obx(() {
                    return _ctrl.isImageLoading.value == false
                        ? Container()
                        : Positioned(
                            left: Get.width / 2,
                            top: 150,
                            child: CircularProgressIndicator(color: Colors.white),
                          );
                  }),
                  Positioned(
                    bottom: 15,
                    width: Get.width,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.download, color: Colors.white, size: 20),
                          onPressed: () async {
                            _ctrl.isImageLoading.value = true;

                            bool isGranted = await _checkPermission();

                            if (!isGranted) {
                              return;
                            }

                            var response = await http.get(Uri.parse(url));
                            var hash = md5.convert(response.bodyBytes).toString();
                            var result = await ImageGallerySaver.saveImage(
                              response.bodyBytes,
                              name: 'habar_$hash',
                              quality: 100,
                            );
                            String snackText = result['isSuccess'] ? 'Изображение сохранено' : 'Ошибка сохранения';

                            _ctrl.isImageLoading.value = false;

                            final snackBar = SnackBar(content: Text(snackText));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.white, size: 20),
                          onPressed: () async {
                            _ctrl.isImageLoading.value = true;

                            bool isGranted = await _checkPermission();

                            if (!isGranted) {
                              return;
                            }

                            var response = await http.get(Uri.parse(url));
                            var hash = md5.convert(response.bodyBytes).toString();
                            var result = await ImageGallerySaver.saveImage(
                              response.bodyBytes,
                              name: 'habar_$hash',
                              quality: 100,
                            );
                            var path = result['filePath'].toString().replaceAll(RegExp(r'file:'), '');

                            _ctrl.isImageLoading.value = false;

                            await Share.shareFiles([path]);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white),
                          onPressed: () => Get.back(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<bool> _checkPermission() async {
    var status = await Permission.storage.status;

    if (status.isPermanentlyDenied) {
      return false;
    }

    if (status.isDenied) {
      status = await Permission.storage.request();
    }

    if (status.isDenied) {
      return false;
    }

    return true;
  }

  FutureOr<dynamic> _downloadImage(String url) async {
    bool isGranted = await _checkPermission();

    if (!isGranted) {
      return;
    }

    var response = await http.get(Uri.parse(url));
    var hash = md5.convert(response.bodyBytes).toString();
    var result = await ImageGallerySaver.saveImage(
      response.bodyBytes,
      name: 'habar_$hash',
      quality: 100,
    );

    return result;
  }
}
