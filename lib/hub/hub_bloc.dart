import 'package:habar/hub/hub_repository.dart';
import 'package:habar/model/hub.dart';
import 'package:habar/model/hub_authors.dart';
import 'package:habar/model/hub_company_list.dart';
import 'package:habar/model/post_list.dart';
import 'package:rxdart/subjects.dart';

class HubBloc {
  final _repo = HubRepository();
  final hubStream = BehaviorSubject<Hub>();
  final postsStream = BehaviorSubject<PostList>();
  final hubAuthorsStream = BehaviorSubject<HubAuthorList>();
  final hubCompaniesStream = BehaviorSubject<HubCompanyList>();
  final pageStream = BehaviorSubject<int>();

  HubBloc() {
    _repo.hubStream.listen(hubStream.add);
    _repo.postsStream.listen(postsStream.add);
    _repo.hubAuthorsStream.listen(hubAuthorsStream.add);
    _repo.hubCompaniesStream.listen(hubCompaniesStream.add);
  }

  Future setup(String name) async {
    await getHub(name);
    await getPosts(name, 1);
  }

  Future getHub(String name) async {
    await _repo.getHub(name);
  }

  Future getPosts(String name, int page) async {
    // postsStream.add([]);
    await _repo.getArticles(name, page);
  }

  Future getAuthors(String name, int page) async {
    await _repo.getAuthors(name, page, 10);
  }

  Future getCompanies(String name, int page) async {
    await _repo.getCompanies(name, page, 20);
  }

  void dispose() {
    _repo.dispose();
    hubStream.close();
    postsStream.close();
    hubAuthorsStream.close();
    hubCompaniesStream.close();
    pageStream.close();
  }
}
