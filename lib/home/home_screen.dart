import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/controllers/settings_ctrl.dart';
import 'package:habar/common/services/saved_post_service.dart';
import 'package:habar/common/util.dart';
import 'package:habar/common/widgets/no_data_widget.dart';
import 'package:habar/common/widgets/pagination_widget.dart';
import 'package:habar/common/widgets/post_widget.dart';
import 'package:habar/home/home_ctrl.dart';
import 'package:habar/home/widgets/filter_widget.dart';
import 'package:habar/home/widgets/hub_widget.dart';
import 'package:habar/home/widgets/loading_widget.dart';
import 'package:habar/home/widgets/saved_widget.dart';
import 'package:habar/model/home.dart';
import 'package:habar/search/search_screen.dart';
import 'package:habar/settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  final ctrl = Get.put(HomeCtrl());
  final _settingsCtrl = Get.put(SettingsCtrl());
  final _savedPostService = Get.put(SavedPostService());
  final Map<int, HomeMode> pageMode = {
    0: HomeMode.posts,
    1: HomeMode.news,
    2: HomeMode.hubs,
    3: HomeMode.saved,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async {
          await ctrl.getAll(ctrl.postFilter.value.filterKey.value);
        },
        child: Obx(() {
          if (ctrl.isLoading.value) {
            return LoadingWidget();
          }

          return _buildBody();
        }),
      ),
      bottomNavigationBar: Obx(() => _getBottomBar(ctrl.selectedIndex.value)),
    );
  }

  Widget _buildBody() {
    switch (ctrl.homeMode.value) {
      case HomeMode.posts:
      case HomeMode.news:
        return Container(
          child: _buildList(),
        );
      case HomeMode.hubs:
        return SingleChildScrollView(
          child: HubWidget(),
        );
      case HomeMode.saved:
        return SavedWidget();
      default:
        return NoDataWidget();
    }
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Habar'),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () async {
            await Get.to(() => SearchScreen());
          },
        ),
        Obx(() {
          if (ctrl.homeMode.value == HomeMode.news ||
              ctrl.homeMode.value == HomeMode.saved) {
            return Container();
          }

          return IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () async => await Get.bottomSheet(
              FilterWidget(),
              backgroundColor:
                  Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
            ),
          );
        }),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () async {
            await Get.to(() => SettingsScreen());
          },
        ),
      ],
    );
  }

  Widget _buildList() {
    if (_settingsCtrl.settings.value.isInfinityScroll!) {
      return _buildPostList(scrollCtrl: ctrl.scrollCtrl);
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 4),
          _buildPostList(
              physics: NeverScrollableScrollPhysics(), shrinkWrap: true),
          const SizedBox(height: 4),
          Material(
            color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
            child: PaginationWidget(
              page: ctrl.page.value,
              pageCount: ctrl.posts.value.pagesCount,
              callback: (int page) async {
                ctrl.page.value = page;
                await ctrl.getAll(ctrl.postFilter.value.filterKey.value,
                    page: page);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostList(
      {ScrollPhysics? physics,
      ScrollController? scrollCtrl,
      bool shrinkWrap = false}) {
    return ListView.builder(
        physics: physics,
        shrinkWrap: shrinkWrap,
        controller: scrollCtrl,
        itemCount: shrinkWrap
            ? ctrl.posts.value.articleIds.length
            : ctrl.posts.value.articleIds.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index >= ctrl.posts.value.articleIds.length) {
            return Container(
              height: 48,
              child: Align(
                alignment: Alignment.center,
                child: const SizedBox(
                  height: 16,
                  width: 16,
                  child: const CircularProgressIndicator(
                      color: Colors.grey, strokeWidth: 2),
                ),
              ),
            );
          }

          final postId = ctrl.posts.value.articleIds[index];

          if (!ctrl.posts.value.articleRefs.containsKey(postId)) {
            return Container();
          }

          final articleRef = ctrl.posts.value.articleRefs[postId]!;

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Obx(() => PostWidget(
                article: articleRef,
                isSaved: _savedPostService.isSaved(articleRef.id),
                imageUrl: Util.getImgUrl(
                  articleRef.leadData.imageUrl,
                  articleRef.textHtml,
                ))),
          );
        });
  }

  Widget _getBottomBar(int index) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: const Icon(Icons.article),
          label: 'Статьи',
        ),
        const BottomNavigationBarItem(
          icon: const Icon(Icons.article_outlined),
          label: 'Новости',
        ),
        const BottomNavigationBarItem(
          icon: const Icon(Icons.device_hub),
          label: 'Хабы',
        ),
        const BottomNavigationBarItem(
          icon: const Icon(Icons.save),
          label: 'Сохраненные',
        ),
      ],
      currentIndex: index,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.blue,
      onTap: (int index) async {
        ctrl.selectedIndex.value = index;

        final mode = pageMode[index]!;
        ctrl.pageMode = mode;
        ctrl.homeMode.value = mode;
        ctrl.resetPage();

        switch (mode) {
          case HomeMode.hubs:
            await ctrl.getHubs();
            break;
          case HomeMode.saved:
            ctrl.getSaved();
            break;
          default:
            await ctrl.getAll(ctrl.postFilter.value.filterKey.value);
        }
      },
    );
  }
}
