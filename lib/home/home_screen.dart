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
import 'package:habar/model/post_list.dart';
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
        child: _buildBody(),
      ),
      bottomNavigationBar: Obx(() => _getBottomBar(ctrl.selectedIndex.value)),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Obx(() {
            if (ctrl.isLoading.value) {
              return LoadingWidget();
            }
            switch (ctrl.homeMode.value) {
              case HomeMode.posts:
              case HomeMode.news:
                return Container(
                  color: Colors.grey.shade200,
                  child: _buildList(ctrl.posts.value),
                );
              case HomeMode.hubs:
                return HubWidget();
              case HomeMode.saved:
                return SavedWidget();
              default:
                return NoDataWidget();
            }
          }),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Habar',
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () async {
            await Get.to(() => SearchScreen());
          },
        ),
        Obx(() {
          if (ctrl.homeMode.value == HomeMode.news || ctrl.homeMode.value == HomeMode.saved) {
            return Container();
          }

          return IconButton(
            icon: const Icon(Icons.tune, color: Colors.black),
            onPressed: () async => await Get.bottomSheet(
              FilterWidget(),
              backgroundColor: Colors.white,
            ),
          );
        }),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.black),
          onPressed: () async {
            await Get.to(() => SettingsScreen());
          },
        ),
      ],
    );
  }

  Widget _buildList(PostList postList) {
    return Column(
      children: [
        const SizedBox(height: 4),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: postList.articleIds.length,
            itemBuilder: (BuildContext context, int index) {
              final postId = postList.articleIds[index];
              final articleRef = postList.articleRefs[postId]!;

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
            }),
        const SizedBox(height: 4),
        Material(
          color: Colors.white,
          child: PaginationWidget(
            page: ctrl.page.value,
            pageCount: postList.pagesCount,
            callback: (int page) async {
              ctrl.page.value = page;
              await ctrl.getAll(ctrl.postFilter.value.filterKey.value, page: page);
            },
          ),
        ),
      ],
    );
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
