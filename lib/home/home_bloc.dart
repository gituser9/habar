import 'package:habar/common/app_data.dart';
import 'package:habar/home/home_repository.dart';
import 'package:habar/model/filter.dart';
import 'package:habar/model/home.dart';
import 'package:habar/model/hub_list.dart';
import 'package:habar/model/post_list.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {
  final _repository = HomeRepo();
  final postsStream = BehaviorSubject<PostList>();
  final hubsStream = BehaviorSubject<HubList>();
  final filterStream = BehaviorSubject<ListFilter>();
  final errorStream = BehaviorSubject<String>();
  final hubSearchStream = BehaviorSubject<String>();
  final loadingStream = BehaviorSubject<bool>();
  final homeModeStream = BehaviorSubject<HomeMode>();
  final pageStream = BehaviorSubject<int>();

  int _page = 1;
  int _pageCount = 0;
  HomeMode pageMode = HomeMode.posts;

  HomeBloc() {
    _repository.postsStream.listen((PostList postList) {
      postsStream.add(postList);
      loadingStream.add(false);
      _pageCount = postList.pagesCount;
    });

    _repository.hubsStream.listen((HubList hubList) {
      hubsStream.add(hubList);
      loadingStream.add(false);
    });

    _repository.errorStream.listen(errorStream.add);

    hubSearchStream.debounceTime(Duration(seconds: 1)).listen((String searchString) async {
      if (searchString.isEmpty) {
        await getHubs();
        return;
      }

      await _repository.searchHubs(searchString);
    });

    pageStream.add(1);
  }

  Future setup() async {
    pageMode = HomeMode.posts;
    await getAll(AppData.filter.filterKey);
  }

  Future getAll(ListFilter filterKey, {int? page}) async {
    if (page == null) {
      page = _page;
    }

    if (page != 1 && page > _pageCount) {
      errorStream.add('invalid page');
      return;
    }

    loadingStream.add(true);
    await _repository.getAll(filterKey, page, pageMode == HomeMode.news);
  }

  Future getHubs({int page = 1, ListHubFilter? filterKey}) async {
    if (page <= 0) {
      errorStream.add('invalid _page');
      return;
    }

    loadingStream.add(true);
    await _repository.getHubs(page, filterKey: filterKey);
  }

  List<HubRef> getListOfHubs(HubList hubList) {
    _pageCount = hubList.pagesCount;
    return hubList.hubIds.map((String hubId) => hubList.hubRefs[hubId]!).toList();
  }

  void resetPage() {
    _page = 1;
    pageStream.add(1);
  }

  void dispose() {
    _repository.dispose();
    postsStream.close();
    errorStream.close();
    filterStream.close();
    loadingStream.close();
    hubsStream.close();
    homeModeStream.close();
    hubSearchStream.close();
    pageStream.close();
  }
}
