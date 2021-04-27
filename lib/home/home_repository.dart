import 'package:habar/common/http_request.dart';
import 'package:habar/model/filter.dart';
import 'package:habar/model/hub_list.dart';
import 'package:habar/model/post_list.dart';
import 'package:rxdart/rxdart.dart';

class HomeRepo {
  final postsStream = BehaviorSubject<PostList>();
  final hubsStream = BehaviorSubject<HubList>();
  final errorStream = BehaviorSubject<String>();

  Future getAll(ListFilter filterKey, int page, bool isNews) async {
    Map<String, String> params = {
      'page': page.toString(),
    };
    params.addAll(listFilterData[filterKey]!);

    if (isNews) {
      params['news'] = isNews.toString();
    }

    String json = await HttpRequest.get('/articles', params: params);

    if (json.isEmpty) {
      return;
    }

    final posts = PostList.fromJson(json);

    postsStream.add(posts);
  }

  Future getHubs(int page, {ListHubFilter? filterKey}) async {
    filterKey ??= ListHubFilter.rateDesc;

    Map<String, String> params = {
      'page': page.toString(),
    };
    params.addAll(listHubFilterData[filterKey]!);

    String json = await HttpRequest.get('/hubs/', params: params);

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
