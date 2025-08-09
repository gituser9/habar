import 'package:habar/common/costants.dart';
import 'package:habar/model/filter.dart';
import 'package:habar/model/home.dart';
import 'package:habar/model/hub_list.dart';
import 'package:habar/model/post_list.dart';
import 'package:habar/repositories/base_repo.dart';
import 'package:rxdart/rxdart.dart';

class HomeRepo extends BaseRepo {
  final postsStream = BehaviorSubject<PostList>();
  final hubsStream = BehaviorSubject<HubList>();
  final errorStream = BehaviorSubject<String>();

  Future getAll(ListFilter filterKey, int page, PostContentType postType) async {
    String types = '';

    switch (postType) {
      case PostContentType.articles:
        types = 'articles';
        break;
      case PostContentType.news:
        types = 'news';
        break;
      case PostContentType.posts:
        types = 'posts';
        break;
    }

    final filters = listFilterData[filterKey]!;
    final posts = await habrClient.articlesByFilters(
      page: page,
      types: types,
      complexity: 'all',
      myFeed: false,
      score: filters['score'] ?? '0',
    );

    postsStream.add(posts);
  }

  Future getFlow(String flow, int page, String? score, String? period, bool? isFlowNews) async {
    final posts = await habrClient.articlesByFilters(
      page: page,
      flow: flow,
      sort: 'all',
      flowNews: isFlowNews,
      score: score,
      period: period,
    );

    postsStream.add(posts);
  }

  Future loadMore(ListFilter filterKey, int page, bool isNews, PostList list) async {
    String types = '';

    if (isNews) {
      types = 'news';
    } else {
      types = 'articles';
    }

    final posts = await habrClient.articlesByFilters(
      page: page,
      types: types,
      complexity: 'all',
      myFeed: false,
    );
    final newList = PostList(
      publicationIds: list.publicationIds,
      publicationRefs: list.publicationRefs,
      pagesCount: list.pagesCount,
    );

    newList.publicationIds.addAll(posts.publicationIds);
    newList.publicationRefs.addAll(posts.publicationRefs);

    postsStream.add(newList);
  }

  Future loadMoreFlow(String flow, int page, PostList list, {bool? isFlowNews, String? score, String? period}) async {
    final posts = await habrClient.articlesByFilters(
      page: page,
      flow: flow,
      sort: 'all',
      perPage: Constant.pageSize,
      flowNews: isFlowNews,
      score: score,
      period: period,
    );
    final newList = PostList(
      publicationIds: list.publicationIds,
      publicationRefs: list.publicationRefs,
      pagesCount: list.pagesCount,
    );

    newList.publicationIds.addAll(posts.publicationIds);
    newList.publicationRefs.addAll(posts.publicationRefs);

    postsStream.add(newList);
  }

  Future getHubs(int page, {ListHubFilter? filterKey}) async {
    filterKey ??= ListHubFilter.rateDesc;
    final sort = listHubFilterData[filterKey]!;
    final hubs = await habrClient.hubsByFilters(page, Constant.hubPageSize, sort['sort'] ?? 'rating', sort['order'] ?? 'desc');

    hubsStream.add(hubs);
  }

  Future searchHubs(String queryString) async {
    var hubs = await habrClient.hubSearch(queryString);

    hubsStream.add(hubs);
  }

  void dispose() {
    postsStream.close();
    hubsStream.close();
    errorStream.close();
  }
}
