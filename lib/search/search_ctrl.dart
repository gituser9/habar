import 'package:get/get.dart';
import 'package:habar/model/search_post.dart';
import 'package:habar/model/search_user.dart';
import 'package:habar/search/search_repository.dart';
import 'package:rxdart/rxdart.dart';

class SearchCtrl extends GetxController {
  late SearchRepository _repo;
  final posts = SearchPostResponse.empty().obs;
  final users = SearchUserResponse.empty().obs;
  final postPage = 1.obs;
  final userPage = 1.obs;
  final selectedIndex = 0.obs;
  final queryStringStream = BehaviorSubject<String>();
  final isLoading = false.obs;
  String _queryString = '';

  @override
  void onInit() async {
    _repo = SearchRepository();
    _repo.postsStream.listen((postList) => posts.value = postList);
    _repo.usersStream.listen((userList) => users.value = userList);

    queryStringStream.listen((value) => _queryString = value);

    super.onInit();
  }

  @override
  void onClose() {
    _repo.dispose();
    queryStringStream.close();

    super.onClose();
  }

  Future getPosts() async {
    if (_queryString.isEmpty) {
      return;
    }

    await _repo.getPosts(_queryString, postPage.value);
  }

  Future getUsers() async {
    if (_queryString.isEmpty) {
      return;
    }

    await _repo.getUsers(_queryString, userPage.value);
  }
}
