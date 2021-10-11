import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/services/saved_post_service.dart';
import 'package:habar/common/util.dart';
import 'package:habar/common/widgets/pagination_widget.dart';
import 'package:habar/common/widgets/post_widget.dart';
import 'package:habar/model/post_list.dart';
import 'package:habar/profile/profile_ctrl.dart';

class PostsWidget extends StatelessWidget {
  // final ProfileBloc bloc;
  final String login;
  final ProfileCtrl ctrl = Get.find();
  final SavedPostService _savedPostService = Get.find();

  PostsWidget({Key? key, required this.login}) : super(key: key) {
    ctrl.getProfileArticles(login);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.grey.shade200,
      child: Obx(() => _buildList(ctrl.posts.value)),
    );
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
              final imgUrl = Util.getImgUrl(
                  articleRef.leadData.imageUrl, articleRef.textHtml);

              return Container(
                margin: EdgeInsets.symmetric(vertical: 4),
                child: PostWidget(
                  article: articleRef,
                  imageUrl: imgUrl,
                  isSaved: _savedPostService.isSaved(articleRef.id),
                ),
              );
            }),
        const SizedBox(height: 4),
        Material(
          color: Colors.white,
          child: PaginationWidget(
            page: ctrl.page.value,
            pageCount: ctrl.posts.value.pagesCount,
            callback: (int page) async {
              ctrl.page.value = page;
              await ctrl.getProfileArticles(login, page: page);
            },
          ),
        ),
      ],
    );
  }
}
