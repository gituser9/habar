import 'package:habar/common/http_request.dart';
import 'package:habar/model/hub.dart';
import 'package:habar/model/hub_authors.dart';
import 'package:habar/model/hub_company_list.dart';
import 'package:habar/model/post_list.dart';
import 'package:rxdart/rxdart.dart';

class HubRepository {
  final hubStream = BehaviorSubject<Hub>();
  final postsStream = BehaviorSubject<PostList>();
  final hubAuthorsStream = BehaviorSubject<HubAuthorList>();
  final hubCompaniesStream = BehaviorSubject<HubCompanyList>();

  Future getHub(String name) async {
    String json = await HttpRequest.get('/hubs/$name/profile');

    if (json.isEmpty) {
      return;
    }

    var hub = Hub.fromJson(json);
    hubStream.add(hub);
  }

  Future getArticles(String hubName, int page) async {
    Map<String, String> params = {
      'page': page.toString(),
      'sort': 'all',
      'hub': hubName,
    };

    String json = await HttpRequest.get('/articles', params: params);

    if (json.isEmpty) {
      return;
    }

    var posts = PostList.fromJson(json);
    postsStream.add(posts);
  }

  Future getAuthors(String hubName, int page, int perPage) async {
    Map<String, String> params = {
      'page': page.toString(),
      'perPage': perPage.toString(),
    };

    String json = await HttpRequest.get('/hubs/$hubName/authors', params: params);

    if (json.isEmpty) {
      return;
    }

    var authors = HubAuthorList.fromJson(json);
    hubAuthorsStream.add(authors);
  }

  Future getCompanies(String hubName, int page, int perPage) async {
    Map<String, String> params = {
      'page': page.toString(),
      'perPage': perPage.toString(),
      'sector': 'value',
      'order': 'raiting',
      'orderDirection': 'desc',
      'hubAlias': hubName,
    };

    String json = await HttpRequest.get('/hubs/$hubName/companies', params: params);

    if (json.isEmpty) {
      return;
    }

    var compannies = HubCompanyList.fromJson(json);
    hubCompaniesStream.add(compannies);
  }

  void dispose() {
    hubStream.close();
    postsStream.close();
    hubAuthorsStream.close();
    hubCompaniesStream.close();
  }
}
