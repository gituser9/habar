import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/controllers/settings_ctrl.dart';
import 'package:habar/common/widgets/footer_item_widget.dart';
import 'package:habar/common/widgets/html_text.dart';
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
          child: HtmlText(htmlText: comment.text),
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
