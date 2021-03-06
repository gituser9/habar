import 'dart:io';

import 'package:crypto/crypto.dart' show md5;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/controllers/html_text_ctrl.dart';
import 'package:habar/common/controllers/settings_ctrl.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:uri_to_file/uri_to_file.dart';

class HtmlImage extends StatefulWidget {
  final String imageUrl;

  const HtmlImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<HtmlImage> createState() => _HtmlImageState();
}

class _HtmlImageState extends State<HtmlImage> {
  final _defaultHeight = 200.0;
  final _defaultWidth = 200.0;

  final SettingsCtrl _settingsCtrl = Get.find();
  final HtmlTextCtrl _ctrl = Get.find();

  bool isImageHidden = false;

  _HtmlImageState() {
    isImageHidden = _settingsCtrl.settings.value.isHidePostImages ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: _defaultHeight),
      child: isImageHidden ? _buildImageMock() : _buildImage(context),
    );
  }

  Widget _buildImageMock() {
    return GestureDetector(
      child: Center(
        child: SizedBox(
          width: _defaultWidth,
          height: _defaultHeight,
          child: Stack(
            children: [
              Center(
                child: Icon(
                  Icons.image_outlined,
                  size: _defaultHeight,
                  color: Colors.grey.shade400,
                ),
              ),
              const Center(
                child: Icon(
                  Icons.file_download,
                  size: 50,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        setState(() {
          isImageHidden = false;
        });
      },
    );
  }

  Widget _buildImage(BuildContext context) {
    return GestureDetector(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Image.network(
            widget.imageUrl,
            loadingBuilder: (ctx, child, progress) {
              if (progress == null) {
                return child;
              }

              return Center(
                child: SizedBox(
                  width: _defaultWidth,
                  height: _defaultHeight,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: progress.expectedTotalBytes != null ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes! : null,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        onTap: () async => await _showImage(context, widget.imageUrl));
  }

  Future _showImage(BuildContext context, String url) async {
    await showDialog(
        context: context,
        builder: (ctx) {
          return GestureDetector(
            onTap: () => Get.back(),

            // image container
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
                            child: const CircularProgressIndicator(color: Colors.white),
                          );
                  }),

                  // buttons container
                  Positioned(
                    bottom: 15,
                    width: Get.width,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // save image button
                        IconButton(
                          icon: const Icon(Icons.download, color: Colors.white, size: 20),
                          onPressed: () async {
                            _ctrl.isImageLoading.value = true;

                            bool isGranted = await _checkStoragePermission();

                            if (!isGranted) {
                              return;
                            }

                            var response = await http.get(Uri.parse(url));
                            String hash = md5.convert(response.bodyBytes).toString();
                            var result = await ImageGallerySaver.saveImage(
                              response.bodyBytes,
                              name: 'habar_$hash',
                              quality: 100,
                            );
                            String snackText = result['isSuccess'] ? '?????????????????????? ??????????????????' : '???????????? ????????????????????';

                            _ctrl.isImageLoading.value = false;

                            final snackBar = SnackBar(content: Text(snackText));
                            ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
                          },
                        ),

                        // share image button
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.white, size: 20),
                          onPressed: () async {
                            _ctrl.isImageLoading.value = true;

                            bool isGranted = await _checkStoragePermission();

                            if (!isGranted) {
                              return;
                            }

                            var response = await http.get(Uri.parse(url));
                            String hash = md5.convert(response.bodyBytes).toString();
                            var result = await ImageGallerySaver.saveImage(
                              response.bodyBytes,
                              name: 'habar_$hash',
                              quality: 100,
                            );
                            File file = await toFile(result['filePath']);

                            _ctrl.isImageLoading.value = false;

                            try {
                              await Share.shareFiles([file.path]);
                              await file.delete();
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),

                        // close button
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

  Future<bool> _checkStoragePermission() async {
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
}
