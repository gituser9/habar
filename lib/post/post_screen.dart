import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:habar/comments/comments_screen.dart';
import 'package:habar/common/controllers/settings_ctrl.dart';
import 'package:habar/common/util.dart';
import 'package:habar/common/widgets/footer_item_widget.dart';
import 'package:habar/common/widgets/user_info_widget.dart';
import 'package:habar/home/widgets/loading_widget.dart';
import 'package:habar/model/post.dart';
import 'package:habar/post/post_ctrl.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

class PostScreen extends StatelessWidget {
  final String id;
  final bool isSaved;
  final SettingsCtrl _settingsCtrl = Get.find();
  final ctrl = Get.put(PostCtrl());

  PostScreen({Key? key, required this.id, required this.isSaved}) : super(key: key) {
    ctrl.isSaved.value = this.isSaved;
    ctrl.postId.value = this.id;
  }

  @override
  Widget build(BuildContext context) {
    ctrl.setPosition(id);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: ctrl.scrollCtrl,
        child: Obx(() => _buildBody(context, ctrl.post.value)),
      ),
    );
  }

  Widget _buildBody(BuildContext context, Post post) {
    if (ctrl.isLoading.value) {
      return LoadingWidget();
    }

    return Column(
      children: [
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UserInfoWidget(publishTime: post.timePublished, author: post.author),
              Row(
                children: [
                  Obx(() {
                    if (ctrl.savedIds.contains(post.id)) {
                      return const Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: const SizedBox(
                          height: 16,
                          width: 16,
                          child: const CircularProgressIndicator(color: Colors.grey, strokeWidth: 2),
                        ),
                      );
                    }

                    return IconButton(
                      icon: Icon(ctrl.isSaved.value ? Icons.delete : Icons.save, color: Colors.grey),
                      onPressed: () async {
                        ctrl.savedIds.add(post.id);
                        String msg = '';

                        if (ctrl.isSaved.value) {
                          msg = 'удален';
                          await ctrl.delete();
                        } else {
                          msg = 'сохранен';
                          await ctrl.save();
                        }

                        ctrl.savedIds.remove(post.id);
                        final snackbar = SnackBar(content: Text('Пост успешно $msg'));
                        ScaffoldMessenger.of(Get.context!).showSnackBar(snackbar);
                      },
                    );
                  }),
                  IconButton(
                    splashRadius: 20,
                    icon: const Icon(
                      Icons.share,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () async {
                      await Share.share(
                        'https://m.habr.com/ru/post/${post.id}/',
                        subject: post.titleHtml,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: _buildHubRow(post),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              post.titleHtml,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
        ),
        Html(
            data: post.textHtml,
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
            onLinkTap: (String? url, RenderContext context, Map<String, String> attributes, element) async {
              if (url != null) {
                await Util.launchURL(url);
              }
            }),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
          child: _buildFooterRow(post),
        ),
        Container(
          color: Colors.grey.shade200,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () async {
                      await Get.to(() => CommentsScreen(post: post));
                    },
                    icon: const Icon(
                      Icons.mode_comment_rounded,
                      color: Colors.grey,
                    ),
                    label: Row(
                      children: [
                        const Text('Комментарии'),
                        if (post.statistics.commentsCount > 0)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              ' ${post.statistics.commentsCount}',
                              style: TextStyle(color: Colors.blue.shade600),
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterRow(Post post) {
    Color raitingColor;

    if (post.statistics.votesCount > 0) {
      raitingColor = Colors.green.shade800;
    } else if (post.statistics.votesCount < 0) {
      raitingColor = Colors.red;
    } else {
      raitingColor = Colors.grey.shade600;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FooterItemWidget(
          icon: Icons.thumbs_up_down,
          value: post.statistics.votesCount,
          textColor: raitingColor,
          isMinus: post.statistics.votesCount < 0,
          isPlus: post.statistics.votesCount > 0,
        ),
        FooterItemWidget(icon: Icons.visibility, value: post.statistics.readingCount),
        FooterItemWidget(icon: Icons.bookmark, value: post.statistics.favoritesCount),
        IconButton(
          splashRadius: 25,
          icon: const Icon(Icons.share, color: Colors.grey, size: 15),
          onPressed: () async {
            await Share.share(
              'https://m.habr.com/ru/post/${post.id}/',
              subject: post.titleHtml,
            );
          },
        ),
      ],
    );
  }

  Widget _buildHubRow(Post post) {
    final hubNames = <String>[];

    for (final hub in post.hubs) {
      hubNames.add(hub.title);
    }

    return Text(
      hubNames.join(', '),
      style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
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
                  Obx(() {
                    return ctrl.isImageLoading.value == false
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

                            ctrl.isImageLoading.value = true;
                            var response = await http.get(Uri.parse(url));
                            var hash = md5.convert(response.bodyBytes).toString();
                            var result = await ImageGallerySaver.saveImage(
                              response.bodyBytes,
                              name: 'habar_$hash',
                              quality: 100,
                            );

                            ctrl.isImageLoading.value = false;
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

                            ctrl.isImageLoading.value = true;
                            var response = await http.get(Uri.parse(url));
                            var hash = md5.convert(response.bodyBytes).toString();
                            var result = await ImageGallerySaver.saveImage(
                              response.bodyBytes,
                              name: 'habar_$hash',
                              quality: 100,
                            );
                            var path = result['filePath'].toString().replaceAll(RegExp(r'file:'), '');
                            ctrl.isImageLoading.value = false;

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
