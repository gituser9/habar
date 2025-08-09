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
import 'package:habar/model/news.dart';
import 'package:habar/model/settings.dart';
import 'package:habar/post/post_ctrl.dart';
import 'package:share_plus/share_plus.dart';

class NewsDetailWidget extends StatelessWidget {
  final SettingsCtrl _settingsCtrl = Get.find();
  final SavedPostService _savedPostService = Get.find();
  final HomeCtrl _homeCtrl = Get.find();
  final _positionService = Get.put(PostPositionService());
  final _postCtrl = Get.put(PostCtrl());

  final NewsRef news;
  final String imageUrl;
  final bool isSaved;

  NewsDetailWidget({
    super.key,
    required this.news,
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
                  UserInfoWidget(
                    publishTime: news.timePublished,
                    alias: news.author.alias,
                    avatarUrl: news.author.avatarUrl ?? '',
                    fullName: news.author.fullname ?? '',
                  ),
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
                  SizedBox(width: news.complexity == null || news.complexity!.isEmpty ? 0 : 16),
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
        await Get.toNamed('/post/${news.id}');
      },
    );
  }

  Widget _buildImage() {
    if (!_settingsCtrl.settings.value.isShowImage) {
      return Container();
    }

    String imgUrl = Util.getImgUrl(imageUrl, news.titleHtml);

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
        data: news.titleHtml,
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
    if (!_settingsCtrl.settings.value.isShowPostPreview && news.leadData.textHtml.isNotEmpty) {
      return Container();
    }

    if (news.leadData.textHtml.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Html(
          data: news.leadData.textHtml,
          shrinkWrap: true,
          style: {
            'body': Style(fontSize: FontSize(16)),
            'blockquote': Style(fontStyle: FontStyle.italic, fontSize: FontSize(16)),
            'a': Style(textDecoration: TextDecoration.none),
          },
          onLinkTap: (String? url, Map<String, String> attributes, element) async {
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
          if (_postCtrl.savedIds.contains(news.id)) {
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
              _postCtrl.savedIds.add(news.id);
              String msg = '';

              if (isSaved) {
                msg = 'удален';
                await _savedPostService.deleteById(news.id);
                await _positionService.deleteById(news.id);

                _homeCtrl.savedPosts.removeWhere((p) => p.id == news.id);
              } else {
                msg = 'сохранен';
                await _postCtrl.getByID(news.id);
                await _savedPostService.save(_postCtrl.post.value);

                _homeCtrl.savedPosts.add(_postCtrl.post.value);
              }

              _postCtrl.savedIds.remove(news.id);
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
            final params = ShareParams(uri: Uri.parse('https://m.habr.com/ru/post/${news.id}/'));
            await SharePlus.instance.share(params);
          },
        ),
      ],
    );
  }

  Widget _buildFooterRow() {
    Color ratingColor;

    if (news.statistics.score > 0) {
      ratingColor = Colors.green.shade800;
    } else if (news.statistics.score < 0) {
      ratingColor = Colors.red;
    } else {
      ratingColor = Colors.grey.shade600;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FooterItemWidget(
          icon: Icons.thumbs_up_down,
          value: news.statistics.score ?? 0,
          textColor: ratingColor,
          isMinus: (news.statistics.score ?? 0) < 0,
          isPlus: (news.statistics.score ?? 0) > 0,
        ),
        FooterItemWidget(icon: Icons.visibility, value: news.statistics.readingCount ?? 0),
        FooterItemWidget(icon: Icons.bookmark, value: news.statistics.favoritesCount ?? 0),
        Row(
          children: [
            IconButton(
              splashRadius: 25,
              alignment: Alignment.centerRight,
              icon: Icon(Icons.mode_comment_rounded, color: AppColors.actionIcon, size: 18),
              onPressed: () async => Get.to(() => CommentsScreen(post: news)),
            ),
            Text(
              (news.statistics.commentsCount ?? '').toString(),
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
    if (news.complexity == null || news.complexity!.isEmpty) {
      return Container();
    }

    Color clr;
    String title;
    IconData iconData;

    switch (news.complexity) {
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
    if (news.readingTime == null || news.readingTime! <= 0) {
      return Container();
    }

    return Row(
      children: [
        const Icon(Icons.schedule, color: Colors.grey, size: 20),
        const SizedBox(width: 4),
        Text('${news.readingTime} мин', style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
