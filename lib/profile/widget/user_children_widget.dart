import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/costants.dart';
import 'package:habar/common/util.dart';
import 'package:habar/model/profile.dart';
import 'package:habar/profile/profile_ctrl.dart';

class UserChildrenWidget extends StatelessWidget {
  final String login;
  final ProfileCtrl ctrl = Get.find();

  UserChildrenWidget({Key? key, required this.login}) : super(key: key) {
    ctrl.getProfileChildren(login);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildBody(ctrl.profileChildren));
  }

  Widget _buildBody(List<ProfileData> profiles) {
    if (profiles.isEmpty) {
      return Container();
    }

    return Column(
      children: [
        const Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: const Text(
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

            return ListTile(
              leading: Util.getAvatar(profile.avatar, 40),
              title: Text(
                '@' + profile.login,
                style: const TextStyle(color: Colors.blue),
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
