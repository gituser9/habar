import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:get/get.dart';
import 'package:habar/common/controllers/settings_ctrl.dart';
import 'package:habar/common/util.dart';
import 'package:habar/common/widgets/footer_item_widget.dart';
import 'package:habar/common/widgets/user_info_widget.dart';
import 'package:habar/model/comment.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

class CommentWidget extends StatelessWidget {
  final SettingsCtrl _settingsCtrl = Get.find();
  final StructuredComment comment;

  CommentWidget({
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            decoration: BoxDecoration(
              color: comment.isPostAuthor ? Colors.lightGreen.shade100 : Colors.transparent,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: UserInfoWidget(publishTime: comment.publishTime, author: comment.author),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Html(
            data: comment.text,
            shrinkWrap: true,
            style: {
              'div': Style(fontSize: FontSize(_settingsCtrl.settings.value.commentTextSize), textAlign: TextAlign.start),
              'blockquote': Style(fontStyle: FontStyle.italic, fontSize: FontSize(_settingsCtrl.settings.value.commentTextSize - 2)),
              'pre': Style(
                fontStyle: FontStyle.normal,
                fontSize: const FontSize(14),
              ),
              'figure': Style(margin: const EdgeInsets.all(0), padding: const EdgeInsets.all(0)),
              'img': Style(margin: const EdgeInsets.all(0), padding: const EdgeInsets.all(0)),
              'a': Style(textDecoration: TextDecoration.none),
            },
            onLinkTap: (String? url, RenderContext ctx, Map<String, String> attributes, element) async {
              if (url != null) {
                await Util.launchURL(url);
              }
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
                          color: Colors.grey.shade100,
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: _buildCommentFooterRow(comment),
        ),
      ],
    );
  }

  Widget _buildCommentFooterRow(StructuredComment comment) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FooterItemWidget(
          icon: Icons.thumbs_up_down,
          value: comment.score,
          isMinus: comment.score < 0,
          isPlus: comment.score > 0,
        ),
      ],
    );
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
                  /* Obx(() {
                    return ctrl.isImageLoading.value == false
                        ? Container()
                        : Positioned(
                            left: Get.width / 2,
                            top: 150,
                            child: CircularProgressIndicator(color: Colors.white),
                          );
                  }), */
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
                            var status = await Permission.storage.status;

                            if (status.isPermanentlyDenied) {
                              return;
                            }

                            if (status.isDenied) {
                              status = await Permission.storage.request();
                            }

                            if (status.isDenied) {
                              return;
                            }

                            // ctrl.isImageLoading.value = true;
                            var response = await http.get(Uri.parse(url));
                            var hash = md5.convert(response.bodyBytes).toString();
                            var result = await ImageGallerySaver.saveImage(
                              response.bodyBytes,
                              name: 'habar_$hash',
                              quality: 100,
                            );

                            // ctrl.isImageLoading.value = false;
                            String snackText = result['isSuccess'] ? 'Изображение сохранено' : 'Ошибка сохранения';
                            final snackBar = SnackBar(content: Text(snackText));

                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.white, size: 20),
                          onPressed: () async {
                            var status = await Permission.storage.status;

                            if (status.isPermanentlyDenied) {
                              return;
                            }

                            if (status.isDenied) {
                              status = await Permission.storage.request();
                            }

                            if (status.isDenied) {
                              return;
                            }

                            // ctrl.isImageLoading.value = true;
                            var response = await http.get(Uri.parse(url));
                            var hash = md5.convert(response.bodyBytes).toString();
                            var result = await ImageGallerySaver.saveImage(
                              response.bodyBytes,
                              name: 'habar_$hash',
                              quality: 100,
                            );
                            var path = result['filePath'].toString().replaceAll(RegExp(r'file:'), '');
                            // ctrl.isImageLoading.value = false;

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
}
