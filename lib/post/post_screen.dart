import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:habar/comments/comments_screen.dart';
import 'package:habar/common/util.dart';
import 'package:habar/common/widgets/footer_item_widget.dart';
import 'package:habar/common/widgets/user_info_widget.dart';
import 'package:habar/home/widgets/loading_widget.dart';
import 'package:habar/model/post.dart';
import 'package:habar/post/post_ctrl.dart';
import 'package:share/share.dart';

class PostScreen extends StatelessWidget {
  final String id;
  final ctrl = Get.put(PostCtrl());

  PostScreen({Key? key, required this.id}) : super(key: key) {
    ctrl.getByID(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Obx(() => _buildBody(ctrl.post.value)),
      ),
    );
  }

  Widget _buildBody(Post post) {
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
              'body': Style(fontSize: const FontSize(18)),
              'blockquote': Style(fontStyle: FontStyle.italic, fontSize: const FontSize(16)),
              'pre': Style(
                fontStyle: FontStyle.normal,
                fontSize: const FontSize(16),
                backgroundColor: Colors.grey.shade100,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              'figure': Style(margin: const EdgeInsets.all(0), padding: const EdgeInsets.all(0)),
              'img': Style(margin: const EdgeInsets.all(0), padding: const EdgeInsets.all(0)),
            },
            customRender: {
              'figure': (RenderContext context, Widget child) {
                for (final tag in context.tree.children) {
                  if (tag.name == 'img') {
                    String imgUrl = tag.element!.attributes['data-src'] ?? '';
                    return Image.network(imgUrl);
                  }
                }
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
}
