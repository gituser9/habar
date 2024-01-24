import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:habar/common/http_request.dart';
import 'package:habar/common/services/pin_hub_service.dart';
import 'package:habar/common/services/post_position_service.dart';
import 'package:habar/common/services/saved_post_service.dart';
import 'package:habar/common/services/settings_service.dart';
import 'package:habar/home/home_repository.dart';
import 'package:habar/model/filter.dart';
import 'package:habar/model/home.dart';
import 'package:habar/model/hub_list.dart';
import 'package:habar/model/post.dart';
import 'package:habar/model/post_list.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

class HomeCtrl extends GetxController {
  final _repo = HomeRepo();
  final _savedPostService = Get.put(SavedPostService());
  final _positionService = Get.put(PostPositionService());
  final _pinHubService = Get.put(PinHubService());
  final SettingsService _settingsService = Get.find();

  final posts = PostList.empty().obs;
  final hubs = HubList.empty().obs;
  final pinnedHubs = HubList.empty().obs;
  final filter = ListFilter.all.obs;
  final flowFilter = FlowFilter().obs;
  final savedPosts = List<Post>.empty().obs;
  final savedFilteredPosts = List<Post>.empty().obs;
  final savedSearchHubs = <String>{}.obs;
  final savedSearchTags = <String>{}.obs;
  final hubSearchStream = BehaviorSubject<String>();
  final homeMode = HomeMode.posts.obs;
  final page = 1.obs;
  final selectedIndex = 0.obs;
  final isLoading = true.obs;
  final isLoadMore = false.obs;
  final postFilter = UserFilter().obs;
  final scrollCtrl = ScrollController();
  final currentFlowName = ''.obs;
  final bottomOffset = 200;
  final isShowPinnedHub = false.obs;
  final isBottomBarVisible = true.obs;

  int _page = 1;
  int _pageCount = 0;
  String currentFlow = '';
  String? flowPeriod;
  String? flowScore;
  HomeMode pageMode = HomeMode.posts;

  @override
  void onInit() {
    super.onInit();

    var sets = _settingsService.get();
    postFilter.value = sets.filters == null ? UserFilter() : UserFilter.fromFilter(sets.filters!);

    _repo.postsStream.listen((PostList postList) {
      posts.value = postList;
      _pageCount = postList.pagesCount;
      isLoading.value = false;
      isLoadMore.value = false;
    });

    _repo.hubsStream.listen((HubList hubList) {
      hubs.value = hubList;
      isLoading.value = false;
    });

    hubSearchStream.debounceTime(const Duration(seconds: 1)).listen((String searchString) async {
      if (searchString.isEmpty) {
        await getHubs();
        return;
      }

      isLoading.value = true;
      await _repo.searchHubs(searchString);
    });

    scrollCtrl.addListener(() async {
      if (scrollCtrl.position.userScrollDirection == ScrollDirection.forward) {
        if (isBottomBarVisible.isFalse) {
          showNavBar();
        }
      } else {
        if (isBottomBarVisible.isTrue) {
          hideNavBar();
        }
      }

      if (isLoadMore.isTrue) {
        return;
      }

      bool isEnd = (scrollCtrl.offset + bottomOffset) >= scrollCtrl.position.maxScrollExtent;

      if (isEnd) {
        isLoadMore.value = true;
        ++_page;

        if (currentFlow == '') {
          await _repo.loadMore(postFilter.value.filterKey.value, _page, pageMode == HomeMode.news, posts.value);
        } else {
          await _repo.loadMoreFlow(currentFlow, _page, posts.value, score: flowScore, period: flowPeriod);
        }
      }
    });

    setup(sets.filters ?? Filter());
  }

  @override
  void onClose() {
    super.onClose();

    _repo.dispose();
    HttpRequest.close();
  }

  Future setup(Filter filters) async {
    pageMode = HomeMode.posts;

    await _savedPostService.openBox();
    await _positionService.openBox();
    await _pinHubService.openBox();

    await getAll(filters.filterKey);
  }

