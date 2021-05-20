import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/home/widgets/loading_widget.dart';
import 'package:habar/model/profile.dart';
import 'package:habar/profile/profile_ctrl.dart';
import 'package:habar/profile/widget/articles_widget.dart';
import 'package:habar/profile/widget/comments_widget.dart';
import 'package:habar/profile/widget/user_children_widget.dart';
import 'package:habar/profile/widget/user_hubs_widget.dart';
import 'package:habar/profile/widget/user_medals_widget.dart';
import 'package:habar/profile/widget/user_person_widget.dart';
import 'package:habar/profile/widget/user_subscriptions_widget.dart';

class ProfileScreen extends StatelessWidget {
  final String login;
  final ctrl = Get.put(ProfileCtrl());

  ProfileScreen({Key? key, required this.login}) : super(key: key) {
    ctrl.selectedIndex.value = 0;
    ctrl.getProfile(login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(() => _getCurrentPage(ctrl.selectedIndex.value)),
      ),
      bottomNavigationBar: Obx(() => _getBottomBar(ctrl.selectedIndex.value)),
    );
  }

  Widget _getBottomBar(int selectedIndex) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: 'Профиль',
        ),
        const BottomNavigationBarItem(
          icon: const Icon(Icons.article),
          label: 'Публикации',
        ),
        const BottomNavigationBarItem(
          icon: const Icon(Icons.mode_comment_rounded),
          label: 'Комментарии',
        ),
      ],
      currentIndex: selectedIndex,
      unselectedLabelStyle: const TextStyle(color: Colors.grey),
      fixedColor: Colors.blue,
      onTap: (int index) => ctrl.selectedIndex.value = index,
    );
  }

  Widget _getCurrentPage(int index) {
    if (ctrl.isLoading.value) {
      return Center(child: LoadingWidget());
    }

    switch (index) {
      case 1:
        return PostsWidget(login: login);
      case 2:
        return CommentsWidget(login: login);
      default:
        return _buildProfilePage(ctrl.profile.value);
    }
  }

  Widget _buildProfilePage(Profile profile) {
    return Column(
      children: [
        const SizedBox(height: 40),
        UserPersonWidget(profile: profile),
        UserMedalsWidget(profile: profile),
        UserHubsWidget(login: login),
        UserChildrenWidget(login: login),
        UserSubscriptions(login: login),
        const SizedBox(height: 50),
      ],
    );
  }
}
