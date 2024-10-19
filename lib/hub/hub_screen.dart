import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/controllers/hide_bottombar_ctrl.dart';
import 'package:habar/common/widgets/no_data_widget.dart';
import 'package:habar/home/widgets/loading_widget.dart';
import 'package:habar/hub/hub_ctrl.dart';
import 'package:habar/hub/widget/hub_author_llist_widget.dart';
import 'package:habar/hub/widget/hub_company_list_widget.dart';
import 'package:habar/hub/widget/hub_widget.dart';
import 'package:habar/hub/widget/post_list_widget.dart';

class HubScreen extends StatelessWidget {
  final String name;
  final _ctrl = Get.put(HubCtrl());
  final _bottomCtrl = HideBottomBarCtrl();

  HubScreen({super.key, required this.name}) {
    _ctrl.page.value = 1;
    _ctrl.selectedIndex.value = 0;
    _ctrl.setup(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Obx(() => HubInfoWidget(hub: _ctrl.hub.value)),
            Flexible(child: Obx(() => _getCurrentPage(_ctrl.selectedIndex.value))),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => _getBottomBar(_ctrl.selectedIndex.value)),
    );
  }

  Widget _getCurrentPage(int index) {
    if (_ctrl.isLoading.value) {
      return const LoadingWidget();
    }

    switch (index) {
      case 0:
        return PostListWidget(name: name, bottomCtrl: _bottomCtrl);
      case 1:
        return HubAuthorListWidget(name: name, bottomCtrl: _bottomCtrl);
      case 2:
        return HubCompanyListWidget(name: name, bottomCtrl: _bottomCtrl);
      default:
        return const NoDataWidget();
    }
  }

  Widget _getBottomBar(int selectedIndex) {
    return AnimatedContainer(
      height: _bottomCtrl.isBottomBarVisible.value ? kBottomNavigationBarHeight + 20 : 0,
      duration: _bottomCtrl.duration,
      curve: Curves.fastLinearToSlowEaseIn,
      child: NavigationBar(
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.article),
            label: 'Статьи',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Авторы',
          ),
          NavigationDestination(
            icon: Icon(Icons.business),
            label: 'Компании',
          ),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: (int index) => _ctrl.selectedIndex.value = index,
      ),
    );
  }
}
