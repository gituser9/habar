import 'package:habar/common/http_request.dart';
import 'package:habar/model/search_post.dart';
import 'package:habar/model/search_user.dart';
import 'package:rxdart/subjects.dart';

class SearchRepository {
  final postsStream = BehaviorSubject<SearchPostResponse>();
  final usersStream = BehaviorSubject<SearchUserResponse>();

  Future getPosts(String searchString, int page) async {
    Map<String, String> params = {
      'query': searchString,
      'order': 'relevance',
      'page': page.toString(),
    };
    final jsonString = await HttpRequest.get('/articles', params: params);

    if (jsonString.isEmpty) {
      return;
    }

    final searchResponse = SearchPostResponse.fromJson(jsonString);
    postsStream.add(searchResponse);
  }

  Future getUsers(String searchString, int page) async {
    Map<String, String> params = {
      'q': searchString,
      'page': page.toString(),
      'target_type': 'users',
    };
    final jsonString = await HttpRequest.get('/users/search', params: params);

    if (jsonString.isEmpty) {
      return;
    }

    final searchResponse = SearchUserResponse.fromJson(jsonString);
    usersStream.add(searchResponse);
  }

  void dispose() {
    postsStream.close();
    usersStream.close();
  }
}
