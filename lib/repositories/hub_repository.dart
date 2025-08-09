import 'package:habar/model/hub.dart';
import 'package:habar/model/hub_authors.dart';
import 'package:habar/model/hub_company_list.dart';
import 'package:habar/model/post_list.dart';
import 'package:habar/repositories/base_repo.dart';
import 'package:rxdart/rxdart.dart';

class HubRepository extends BaseRepo {
  final hubStream = BehaviorSubject<Hub>();
  final postsStream = BehaviorSubject<PostList>();
  final hubAuthorsStream = BehaviorSubject<HubAuthorList>();
  final hubCompaniesStream = BehaviorSubject<HubCompanyList>();

  Future getHub(String name) async {
    var hub = await habrClient.hub(name);

    hubStream.add(hub);
  }

  Future getArticles(String hubName, int page) async {
    var posts = await habrClient.hubArticles(page, 'all', hubName);

    postsStream.add(posts);
  }

  Future getAuthors(String hubName, int page, int perPage) async {
    var authors = await habrClient.hubAuthors(hubName, page, perPage);

    hubAuthorsStream.add(authors);
  }

  Future getCompanies(String hubName, int page, int perPage) async {
    var companies = await habrClient.hubCompanies(hubName, page, perPage, 'value', 'raiting', 'desc', hubName);

    hubCompaniesStream.add(companies);
  }

  void dispose() {
    hubStream.close();
    postsStream.close();
    hubAuthorsStream.close();
    hubCompaniesStream.close();
  }
}
