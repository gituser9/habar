import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/controllers/hide_bottombar_ctrl.dart';
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
  final _bottomCtrl = HideBottomBarCtrl();

  ProfileScreen({super.key, required this.login}) {
    ctrl.selectedIndex.value = 0;
    ctrl.setup(login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _bottomCtrl.scrollCtrl,
        child: Obx(() => _getCurrentPage(ctrl.selectedIndex.value)),
      ),
      bottomNavigationBar: Obx(() => _getBottomBar(ctrl.selectedIndex.value)),
    );
  }

  Widget _getBottomBar(int selectedIndex) {
    return AnimatedContainer(
      height: _bottomCtrl.isBottomBarVisible.value ? kBottomNavigationBarHeight + 20 : 0,
      duration: _bottomCtrl.duration,
      curve: Curves.fastLinearToSlowEaseIn,
      child: NavigationBar(
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
          NavigationDestination(
            icon: Icon(Icons.article),
            label: 'Публикации',
          ),
          NavigationDestination(
            icon: Icon(Icons.mode_comment_rounded),
            label: 'Комментарии',
          ),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: (int index) => ctrl.selectedIndex.value = index,
      ),
    );
  }

  Widget _getCurrentPage(int index) {
    if (ctrl.isLoading.value) {
      return const Center(child: LoadingWidget());
    }

    switch (index) {
      case 1:
        return PostsWidget(login: login);
      case 2:
        return CommentsWidget(login: login);
      default:
        return _buildProfilePage(ctrl.profile.value, ctrl.whoIs.value);
    }
  }

  Widget _buildProfilePage(Profile profile, WhoIs whoIs) {
    return Column(
      children: [
        const SizedBox(height: 40),
        UserPersonWidget(profile: profile),
        UserWhoIsWidget(whoIs: whoIs),
        UserHubsWidget(login: login),
        InvitedWidget(login: login),
        UserSubscriptions(login: login),
        const SizedBox(height: 50),
      ],
    );
  }
}
