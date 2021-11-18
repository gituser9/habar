import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:get/get.dart';
import 'package:habar/comments/comments_screen.dart';
import 'package:habar/common/controllers/settings_ctrl.dart';
import 'package:habar/common/costants.dart';
import 'package:habar/common/services/post_position_service.dart';
import 'package:habar/common/services/saved_post_service.dart';
import 'package:habar/common/util.dart';
import 'package:habar/common/widgets/footer_item_widget.dart';
import 'package:habar/common/widgets/user_info_widget.dart';
import 'package:habar/model/post.dart';
import 'package:habar/model/settings.dart';
import 'package:habar/post/post_ctrl.dart';
import 'package:share/share.dart';

class PostWidget extends StatelessWidget {
  final SettingsCtrl _settingsCtrl = Get.find();
  final SavedPostService _savedPostService = Get.find();
  final _positionService = Get.put(PostPositionService());
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

    return _buildBody(imgUrl);
  }

  Widget _buildBody(String imgUrl) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: _settingsCtrl.settings.value.theme == AppThemeType.dark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: _settingsCtrl.settings.value.theme == AppThemeType.dark ? Colors.grey.shade700 : Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 4, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UserInfoWidget(author: article.author, publishTime: article.timePublished),
                  _buildAction(),
                ],
              ),
            ),
            if (imgUrl.isNotEmpty && _settingsCtrl.settings.value.isShowImage)
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
            if (article.leadData.textHtml.isNotEmpty && _settingsCtrl.settings.value.isShowPostPreview) _buildTextPreview(),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8, left: 8, right: 8),
              child: _buildFooterRow(),
            ),
          ],
        ),
      ),
      onTap: () async {
        await Get.toNamed('/post/${article.id}');
      },
    );
  }

  Widget _buildTextPreview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Html(
          data: article.leadData.textHtml,
          shrinkWrap: true,
          style: {
            'body': Style(fontSize: const FontSize(16)),
            'blockquote': Style(fontStyle: FontStyle.italic, fontSize: const FontSize(16)),
            'a': Style(textDecoration: TextDecoration.none),
          },
          customRender: {
            'figure': (RenderContext ctx, Widget child) {
              return Container();
            },
            'img': (RenderContext ctx, Widget child) {
              return Container();
            },
          },
          onLinkTap: (String? url, RenderContext ctx, Map<String, String> attributes, element) async {
            if (url != null) {
              await Util.launchURL(url);
            }
          }),
    );
  }

  Widget _buildAction() {
    return Row(
      children: [
        Obx(() {
          if (_postCtrl.savedIds.contains(article.id)) {
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
            icon: Icon(isSaved ? Icons.delete : Icons.save, color: Colors.grey),
            onPressed: () async {
              _postCtrl.savedIds.add(article.id);
              String msg = '';

              if (isSaved) {
                msg = 'удален';
                await _savedPostService.deleteById(article.id);
                await _positionService.deleteById(article.id);
              } else {
                msg = 'сохранен';
                await _postCtrl.getByID(article.id);
                await _savedPostService.save(_postCtrl.post.value);
              }

              _postCtrl.savedIds.remove(article.id);
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
    );
  }

  Widget _buildFooterRow() {
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
              icon: Icon(Icons.mode_comment_rounded, color: AppColors.actionIcon, size: 18),
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
