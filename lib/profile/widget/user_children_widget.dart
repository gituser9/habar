import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/costants.dart';
import 'package:habar/common/util.dart';
import 'package:habar/model/profile_list.dart';
import 'package:habar/profile/profile_ctrl.dart';

class InvitedWidget extends StatelessWidget {
  final String login;
  final ProfileCtrl ctrl = Get.find();

  InvitedWidget({super.key, required this.login}) {
    ctrl.getInvited(login);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildBody(ctrl.inviteds));
  }

  Widget _buildBody(List<Invited> profiles) {
    if (profiles.isEmpty) {
      return Container();
    }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Пригласил на сайт',
              style: Constant.profileHeadersStyle,
            ),
          ),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: profiles.length,
          itemBuilder: (ctx, index) {
            final profile = profiles[index];
            final fullName = profile.flullname.isEmpty ? '' : ' ' + profile.flullname;

            return ListTile(
              leading: Util.getAvatar(profile.avatarUrl, 40),
              title: Text(
                fullName + '@' + profile.alias,
                style: const TextStyle(color: Colors.blue),
              ),
              subtitle: Text(
                profile.speciality,
                style: TextStyle(color: Colors.grey.shade400),
              ),
              // onTap: () async {
              //   await Get.to(() => ProfileScreen(login: profile.login));
              // },
            );
          },
        )
      ],
    );
  }
}