  Future getAll(ListFilter filterKey, {int? page}) async {
    page ??= _page;

    if (page != 1 && page > _pageCount) {
      return;
    }

    isLoading.value = true;

    if (pageMode == HomeMode.news) {
      await _repo.getAll(filterKey, page, PostContentType.news);
    } else {
      await _repo.getAll(filterKey, page, PostContentType.articles);
    }
  }

  Future getFlow(String flow, {int? page, String? score, String? period, bool? isFlowNews}) async {
    page ??= _page;

    if (page != 1 && page > _pageCount) {
      return;
    }

    isLoading.value = true;
    await _repo.getFlow(flow, page, score, period, isFlowNews);
  }

  Future getHubs({int page = 1, ListHubFilter? filterKey}) async {
    if (page <= 0) {
      return;
    }

    isLoading.value = true;
    await _repo.getHubs(page, filterKey: filterKey);
  }

  List<HubRef> getListOfHubs(HubList hubList) {
    _pageCount = hubList.pagesCount;
    return hubList.hubIds.map((String hubId) => hubList.hubRefs[hubId]!).toList();
  }

  void getSaved() {
    isLoading.value = false;

    final posts = _savedPostService.getAll();
    posts.sort((left, right) => left.timePublished.isBefore(right.timePublished) ? 1 : 0);

    savedPosts.value = posts;
  }

  void resetPage() {
    _page = 1;
    page.value = 1;
  }

  void showNavBar() {
    isBottomBarVisible.value = true;
  }

  void hideNavBar() {
    isBottomBarVisible.value = false;
  }

  Future downloadSavedPosts() async {
    _checkStoragePermission();

    var postMaps = [];

    for (var post in savedPosts) {
      postMaps.add(post.toMap());
    }
    var jsonString = json.encode(postMaps);
    var directory = await getDownloadsDirectory();

    if (directory == null) {
      final snackBar = SnackBar(
        content: Text('Выгрузка постов завершилась ошибкой',
            style: TextStyle(
              color: Get.isDarkMode ? Colors.white : null,
            )),
        backgroundColor: Get.isDarkMode ? Colors.black : null,
      );
      ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);

      return;
    }

    var file = File("${directory.path}/habar_posts.json");
    file.writeAsString(jsonString);

    final snackBar = SnackBar(
      content: Text('Посты сохранены в папку загрузок',
          style: TextStyle(
            color: Get.isDarkMode ? Colors.white : null,
          )),
      backgroundColor: Get.isDarkMode ? Colors.black : null,
    );
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }

  Future<bool> _checkStoragePermission() async {
    var status = await Permission.storage.status;

    if (status.isPermanentlyDenied) {
      return false;
    }

    if (status.isDenied) {
      status = await Permission.storage.request();
    }

    if (status.isDenied) {
      return false;
    }

    return true;
  }

  void loadSavedSearchData() {
    for (Post post in savedPosts) {
      savedSearchHubs.addAll(post.hubs.map((e) => e.title));
      savedSearchTags.addAll(post.tags.map((e) => e.titleHtml));
    }
  }

  void filterSaved(SavedFilter filter) {
    List<Post> filtered = [];
    filter.title = filter.title.toLowerCase();

    for (Post post in savedPosts) {
      if (filter.title.isNotEmpty) {
        if (post.titleHtml.toLowerCase().contains(filter.title)) {
          filtered.add(post);
          continue;
        }
      }

      if (filter.hub.isNotEmpty) {
        if (post.hubs.any((hub) => hub.title == filter.hub)) {
          filtered.add(post);
          continue;
        }
      }

      if (filter.tag.isNotEmpty) {
        if (post.tags.any((tag) => tag.titleHtml == filter.tag)) {
          filtered.add(post);
          continue;
        }
      }
    }

    savedFilteredPosts.value = filtered;
  }
}
