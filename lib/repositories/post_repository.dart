import 'package:dio/dio.dart';
import 'package:habar/model/post.dart';

import '../common/http_client.dart';

class PostRepo {
  Future<Post> getById(String id) async {
    final dio = Dio(); // Provide a dio instance
    dio.options.headers['Demo-Header'] = 'demo header'; // config your dio headers globally
    final client = HttpClient(dio);

    // final json = await HttpRequest.get('/articles/$id');
    final post = await client.post(id);

    /*if (json.isEmpty) {
      return Post.empty();
    }*/

    // return Post.fromJsonOld(json);
    return post;
  }
}
