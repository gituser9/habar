import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/comments/comments_screen.dart';
import 'package:habar/common/widgets/footer_item_widget.dart';
import 'package:habar/common/widgets/html_text.dart';
import 'package:habar/common/widgets/user_info_widget.dart';
import 'package:habar/home/widgets/loading_widget.dart';
import 'package:habar/model/post.dart';
import 'package:habar/post/post_ctrl.dart';
import 'package:share/share.dart';

class PostScreen extends StatelessWidget {
  final PostCtrl _ctrl = Get.find();

  PostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        controller: _ctrl.scrollCtrl,
        interactive: true,
        child: SingleChildScrollView(
          controller: _ctrl.scrollCtrl,
          child: Obx(() => _buildBody(context, _ctrl.post.value)),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, Post post) {
    if (_ctrl.isLoading.value) {
      return const LoadingWidget();
    }

    return Column(
      children: [
        const SizedBox(height: 30),
        // header
        _buildHeader(post),

        // hubs
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: _buildHubRow(post),
          ),
        ),
        const SizedBox(height: 16),

        // post
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
        SelectionArea(child: HtmlText(htmlText: post.textHtml)),
        Divider(height: 1, color: Colors.grey.shade600),

        // footer
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
          child: _buildFooterRow(post),
        ),
        _deleteButton(post),
        _buildCommentButton(post),
      ],
    );
  }

  Container _deleteButton(Post post) {
    if (!_ctrl.isSaved.isTrue) {
      return Container();
    }

    return Container(
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
                  await _ctrl.delete();
                  _ctrl.isSaved.value = false;

                  final snackBar = SnackBar(
                    content: Text('Пост успешно удален',
                        style: TextStyle(
                          color: Get.isDarkMode ? Colors.white : null,
                        )),
                    backgroundColor: Get.isDarkMode ? Colors.black : null,
                  );
                  ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [Text('Удалить')],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding _buildHeader(Post post) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          UserInfoWidget(publishTime: post.timePublished, author: post.author),
          Row(
            children: [
              Obx(() {
                if (_ctrl.savedIds.contains(post.id)) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(color: Colors.grey, strokeWidth: 2),
                    ),
                  );
                }

                return IconButton(
                  icon: Icon(_ctrl.isSaved.value ? Icons.delete : Icons.save, color: Colors.grey),
                  onPressed: () async {
                    String msg = '';

                    if (_ctrl.isSaved.value) {
                      msg = 'удален';
                      await _ctrl.delete();
                    } else {
                      msg = 'сохранен';
                      await _ctrl.save();
                    }

                    final snackBar = SnackBar(
                      content: Text('Пост успешно $msg',
                          style: TextStyle(
                            color: Get.isDarkMode ? Colors.white : null,
                          )),
                      backgroundColor: Get.isDarkMode ? Colors.black : null,
                    );
                    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
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
    );
  }

  Container _buildCommentButton(Post post) {
    return Container(
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
                    Text(
                      'Комментарии',
                      style: TextStyle(color: Get.isDarkMode ? Colors.grey.shade300 : Colors.grey.shade900),
                    ),
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
    final hubNames = post.hubs.map(((hub) => hub.title)).toList();

    return Text(
      hubNames.join(', '),
      style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
    );
  }
}
