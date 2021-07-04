import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:get/get.dart';
import 'package:habar/comments/comments_screen.dart';
import 'package:habar/common/costants.dart';
import 'package:habar/common/services/saved_post_service.dart';
import 'package:habar/common/util.dart';
import 'package:habar/common/widgets/footer_item_widget.dart';
import 'package:habar/common/widgets/user_info_widget.dart';
import 'package:habar/model/post.dart';
import 'package:habar/post/post_ctrl.dart';
import 'package:habar/post/post_screen.dart';
import 'package:share/share.dart';

class PostWidget extends StatelessWidget {
  final SavedPostService _savedPostService = Get.find();
  final _postCtrl = Get.put(PostCtrl());

  final Post article;
  final String imageUrl;
  final bool isSaved;

  PostWidget({
    required this.article,
    required this.imageUrl,
    required this.isSaved,
  });

  @override
  Widget build(BuildContext context) {
    String imgUrl = Util.getImgUrl(this.imageUrl, article.textHtml);

    return InkWell(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: Colors.grey.shade300),
        ),
        // color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 4, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UserInfoWidget(author: article.author, publishTime: article.timePublished),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(isSaved ? Icons.delete : Icons.save, color: Colors.grey),
                        onPressed: () async {
                          String msg = '';

                          if (isSaved) {
                            msg = 'удален';
                            await _savedPostService.deleteById(article.id);
                          } else {
                            msg = 'сохранен';
                            await _postCtrl.getByID(article.id, false);
                            await _savedPostService.save(_postCtrl.post.value);
                          }

                          final snackbar = SnackBar(content: Text('Пост успешно $msg'));
                          ScaffoldMessenger.of(Get.context!).showSnackBar(snackbar);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.share,
                          color: Colors.grey,
                          size: 20,
                        ),
                        onPressed: () async {
                          await Share.share(
                            'https://m.habr.com/ru/post/${article.id}/',
                            subject: article.titleHtml,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (imgUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.network(imgUrl),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Html(
                  data: article.titleHtml,
                  shrinkWrap: true,
                  style: {
                    'body': Style(fontSize: const FontSize(18), fontWeight: FontWeight.bold),
                    'blockquote': Style(fontStyle: FontStyle.italic, fontSize: const FontSize(16)),
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: _buildFooterRow(context),
            ),
          ],
        ),
      ),
      onTap: () async {
        Get.to(() => PostScreen(id: article.id, isSaved: isSaved));
      },
    );
  }

  Widget _buildFooterRow(BuildContext context) {
    Color raitingColor;

    if (article.statistics.votesCount > 0) {
      raitingColor = Colors.green.shade800;
    } else if (article.statistics.votesCount < 0) {
      raitingColor = Colors.red;
    } else {
      raitingColor = Colors.grey.shade600;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FooterItemWidget(
          icon: Icons.thumbs_up_down,
          value: article.statistics.votesCount,
          textColor: raitingColor,
          isMinus: article.statistics.votesCount < 0,
          isPlus: article.statistics.votesCount > 0,
        ),
        FooterItemWidget(icon: Icons.visibility, value: article.statistics.readingCount),
        FooterItemWidget(icon: Icons.bookmark, value: article.statistics.favoritesCount),
        Row(
          children: [
            IconButton(
              splashRadius: 25,
              alignment: Alignment.centerRight,
              icon: Icon(Icons.mode_comment_rounded, color: AppColors.actionIcon, size: 15),
              onPressed: () async => Get.to(() => CommentsScreen(post: article)),
            ),
            Text(
              article.statistics.commentsCount.toString(),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
