import 'package:habar/model/post.dart';
import 'package:habar/repositories/base_repo.dart';

class PostRepo extends BaseRepo {
  Future<Post> getById(String id) async {
    final post = await habrClient.post(id);

    return post;
  }
}
