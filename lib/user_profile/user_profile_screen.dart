import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/user_profile/user_profile_ctrl.dart';
import 'package:habar/user_profile/widget/login_screen.dart';
import 'package:habar/user_profile/widget/user_data_screen.dart';

class UserProfileScreen extends StatelessWidget {
  final _ctrl = Get.put(UserProfileCtrl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _buildBody()),
      bottomNavigationBar: Obx(() => _buildBottomBar(_ctrl.selectedIndex.value)),
    );
  }

  Widget _buildBottomBar(int index) {
    if (_ctrl.isAuth.isFalse) {
      return Container();
    }

    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Профиль',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article_outlined),
          label: 'Публикации',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'Закладки',
        ),
      ],
      currentIndex: index,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.blue,
      onTap: (int index) async {
        _ctrl.selectedIndex.value = index;
      },
    );
  }

  Widget _buildBody() {
    if (_ctrl.isAuth.isTrue) {
      return UserDataScreen();
    }

    return LoginScreen();
  }
}
