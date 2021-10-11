import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/costants.dart';
import 'package:habar/common/services/saved_post_service.dart';
import 'package:habar/common/util.dart';
import 'package:habar/common/widgets/no_data_widget.dart';
import 'package:habar/common/widgets/pagination_widget.dart';
import 'package:habar/common/widgets/post_widget.dart';
import 'package:habar/home/widgets/loading_widget.dart';
import 'package:habar/model/search_post.dart';
import 'package:habar/model/search_user.dart';
import 'package:habar/profile/profile_screen.dart';
import 'package:habar/search/search_ctrl.dart';

class SearchScreen extends StatelessWidget {
  final ctrl = Get.put(SearchCtrl());
  final SavedPostService _savedPostService = Get.find();

  SearchScreen({Key? key}) : super(key: key) {
    ctrl.posts.value = SearchPostResponse.empty();
    ctrl.users.value = SearchUserResponse.empty();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Get.isDarkMode ? null : Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _getSearchField(),
                const SizedBox(height: 4),
                Obx(() => _getCurrentPage(ctrl.selectedIndex.value)),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Obx(() => _getBottomBar(ctrl.selectedIndex.value)),
      ),
    );
  }

  Widget _getSearchField() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(left: 8, right: 8, top: 16),
      child: TextField(
        autofocus: true,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelText: 'Поиск',
          suffixIcon: const Icon(Icons.search),
          fillColor:
              Get.isDarkMode ? Colors.grey.shade900 : Colors.grey.shade200,
          filled: true,
        ),
        onChanged: (data) => ctrl.queryStringStream.add(data),
        onSubmitted: (queryString) async {
          ctrl.isLoading.value = true;
          ctrl.selectedIndex.value = 0;
          ctrl.postPage.value = 1;
          ctrl.userPage.value = 1;

          await Future.wait([
            ctrl.getPosts(),
            ctrl.getUsers(),
          ]);
          ctrl.isLoading.value = false;
        },
      ),
    );
  }

  Widget _getCurrentPage(int index) {
    if (ctrl.isLoading.value) {
      return LoadingWidget();
    }

    switch (index) {
      case 0:
        return _buildPostList(ctrl.posts.value);
      case 1:
        return _buildUserList(ctrl.users.value);
      default:
        return NoDataWidget();
    }
  }

  Widget _buildPostList(SearchPostResponse postResponse) {
    return Column(
      children: [
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: postResponse.articleIds.length,
            itemBuilder: (BuildContext context, int index) {
              String postId = postResponse.articleIds[index];
              final post = postResponse.articleRefs[postId]!;
              final imgUrl =
                  Util.getImgUrl(post.leadData.imageUrl, post.textHtml);

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: Obx(() => PostWidget(
                      article: post,
                      imageUrl: imgUrl,
                      isSaved: _savedPostService.isSaved(post.id),
                    )),
              );
            }),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Obx(() => Material(
                color: Colors.white,
                child: PaginationWidget(
                  page: ctrl.postPage.value,
                  pageCount: postResponse.pagesCount,
                  callback: (int page) async {
                    ctrl.postPage.value = page;
                    await ctrl.getPosts();
                  },
                ),
              )),
        )
      ],
    );
  }

  Widget _buildUserList(SearchUserResponse userResponse) {
    return Column(
      children: [
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: userResponse.userIds.length,
            itemBuilder: (ctx, index) {
              final userId = userResponse.userIds[index];
              final user = userResponse.userRefs[userId]!;

              return ListTile(
                leading: Util.getAvatar(user.avatarUrl, 40),
                title: Row(
                  children: [
                    Text(user.fullname),
                    Text(
                      ' @' + user.alias,
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ],
                ),
                subtitle: Text(user.speciality),
                onTap: () async {
                  await Get.to(() => ProfileScreen(login: user.login));
                },
              );
            }),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Obx(
            () => Material(
              color: Colors.white,
              child: PaginationWidget(
                page: ctrl.userPage.value,
                pageCount: userResponse.pagesCount,
                callback: (int page) async {
                  ctrl.userPage.value = page;
                  await ctrl.getUsers();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getBottomBar(int index) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: const Icon(Icons.article),
          label: 'Публикации',
        ),
        const BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: 'Пользователи',
        ),
      ],
      currentIndex: index,
      unselectedLabelStyle: const TextStyle(color: Colors.grey),
      // fixedColor: Colors.blue,
      onTap: (int newIndex) => ctrl.selectedIndex.value = newIndex,
    );
  }
}
