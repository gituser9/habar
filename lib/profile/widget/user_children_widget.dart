import 'package:flutter/material.dart';
import 'package:habar/common/costants.dart';
import 'package:habar/common/util.dart';
import 'package:habar/model/profile.dart';
import 'package:habar/profile/profile_screen.dart';

class UserChildrenWidget extends StatelessWidget {
  final List<ProfileData> profiles;

  const UserChildrenWidget({Key? key, required this.profiles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        for (final profile in profiles)
          ListTile(
            leading: Util.getAvatar(profile.avatar, 40),
            title: Text(
              '@' + profile.login,
              style: const TextStyle(color: Colors.blue),
            ),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(login: profile.login),
                ),
              );
            },
          ),
      ],
    );
  }
}
