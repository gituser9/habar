import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/controllers/settings_ctrl.dart';
import 'package:habar/common/widgets/no_data_widget.dart';
import 'package:habar/home/home_ctrl.dart';
import 'package:habar/home/widgets/drawer_widget.dart';
import 'package:habar/home/widgets/filter_widget.dart';
import 'package:habar/home/widgets/hub_widget.dart';
import 'package:habar/home/widgets/loading_widget.dart';
import 'package:habar/home/widgets/posts_widget.dart';
import 'package:habar/home/widgets/saved_search_widget.dart';
import 'package:habar/home/widgets/saved_widget.dart';
import 'package:habar/model/home.dart';
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

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: DrawerWidget(),
      body: RefreshIndicator(
        onRefresh: () async => await _refreshPage(),
        child: Obx(() {
          if (_ctrl.isLoading.value) {
            return const LoadingWidget();
          }

          return _buildBody();
        }),
      ),
      floatingActionButton: Obx(() {
        if (_ctrl.homeMode.value != HomeMode.saved) {
          return Container();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () async => await Get.bottomSheet(
                SavedSearchWidget(),
                backgroundColor: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
              ),
              child: const Icon(Icons.search),
            ),
            //
            if (_ctrl.savedFilteredPosts.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: FloatingActionButton(
                  onPressed: () async => _ctrl.savedFilteredPosts.clear(),
                  child: const Icon(Icons.clear),
                ),
              ),
          ],
        );
      }),
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
        /*Obx(() {
          return DropdownMenu<String>(
            initialSelection: 'Статьи',
            onSelected: (String? value) {
              // This is called when the user selects an item.
              // setState(() {
              //   dropdownValue = value!;
              // });
            },
            dropdownMenuEntries: ['Статьи', 'Посты'].map<DropdownMenuEntry<String>>((String value) {
              return DropdownMenuEntry<String>(value: value, label: value);
            }).toList(),
          );
        }),*/
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
          if (_ctrl.homeMode.value == HomeMode.saved) {
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
        // Obx(() {
        //   //
        //   if (_ctrl.homeMode.value != HomeMode.saved) {
        //     return Container();
        //   }
        //
        //   return IconButton(
        //     icon: const Icon(Icons.download),
        //     onPressed: () async {
        //       await _ctrl.downloadSavedPosts();
        //     },
        //   );
        // }),
        // Obx(() {
        //   //
        //   if (_ctrl.homeMode.value != HomeMode.saved) {
        //     return Container();
        //   }
        //
        //   return IconButton(
        //     icon: const Icon(Icons.upload),
        //     onPressed: () {},
        //   );
        // }),
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
}
