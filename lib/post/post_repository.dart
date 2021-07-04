import 'package:habar/common/http_request.dart';
import 'package:habar/model/post.dart';

class PostRepo {
  Future<Post> getById(String id) async {
    final json = await HttpRequest.get('/articles/$id');

    if (json.isEmpty) {
      return Post.empty();
    }

    return Post.fromJson(json);
  }
}
