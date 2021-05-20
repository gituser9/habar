import 'package:get/get.dart';
import 'package:habar/common/http_request.dart';
import 'package:habar/home/home_repository.dart';
import 'package:habar/model/filter.dart';
import 'package:habar/model/home.dart';
import 'package:habar/model/hub_list.dart';
import 'package:habar/model/post_list.dart';
import 'package:rxdart/rxdart.dart';

class HomeCtrl extends GetxController {
  final _repo = HomeRepo();
  final posts = PostList.empty().obs;
  final hubs = HubList.empty().obs;
  final filter = ListFilter.all.obs;
  // final error = String();
  final hubSearchStream = BehaviorSubject<String>();
  final homeMode = HomeMode.posts.obs;
  final page = 1.obs;
  final selectedIndex = 0.obs;
  final isLoading = true.obs;
  var postFilter = Filter().obs;

  int _page = 1;
  int _pageCount = 0;
  HomeMode pageMode = HomeMode.posts;

  @override
  void onInit() {
    super.onInit();

    _repo.postsStream.listen((PostList postList) {
      posts.value = postList;
      _pageCount = postList.pagesCount;
      isLoading.value = false;
    });

    _repo.hubsStream.listen((HubList hubList) {
      hubs.value = hubList;
      isLoading.value = false;
    });

    // _repo.errorStream.listen(errorStream.add);

    hubSearchStream.debounceTime(Duration(seconds: 1)).listen((String searchString) async {
      if (searchString.isEmpty) {
        await getHubs();
        return;
      }

      isLoading.value = true;
      await _repo.searchHubs(searchString);
    });

    setup();
  }

  @override
  void onClose() {
    super.onClose();

    _repo.dispose();
    HttpRequest.close();
  }

  Future setup() async {
    pageMode = HomeMode.posts;
    await getAll(postFilter.value.filterKey.value);
  }

  Future getAll(ListFilter filterKey, {int? page}) async {
    if (page == null) {
      page = _page;
    }

    if (page != 1 && page > _pageCount) {
      // errorStream.add('invalid page');
      return;
    }

    isLoading.value = true;
    await _repo.getAll(filterKey, page, pageMode == HomeMode.news);
  }

  Future getHubs({int page = 1, ListHubFilter? filterKey}) async {
    if (page <= 0) {
      // errorStream.add('invalid _page');
      return;
    }

    isLoading.value = true;
    // loadingStream.add(true);
    await _repo.getHubs(page, filterKey: filterKey);
  }

  List<HubRef> getListOfHubs(HubList hubList) {
    _pageCount = hubList.pagesCount;
    return hubList.hubIds.map((String hubId) => hubList.hubRefs[hubId]!).toList();
  }

  void resetPage() {
    _page = 1;
    page.value = 1;
  }
}
