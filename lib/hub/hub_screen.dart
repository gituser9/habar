import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/services/saved_post_service.dart';
import 'package:habar/common/util.dart';
import 'package:habar/common/widgets/no_data_widget.dart';
import 'package:habar/common/widgets/pagination_widget.dart';
import 'package:habar/common/widgets/post_widget.dart';
import 'package:habar/home/widgets/loading_widget.dart';
import 'package:habar/hub/hub_ctrl.dart';
import 'package:habar/hub/widget/hub_author_llist_widget.dart';
import 'package:habar/hub/widget/hub_company_list_widget.dart';
import 'package:habar/hub/widget/hub_widget.dart';

class HubScreen extends StatelessWidget {
  final String name;
  final ctrl = Get.put(HubCtrl());
  final SavedPostService _savedPostService = Get.find();

  HubScreen({Key? key, required this.name}) : super(key: key) {
    ctrl.page.value = 1;
    ctrl.selectedIndex.value = 0;
    ctrl.setup(this.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Obx(() => HubInfoWidget(hub: ctrl.hub.value)),
              Flexible(
                  child: Obx(() => _getCurrentPage(ctrl.selectedIndex.value))),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(() => _getBottomBar(ctrl.selectedIndex.value)),
    );
  }

  Widget _getCurrentPage(int index) {
    if (ctrl.isLoading.value) {
      return LoadingWidget();
    }

    switch (index) {
      case 0:
        return _buildHubPage();
      case 1:
        return HubAuthorListWidget(name: name);
      case 2:
        return HubCompanyListWidget(name: name);
      default:
        return NoDataWidget();
    }
  }

  Widget _buildHubPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(top: 8),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: ctrl.posts.value.articleIds.length,
            itemBuilder: (ctx, index) {
              String postId = ctrl.posts.value.articleIds[index];
              final articleRef = ctrl.posts.value.articleRefs[postId]!;
              final imgUrl = Util.getImgUrl(
                  articleRef.leadData.imageUrl, articleRef.textHtml);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Obx(() => PostWidget(
                      article: articleRef,
                      imageUrl: imgUrl,
                      isSaved: _savedPostService.isSaved(articleRef.id),
                    )),
              );
            },
          ),
          Obx(() => PaginationWidget(
                pageCount: ctrl.posts.value.pagesCount,
                page: ctrl.page.value,
                callback: (int page) async {
                  ctrl.page.value = page;
                  await ctrl.getPosts(this.name, page);
                },
              )),
        ],
      ),
    );
  }

  Widget _getBottomBar(int selectedIndex) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: const Icon(Icons.article),
          label: 'Статьи',
        ),
        const BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: 'Авторы',
        ),
        const BottomNavigationBarItem(
          icon: const Icon(Icons.business),
          label: 'Компании',
        ),
      ],
      currentIndex: selectedIndex,
      unselectedLabelStyle: TextStyle(color: Colors.grey),
      fixedColor: Colors.blue,
      onTap: (int index) => ctrl.selectedIndex.value = index,
    );
  }
}
