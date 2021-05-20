import 'package:get/get.dart';
import 'package:habar/model/post.dart';
import 'package:habar/post/post_repository.dart';

class PostCtrl extends GetxController {
  late PostRepo _repo;
  final post = Post.empty().obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    _repo = PostRepo();
    _repo.postsStream.listen((postData) {
      post.value = postData;
      isLoading.value = false;
    });
  }

  @override
  void onClose() {
    super.onClose();

    _repo.dispose();
  }

  Future getByID(String id) async {
    isLoading.value = true;

    if (id.isEmpty) {
      return;
    }
    await _repo.getById(id);
  }
}
