import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/costants.dart';
import 'package:habar/hub/hub_screen.dart';
import 'package:habar/model/hub_list.dart';
import 'package:habar/profile/profile_ctrl.dart';

class UserHubsWidget extends StatelessWidget {
  // final List<HubRef> hubs;
  final String login;
  final ProfileCtrl ctrl = Get.find();

  UserHubsWidget({super.key, required this.login}) {
    ctrl.getProfileHubs(login);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildBody(ctrl.profileHubs));
  }

  Widget _buildBody(List<HubRef> hubs) {
    if (hubs.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text('Состоит в хабах', style: Constant.profileHeadersStyle),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            children: [
              for (final hub in hubs)
                InkWell(
                  onTap: () async {
                    await Get.to(() => HubScreen(name: hub.alias));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                      child: Text(
                        hub.titleHtml,
                        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}
