import 'package:get/get.dart';
import 'package:habar/common/services/saved_post_service.dart';
import 'package:habar/model/post.dart';
import 'package:habar/post/post_repository.dart';

class PostCtrl extends GetxController {
  late PostRepo _repo;
  final SavedPostService _savedPostService = Get.find();
  final post = Post.empty().obs;
  final isLoading = true.obs;
  final isImageLoading = false.obs;
  final postId = ''.obs;
  final isSaved = false.obs;

  @override
  void onInit() {
    super.onInit();

    _repo = PostRepo();

    ever(postId, (_) => getByID(postId.value, isSaved.value));
  }

  Future getByID(String id, bool isSaved) async {
    isLoading.value = true;

    if (id.isEmpty) {
      return;
    }

    if (isSaved) {
      post.value = _savedPostService.getById(id);
    } else {
      post.value = await _repo.getById(id);
    }

    isLoading.value = false;
  }

  Future delete() async {
    await _savedPostService.deleteById(postId.value);
    isSaved.value = false;
  }

  Future save() async {
    await _savedPostService.save(post.value);
    isSaved.value = true;
  }
}
