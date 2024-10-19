import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/services/saved_post_service.dart';
import 'package:habar/common/util.dart';
import 'package:habar/common/widgets/empty_screen_widget.dart';
import 'package:habar/common/widgets/pagination_widget.dart';
import 'package:habar/common/widgets/post_widget.dart';
import 'package:habar/model/post_list.dart';
import 'package:habar/profile/profile_ctrl.dart';

class PostsWidget extends StatelessWidget {
  final String login;
  final ProfileCtrl _ctrl = Get.find();
  final SavedPostService _savedPostService = Get.find();

  PostsWidget({super.key, required this.login}) {
    // _ctrl.getProfileArticles(login);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_ctrl.posts.value.pagesCount == 0) {
        return const SizedBox(
          height: 200,
          child: EmptyScreenWidget(text: "публикаций пока нет"),
        );
      }

      return _buildList(_ctrl.posts.value);
    });
  }

  Widget _buildList(PostList postList) {
    return Column(
      children: [
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: postList.articleIds.length,
            itemBuilder: (BuildContext context, int index) {
              String postId = postList.articleIds[index];
              final articleRef = postList.articleRefs[postId]!;
              final imgUrl = Util.getImgUrl(articleRef.leadData.imageUrl, articleRef.textHtml);

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: PostWidget(
                  article: articleRef,
                  imageUrl: imgUrl,
                  isSaved: _savedPostService.isSaved(articleRef.id),
                ),
              );
            }),
        const SizedBox(height: 4),
        Material(
          color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
          child: PaginationWidget(
            page: _ctrl.page.value,
            pageCount: _ctrl.posts.value.pagesCount,
            callback: (int page) async {
              _ctrl.page.value = page;
              await _ctrl.getProfileArticles(login, page: page);
            },
          ),
        ),
      ],
    );
  }
}
