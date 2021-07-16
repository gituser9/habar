import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/services/post_position_service.dart';
import 'package:habar/common/services/saved_post_service.dart';
import 'package:habar/model/post.dart';
import 'package:habar/model/post_position.dart';
import 'package:habar/post/post_repository.dart';

class PostCtrl extends GetxController {
  late PostRepo _repo;
  final SavedPostService _savedPostService = Get.find();
  final _positionService = Get.put(PostPositionService());
  final post = Post.empty().obs;
  final isLoading = true.obs;
  final isImageLoading = false.obs;
  final postId = ''.obs;
  final isSaved = false.obs;
  final savedIds = RxSet<String>();
  final position = 0.0.obs;
  final scrollCtrl = ScrollController();

  @override
  void onInit() {
    super.onInit();

    _repo = PostRepo();
    scrollCtrl.addListener(() {
      if (isSaved.value) {
        position.value = scrollCtrl.offset;

        Future.delayed(Duration(seconds: 1), () {
          if (position.value == 0) {
            return;
          }

          _positionService.save(PostPosition(position: position.value, postId: postId.value));
        });
      }
    });

    ever(postId, (_) => getByID(postId.value, isSaved.value));
  }

  Future getByID(String id, bool isSaved) async {
    isLoading.value = true;

    if (id.isEmpty) {
      return;
    }

    if (isSaved) {
      await _positionService.openBox();

      final postPosition = _positionService.getById(id);
      position.value = postPosition.position;
      post.value = _savedPostService.getById(id);

      scrollCtrl.jumpTo(position.value);
    } else {
      post.value = await _repo.getById(id);
    }

    isLoading.value = false;
  }

  Future delete() async {
    await _savedPostService.deleteById(postId.value);
    await _positionService.deleteById(postId.value);
    isSaved.value = false;
  }

  Future save() async {
    await _savedPostService.save(post.value);
    isSaved.value = true;
  }

  Future setPosition(String id) async {
    if (!isSaved.value) {
      return;
    }

    if (post.value.textHtml.isEmpty) {
      return;
    }

    await _positionService.openBox();

    final postPosition = _positionService.getById(id);
    position.value = postPosition.position;

    scrollCtrl.jumpTo(position.value);
  }
}
