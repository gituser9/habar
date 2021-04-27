import 'package:habar/common/http_request.dart';
import 'package:habar/model/post.dart';
import 'package:rxdart/rxdart.dart';

class PostRepo {
  final postsStream = BehaviorSubject<Post>();
  final errorStream = BehaviorSubject<String>();

  Future getById(String id) async {
    final json = await HttpRequest.get('/articles/$id');

    if (json.isEmpty) {
      return;
    }

    var post = Post.fromJson(json);
    postsStream.add(post);
  }

  void dispose() {
    postsStream.close();
    errorStream.close();
  }
}
