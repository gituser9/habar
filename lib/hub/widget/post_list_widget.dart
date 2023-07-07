import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/controllers/hide_bottombar_ctrl.dart';
import 'package:habar/common/services/saved_post_service.dart';
import 'package:habar/common/util.dart';
import 'package:habar/common/widgets/pagination_widget.dart';
import 'package:habar/common/widgets/post_widget.dart';
import 'package:habar/hub/hub_ctrl.dart';

class PostListWidget extends StatelessWidget {
  final String name;
  final HubCtrl ctrl = Get.find();
  final SavedPostService _savedPostService = Get.find();
  final HideBottomBarCtrl bottomCtrl;

  PostListWidget({Key? key, required this.name, required this.bottomCtrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildHubPage();
  }

  Widget _buildHubPage() {
    return SingleChildScrollView(
      controller: bottomCtrl.scrollCtrl,
      child: Column(
        children: [
          Obx(() => ListView.builder(
                padding: const EdgeInsets.only(top: 8),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: ctrl.posts.value.articleIds.length,
                itemBuilder: (ctx, index) {
                  String postId = ctrl.posts.value.articleIds[index];
                  final articleRef = ctrl.posts.value.articleRefs[postId]!;
                  final imgUrl = Util.getImgUrl(articleRef.leadData.imageUrl, articleRef.textHtml);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Obx(() => PostWidget(
                          article: articleRef,
                          imageUrl: imgUrl,
                          isSaved: _savedPostService.isSaved(articleRef.id),
                        )),
                  );
                },
              )),
          Obx(() => PaginationWidget(
                pageCount: ctrl.posts.value.pagesCount,
                page: ctrl.page.value,
                callback: (int page) async {
                  ctrl.page.value = page;
                  await ctrl.getPosts(name, page);
                },
              )),
        ],
      ),
    );
  }
}
