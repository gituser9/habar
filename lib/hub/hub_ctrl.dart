import 'package:get/get.dart';
import 'package:habar/hub/hub_repository.dart';
import 'package:habar/model/hub.dart';
import 'package:habar/model/hub_authors.dart';
import 'package:habar/model/hub_company_list.dart';
import 'package:habar/model/post_list.dart';

class HubCtrl extends GetxController {
  late HubRepository _repo;
  final hub = Hub.empty().obs;
  final posts = PostList(articleIds: [], articleRefs: {}, pagesCount: 0).obs;
  final hubAuthors =
      HubAuthorList(authorIds: [], authorRefs: {}, pagesCount: 0).obs;
  final hubCompanies =
      HubCompanyList(companyIds: [], companyRefs: {}, pagesCount: 0).obs;
  final page = 1.obs;
  final selectedIndex = 0.obs;
  final isLoading = true.obs;

  @override
  void onInit() async {
    super.onInit();

    _repo = HubRepository();
    _repo.hubStream.listen((item) {
      hub.value = item;
      isLoading.value = false;
    });
    _repo.postsStream.listen((item) {
      posts.value = item;
      isLoading.value = false;
    });
    _repo.hubAuthorsStream.listen((item) {
      hubAuthors.value = item;
      isLoading.value = false;
    });
    _repo.hubCompaniesStream.listen((item) {
      hubCompanies.value = item;
      isLoading.value = false;
    });
  }

  @override
  void onClose() {
    super.onClose();

    _repo.dispose();
  }

  Future setup(String name) async {
    isLoading.value = true;
    await getHub(name);
    await getPosts(name, 1);
  }

  Future getHub(String name) async {
    await _repo.getHub(name);
  }

  Future getPosts(String name, int page) async {
    isLoading.value = true;
    await _repo.getArticles(name, page);
  }

  Future getAuthors(String name, int page) async {
    isLoading.value = true;
    await _repo.getAuthors(name, page, 10);
  }

  Future getCompanies(String name, int page) async {
    isLoading.value = true;
    await _repo.getCompanies(name, page, 20);
  }
}
