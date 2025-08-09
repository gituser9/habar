import 'package:habar/model/search_post.dart';
import 'package:habar/model/search_user.dart';
import 'package:habar/repositories/base_repo.dart';
import 'package:rxdart/subjects.dart';

class SearchRepository extends BaseRepo {
  final postsStream = BehaviorSubject<SearchPostResponse>();
  final usersStream = BehaviorSubject<SearchUserResponse>();

  Future getPosts(String searchString, int page, String order) async {
    final searchResponse = await habrClient.articlesSearch(
      query: searchString,
      order: order,
      page: page,
    );
    postsStream.add(searchResponse);
  }

  Future getUsers(String searchString, int page, String order) async {
    final searchResponse = await habrClient.userSearch(
      query: searchString,
      page: page,
      order: order,
    );
    usersStream.add(searchResponse);
  }

  void dispose() {
    postsStream.close();
    usersStream.close();
  }
}
