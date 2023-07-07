import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:habar/comments/comments_screen.dart';
import 'package:habar/common/controllers/settings_ctrl.dart';
import 'package:habar/common/costants.dart';
import 'package:habar/common/services/post_position_service.dart';
import 'package:habar/common/services/saved_post_service.dart';
import 'package:habar/common/util.dart';
import 'package:habar/common/widgets/footer_item_widget.dart';
import 'package:habar/common/widgets/user_info_widget.dart';
import 'package:habar/home/home_ctrl.dart';
import 'package:habar/model/post.dart';
import 'package:habar/model/settings.dart';
import 'package:habar/post/post_ctrl.dart';
import 'package:share/share.dart';

class PostWidget extends StatelessWidget {
  final SettingsCtrl _settingsCtrl = Get.find();
  final SavedPostService _savedPostService = Get.find();
  final HomeCtrl _homeCtrl = Get.find();
  final _positionService = Get.put(PostPositionService());
  final _postCtrl = Get.put(PostCtrl());

  final Post article;
  final String imageUrl;
  final bool isSaved;

  PostWidget({
    super.key,
    required this.article,
    required this.imageUrl,
    required this.isSaved,
  });

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
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
            _buildImage(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: _buildTitle(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: Row(
                children: [
                  _buildComplexity(),
                  SizedBox(width: article.complexity == null || article.complexity!.isEmpty ? 0 : 16),
                  _buildReadTime(),
                ],
              ),
            ),
            _buildTextPreview(),
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

  Widget _buildImage() {
    if (!_settingsCtrl.settings.value.isShowImage) {
      return Container();
    }

    String imgUrl = Util.getImgUrl(imageUrl, article.textHtml);

    if (imgUrl.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Image.network(imgUrl),
    );
  }

  Widget _buildTitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Html(
        data: article.titleHtml,
        shrinkWrap: true,
        style: {
          'body': Style(
            fontSize: FontSize(18),
            fontWeight: FontWeight.bold,
          ),
          'blockquote': Style(
            fontStyle: FontStyle.italic,
            fontSize: FontSize(16),
          ),
        },
      ),
    );
  }

  Widget _buildTextPreview() {
    if (!_settingsCtrl.settings.value.isShowPostPreview && article.leadData.textHtml.isNotEmpty) {
      return Container();
    }

    if (article.leadData.textHtml.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Html(
          data: article.leadData.textHtml,
          shrinkWrap: true,
          style: {
            'body': Style(fontSize: FontSize(16)),
            'blockquote': Style(fontStyle: FontStyle.italic, fontSize: FontSize(16)),
            'a': Style(textDecoration: TextDecoration.none),
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
              padding: EdgeInsets.only(right: 10.0),
              child: SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(color: Colors.grey, strokeWidth: 2),
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

                _homeCtrl.savedPosts.removeWhere((p) => p.id == article.id);
              } else {
                msg = 'сохранен';
                await _postCtrl.getByID(article.id);
                await _savedPostService.save(_postCtrl.post.value);

                _homeCtrl.savedPosts.add(_postCtrl.post.value);
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
    Color ratingColor;

    if (article.statistics.score > 0) {
      ratingColor = Colors.green.shade800;
    } else if (article.statistics.score < 0) {
      ratingColor = Colors.red;
    } else {
      ratingColor = Colors.grey.shade600;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FooterItemWidget(
          icon: Icons.thumbs_up_down,
          value: article.statistics.score,
          textColor: ratingColor,
          isMinus: article.statistics.score < 0,
          isPlus: article.statistics.score > 0,
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

  Widget _buildComplexity() {
    if (article.complexity == null || article.complexity!.isEmpty) {
      return Container();
    }

    Color clr;
    String title;
    IconData iconData;

    switch (article.complexity) {
      case 'low':
        clr = Colors.green;
        title = 'Простой';
        iconData = Icons.density_large_outlined;
        break;
      case 'medium':
        clr = Colors.blue;
        title = 'Средний';
        iconData = Icons.density_medium_outlined;
        break;
      case 'high':
        clr = Colors.red;
        title = 'Сложный';
        iconData = Icons.density_small_outlined;
        break;
      default:
        return Container();
    }

    return Row(
      children: [
        Icon(iconData, color: clr, size: 18),
        const SizedBox(width: 4),
        Text(title, style: TextStyle(color: clr, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildReadTime() {
    if (article.readingTime == null || article.readingTime! <= 0) {
      return Container();
    }

    return Row(
      children: [
        const Icon(Icons.schedule, color: Colors.grey, size: 20),
        const SizedBox(width: 4),
        Text('${article.readingTime} мин', style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
