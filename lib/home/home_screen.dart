import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/controllers/settings_ctrl.dart';
import 'package:habar/common/costants.dart';
import 'package:habar/common/widgets/no_data_widget.dart';
import 'package:habar/home/home_ctrl.dart';
import 'package:habar/home/widgets/filter_widget.dart';
import 'package:habar/home/widgets/hub_widget.dart';
import 'package:habar/home/widgets/loading_widget.dart';
import 'package:habar/home/widgets/posts_widget.dart';
import 'package:habar/home/widgets/saved_widget.dart';
import 'package:habar/model/home.dart';
import 'package:habar/model/post_list.dart';
import 'package:habar/search/search_screen.dart';
import 'package:habar/settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  final _ctrl = Get.put(HomeCtrl());
  final SettingsCtrl _settingsCtrl = Get.find();
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
        return PostsWidget();
      case HomeMode.hubs:
        return SingleChildScrollView(
          controller: _ctrl.scrollCtrl,
          child: HubWidget(),
        );
      case HomeMode.saved:
        return SavedWidget();
      default:
        return const NoDataWidget();
    }
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Habar'),
          Obx(() => Text(
                _ctrl.currentFlowName.value.isEmpty ? 'Все потоки' : _ctrl.currentFlowName.value,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              )),
        ],
      ),
      actions: [
        Obx(() {
          if (_ctrl.homeMode.value == HomeMode.hubs) {
            return IconButton(
              icon: Icon(_ctrl.isShowPinnedHub.value ? Icons.bookmarks : Icons.bookmarks_outlined),
              onPressed: () {
                _ctrl.isShowPinnedHub.value = !_ctrl.isShowPinnedHub.value;
              },
            );
          }

          return Container();
        }),
        Obx(() {
          bool isShow = _ctrl.homeMode.value == HomeMode.news || _ctrl.homeMode.value == HomeMode.posts;

          if (!isShow) {
            return Container();
          }

          return IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              await Get.to(() => SearchScreen());
            },
          );
        }),
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
            await Get.to(() => const SettingsScreen());
          },
        ),
      ],
    );
  }

  Widget _getBottomBar(int index) {
    return AnimatedContainer(
      height: _ctrl.isBottomBarVisible.value ? kBottomNavigationBarHeight + 20 : 0,
      duration: const Duration(milliseconds: 700),
      curve: Curves.fastLinearToSlowEaseIn,
      child: NavigationBar(
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.article),
            label: 'Статьи',
          ),
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            label: 'Новости',
          ),
          NavigationDestination(
            icon: Icon(Icons.device_hub),
            label: 'Хабы',
          ),
          NavigationDestination(
            icon: Icon(Icons.save),
            label: 'Сохраненные',
          ),
        ],
        selectedIndex: index,
        onDestinationSelected: (int index) async {
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
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            //
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
            //
            // todo: list view
            ...Constant.postFlows
                .map((flow) => ListTile(
                      title: Text(flow.title),
                      onTap: () async {
                        Get.back();

                        _ctrl.resetPage();
                        _ctrl.currentFlow = flow.alias;
                        _ctrl.currentFlowName.value = flow.title;

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
