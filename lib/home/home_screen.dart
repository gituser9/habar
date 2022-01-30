import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/controllers/settings_ctrl.dart';
import 'package:habar/common/costants.dart';
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
  final _ctrl = Get.put(HomeCtrl());
  final _settingsCtrl = Get.put(SettingsCtrl());
  final _savedPostService = Get.put(SavedPostService());
  final Map<int, HomeMode> _pageMode = {
    0: HomeMode.posts,
    1: HomeMode.news,
    2: HomeMode.hubs,
    3: HomeMode.saved,
  };

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(),
      body: RefreshIndicator(
        onRefresh: () async => await _refreshPage(),
        child: Obx(() {
          if (_ctrl.isLoading.value) {
            return const LoadingWidget();
          }

          return _buildBody();
        }),
      ),
      bottomNavigationBar: Obx(() => _getBottomBar(_ctrl.selectedIndex.value)),
    );
  }

  Future<void> _refreshPage() async {
    if (_ctrl.currentFlow == '') {
      if (_ctrl.homeMode.value == HomeMode.saved) {
        _ctrl.getSaved();
      } else {
        await _ctrl.getAll(_settingsCtrl.settings.value.filters!.filterKey);
      }
    } else {
      await _ctrl.getFlow(_ctrl.currentFlow, page: 1);
    }
  }

  Widget _buildBody() {
    switch (_ctrl.homeMode.value) {
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
      title: const Text('Habar'),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () async {
            await Get.to(() => SearchScreen());
          },
        ),
        Obx(() {
          if (_ctrl.homeMode.value == HomeMode.news || _ctrl.homeMode.value == HomeMode.saved) {
            return Container();
          }

          return IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () async => await Get.bottomSheet(
              FilterWidget(),
              backgroundColor: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
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
      return _buildPostList(scrollCtrl: _ctrl.scrollCtrl);
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 4),
          _buildPostList(physics: const NeverScrollableScrollPhysics(), shrinkWrap: true),
          const SizedBox(height: 4),
          Material(
            color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
            child: PaginationWidget(
              page: _ctrl.page.value,
              pageCount: _ctrl.posts.value.pagesCount,
              callback: (int page) async {
                _ctrl.page.value = page;
                await _ctrl.getAll(
                  _settingsCtrl.settings.value.filters!.filterKey,
                  page: page,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostList({ScrollPhysics? physics, ScrollController? scrollCtrl, bool shrinkWrap = false}) {
    return ListView.builder(
        physics: physics,
        shrinkWrap: shrinkWrap,
        controller: scrollCtrl,
        itemCount: shrinkWrap ? _ctrl.posts.value.articleIds.length : _ctrl.posts.value.articleIds.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index >= _ctrl.posts.value.articleIds.length) {
            return const SizedBox(
              height: 48,
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(color: Colors.grey, strokeWidth: 2),
                ),
              ),
            );
          }

          final postId = _ctrl.posts.value.articleIds[index];

          if (!_ctrl.posts.value.articleRefs.containsKey(postId)) {
            return Container();
          }

          final articleRef = _ctrl.posts.value.articleRefs[postId]!;

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
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: 'Статьи',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article_outlined),
          label: 'Новости',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.device_hub),
          label: 'Хабы',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.save),
          label: 'Сохраненные',
        ),
      ],
      currentIndex: index,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.blue,
      onTap: (int index) async {
        _ctrl.selectedIndex.value = index;

        final mode = _pageMode[index]!;
        _ctrl.pageMode = mode;
        _ctrl.homeMode.value = mode;
        _ctrl.resetPage();

        switch (mode) {
          case HomeMode.hubs:
            await _ctrl.getHubs();
            break;
          case HomeMode.saved:
            _ctrl.getSaved();
            break;
          default:
            await _ctrl.getAll(_settingsCtrl.settings.value.filters!.filterKey);
        }
      },
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // user info
            Stack(
              children: [
                Container(
                  height: 180,
                  color: const Color(0xFF364754),
                  child: Container(),
                ),
                SizedBox(
                  height: 180,
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 90,
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 20),

            // info flows
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Потоки',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),
            ...Constant.postFlows
                .map((flow) => ListTile(
                      title: Text(flow.title),
                      onTap: () async {
                        Get.back();

                        _ctrl.currentFlow = flow.alias;

                        if (flow.alias == '') {
                          await _ctrl.getAll(_settingsCtrl.settings.value.filters!.filterKey);
                          _ctrl.posts.value = PostList.empty();
                        } else {
                          await _ctrl.getFlow(flow.alias, page: 1);
                          _ctrl.posts.value = PostList.empty();
                        }
                      },
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
