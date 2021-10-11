import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/comments/comments_screen.dart';
import 'package:habar/common/controllers/settings_ctrl.dart';
import 'package:habar/common/widgets/footer_item_widget.dart';
import 'package:habar/common/widgets/html_text.dart';
import 'package:habar/common/widgets/user_info_widget.dart';
import 'package:habar/home/widgets/loading_widget.dart';
import 'package:habar/model/post.dart';
import 'package:habar/post/post_ctrl.dart';
import 'package:share/share.dart';

class PostScreen extends StatelessWidget {
  final SettingsCtrl _settingsCtrl = Get.find();
  final PostCtrl ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    ctrl.setPosition(ctrl.postId.value);

    return Scaffold(
      // backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: ctrl.scrollCtrl,
        child: Container(child: Obx(() => _buildBody(context, ctrl.post.value))),
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
        HtmlText(htmlText: post.textHtml),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
          child: _buildFooterRow(post),
        ),
        Container(
          color: Get.isDarkMode ? Colors.grey.shade900 : Colors.grey.shade200,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: Get.isDarkMode ? Colors.grey.shade800 : Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                      mainAxisSize: MainAxisSize.min,
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
}
