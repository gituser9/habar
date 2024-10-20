import 'package:habar/common/http_request.dart';
import 'package:habar/model/filter.dart';
import 'package:habar/model/home.dart';
import 'package:habar/model/hub_list.dart';
import 'package:habar/model/post_list.dart';
import 'package:rxdart/rxdart.dart';

class HomeRepo {
  final postsStream = BehaviorSubject<PostList>();
  final hubsStream = BehaviorSubject<HubList>();
  final errorStream = BehaviorSubject<String>();

  Future getAll(ListFilter filterKey, int page, PostContentType postType) async {
    Map<String, String> params = {
      'page': page.toString(),
    };

    switch (postType) {
      case PostContentType.articles:
        params['types[0]'] = 'articles';
        params.addAll(listFilterData[filterKey]!);
        break;
      case PostContentType.news:
        params['types[0]'] = 'news';
        params.addAll(listFilterData[filterKey]!);
        break;
      case PostContentType.posts:
        params['types[0]'] = 'posts';
        break;
    }

    params['complexity'] = 'all';
    params['myFeed'] = 'false';

    String json = await HttpRequest.get('/articles', params: params, version: 2);

    if (json.isEmpty) {
      return;
    }

    final posts = PostList.fromJson(json);

    postsStream.add(posts);
  }

  Future getFlow(String flow, int page, String? score, String? period, bool? isFlowNews) async {
    Map<String, String> params = {
      'page': page.toString(),
      'flow': flow,
      'sort': 'all',
    };

    if (isFlowNews ?? false) {
      params['flowNews'] = isFlowNews.toString();
    }

    if (score != null) {
      params['score'] = score.toString();
    }

    if (period != null) {
      params['period'] = period.toString();
    }

    String json = await HttpRequest.get('/articles', params: params);

    if (json.isEmpty) {
      return;
    }

    final posts = PostList.fromJson(json);

    postsStream.add(posts);
  }

  Future loadMore(ListFilter filterKey, int page, bool isNews, PostList list) async {
    Map<String, String> params = {
      'page': page.toString(),
      'perPage': '20',
    };

    if (isNews) {
      params['types[0]'] = 'news';
      params.addAll(listFilterData[filterKey]!);
    } else {
      params['types[0]'] = 'articles';
      params.addAll(listFilterData[filterKey]!);
    }

    params['complexity'] = 'all';
    params['myFeed'] = 'false';

    String json = await HttpRequest.get('/articles/', params: params);

    if (json.isEmpty) {
      return;
    }

    final posts = PostList.fromJson(json);
    final newList = PostList(
      articleIds: list.articleIds,
      articleRefs: list.articleRefs,
      pagesCount: list.pagesCount,
    );

    newList.articleIds.addAll(posts.articleIds);
    newList.articleRefs.addAll(posts.articleRefs);

    postsStream.add(newList);
  }

  Future loadMoreFlow(String flow, int page, PostList list, {bool? isFlowNews, String? score, String? period}) async {
    Map<String, String> params = {
      'page': page.toString(),
      'flow': flow,
      'sort': 'all',
      'perPage': '20',
    };

    if (isFlowNews ?? false) {
      params['flowNews'] = isFlowNews.toString();
    }

    if (score != null) {
      params['score'] = score.toString();
    }

    if (period != null) {
      params['period'] = period.toString();
    }

    String json = await HttpRequest.get('/articles', params: params);

    if (json.isEmpty) {
      return;
    }

    final posts = PostList.fromJson(json);
    final newList = PostList(
      articleIds: list.articleIds,
      articleRefs: list.articleRefs,
      pagesCount: list.pagesCount,
    );

    newList.articleIds.addAll(posts.articleIds);
    newList.articleRefs.addAll(posts.articleRefs);

    postsStream.add(newList);
  }

  Future getHubs(int page, {ListHubFilter? filterKey}) async {
    filterKey ??= ListHubFilter.rateDesc;

    Map<String, String> params = {
      'page': page.toString(),
      'perPage': '30',
    };
    params.addAll(listHubFilterData[filterKey]!);

    String json = await HttpRequest.get('/hubs/', params: params, version: 2);

    if (json.isEmpty) {
      return;
    }

    final hubs = HubList.fromJson(json);

    hubsStream.add(hubs);
  }

  Future searchHubs(String queryString) async {
    String json = await HttpRequest.get('/hubs/search', params: {
      'q': queryString,
    });

    if (json.isEmpty) {
      return;
    }

    var hubs = HubList.fromJson(json);

    hubsStream.add(hubs);
  }

  void dispose() {
    postsStream.close();
    hubsStream.close();
    errorStream.close();
  }
}
