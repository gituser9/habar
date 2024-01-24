import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/controllers/settings_ctrl.dart';
import 'package:habar/common/costants.dart';
import 'package:habar/home/home_ctrl.dart';

import '../../model/post_list.dart';

class DrawerWidget extends StatelessWidget {
  final HomeCtrl _ctrl = Get.find();
  final SettingsCtrl _settingsCtrl = Get.find();

  DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            //
            // user info
            _buildUserWidget(),
            // info flows
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Потоки',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),
            ..._buildFlows(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserWidget() {
    return Stack(
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
        ),
      ],
    );
  }

  List<Widget> _buildFlows() {
    List<Widget> widgets = [];

    for (final flow in Constant.postFlows) {
      widgets.add(ListTile(
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
      ));
    }

    return widgets;
  }
}
