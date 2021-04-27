import 'package:habar/model/post.dart';
import 'package:habar/post/post_repository.dart';
import 'package:rxdart/rxdart.dart';

class PostBloc {
  final _repository = PostRepo();
  final postStream = BehaviorSubject<Post>();
  final errorStream = BehaviorSubject<String>();

  PostBloc() {
    _repository.postsStream.listen(postStream.add);
    _repository.errorStream.listen(errorStream.add);
  }

  // Future setup() async {
  //   var box = await Hive.openBox(HiveKey.storage);
  //   Post postData = box.get(HiveKey.posts);
  //
  //   if (postData != null) {
  //     postStream.add(postData);
  //   }
  //
  //   getByID(1);
  // }

  Future getByID(String id) async {
    if (id.isEmpty) {
      errorStream.add('invalid id');
      return;
    }
    await _repository.getById(id);
  }

  void dispose() {
    _repository.dispose();
    postStream.close();
    errorStream.close();
  }
}
