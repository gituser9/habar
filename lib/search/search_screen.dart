import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/controllers/settings_ctrl.dart';
import 'package:habar/common/costants.dart';
import 'package:habar/common/services/saved_post_service.dart';
import 'package:habar/common/util.dart';
import 'package:habar/common/widgets/no_data_widget.dart';
import 'package:habar/common/widgets/pagination_widget.dart';
import 'package:habar/common/widgets/post_widget.dart';
import 'package:habar/home/widgets/loading_widget.dart';
import 'package:habar/model/search.dart';
import 'package:habar/model/search_post.dart';
import 'package:habar/model/search_user.dart';
import 'package:habar/model/settings.dart';
import 'package:habar/profile/profile_screen.dart';
import 'package:habar/search/search_ctrl.dart';

class SearchScreen extends StatelessWidget {
  final ctrl = Get.put(SearchCtrl());
  final SettingsCtrl _settingsCtrl = Get.find();
  final SavedPostService _savedPostService = Get.find();

  SearchScreen({Key? key}) : super(key: key) {
    ctrl.posts.value = SearchPostResponse.empty();
    ctrl.users.value = SearchUserResponse.empty();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        // backgroundColor: Get.isDarkMode ? null : Colors.white,
        appBar: _buildAppBar(context),
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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Habar'),
      actions: [
        IconButton(
          icon: const Icon(Icons.tune),
          onPressed: () async => await Get.bottomSheet(
            // FilterWidget(),
            _buildSearchOptions(),
            backgroundColor: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
          ),
        )
      ],
    );
  }

  Widget _getSearchField() {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(left: 8, right: 8, top: 16),
      child: TextField(
        autofocus: true,
        maxLength: 255,
        maxLines: 1,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 17, left: 8),
          suffixIcon: GestureDetector(
            child: const Icon(Icons.search),
            onTap: () async => await ctrl.search(),
          ),
          fillColor: Get.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
          filled: true,
        ),
        onChanged: (data) => ctrl.queryStringStream.add(data),
        onSubmitted: (queryString) async => await ctrl.search(),
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
              final imgUrl = Util.getImgUrl(post.leadData.imageUrl, post.textHtml);

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
                color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
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
                  await Get.to(() => ProfileScreen(login: user.alias));
                },
              );
            }),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Obx(
            () => Material(
              color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
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

  Widget _buildSearchOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          // Text('Сортировка', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          SizedBox(height: 25),
          _buildScoreButton('По релевантности', SearchFilter.relevance),
          _buildScoreButton('По времени', SearchFilter.date),
          _buildScoreButton('По рейтингу', SearchFilter.rating),
          Expanded(child: Container()),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Get.back();

                    await ctrl.search();
                  },
                  icon: const Icon(Icons.done_all, color: Colors.white),
                  label: const Text('Применить', style: const TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.primary,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildScoreButton(String value, SearchFilter filterKey) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Obx(() {
        final isChosen = filterKey == ctrl.searchFilter.value;

        return Container(
          width: Get.width,
          height: 40,
          decoration: BoxDecoration(
            color: isChosen ? AppColors.primary : Colors.grey.withOpacity(0.2),
            borderRadius: const BorderRadius.all(const Radius.circular(6)),
          ),
          child: TextButton(
              onPressed: () {
                ctrl.searchFilter.value = filterKey;
              },
              child: Text(
                value,
                style: TextStyle(color: isChosen ? Colors.white : _getButtonTextColor()),
              )),
        );
      }),
    );
  }

  // todo: utils
  Color _getButtonTextColor() {
    return _settingsCtrl.settings.value.theme == AppThemeType.dark ? Colors.grey.shade400 : Colors.black;
  }
}
