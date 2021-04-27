import 'package:habar/model/search_post.dart';
import 'package:habar/model/search_user.dart';
import 'package:habar/search/search_repository.dart';
import 'package:rxdart/subjects.dart';

class SearchBloc {
  final _repo = SearchRepository();
  final postsStream = BehaviorSubject<SearchPostResponse>();
  final usersStream = BehaviorSubject<SearchUserResponse>();
  final postPageStream = BehaviorSubject<int>();
  final userPageStream = BehaviorSubject<int>();
  final queryStringStream = BehaviorSubject<String>();

  int _postPage = 1;
  int _userPage = 1;
  String _queryString = '';

  SearchBloc() {
    _repo.postsStream.listen(postsStream.add);
    _repo.usersStream.listen(usersStream.add);

    postPageStream.listen((newPage) => _postPage = newPage);
    userPageStream.listen((newPage) => _userPage = newPage);
    queryStringStream.listen((newQueryString) => _queryString = newQueryString);
  }

  Future getPosts() async {
    if (_queryString.isEmpty) {
      return;
    }

    await _repo.getPosts(_queryString, _postPage);
  }

  Future getUsers() async {
    if (_queryString.isEmpty) {
      return;
    }

    await _repo.getUsers(_queryString, _userPage);
  }

  void dispose() {
    _repo.dispose();

    postsStream.close();
    usersStream.close();
    postPageStream.close();
    queryStringStream.close();
  }
}
