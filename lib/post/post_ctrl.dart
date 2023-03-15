import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/services/post_position_service.dart';
import 'package:habar/common/services/saved_post_service.dart';
import 'package:habar/model/post.dart';
import 'package:habar/model/post_position.dart';
import 'package:habar/post/post_repository.dart';

class PostCtrl extends GetxController {
  final _repo = PostRepo();
  final _savedPostService = Get.put(SavedPostService());
  final _positionService = Get.put(PostPositionService());
  final post = Post.empty().obs;
  final isLoading = false.obs;

  final postId = ''.obs;
  final isSaved = false.obs;
  final savedIds = RxSet<String>();
  final position = 0.0.obs;
  var scrollCtrl = ScrollController();

  @override
  void onInit() async {
    await _positionService.openBox();

    scrollCtrl.addListener(() {
      if (isSaved.value) {
        position.value = scrollCtrl.offset;

        print(position);

        Future.delayed(const Duration(seconds: 1), () async {
          if (position.value == 0) {
            return;
          }

          await _positionService.save(PostPosition(position: position.value, postId: postId.value));
        });
      }
    });

    ever(postId, (_) async => await getByID(postId.value));

    super.onInit();
  }

  Future getByID(String id) async {
    postId.value = id;

    isLoading.value = true;

    if (id.isEmpty) {
      return;
    }

    isSaved.value = _savedPostService.isSaved(id);

    if (isSaved.value) {
      final postPosition = _positionService.getById(id);
      position.value = postPosition.position;
      post.value = _savedPostService.getById(id);

      await Future.delayed(const Duration(milliseconds: 100), () => scrollCtrl.jumpTo(position.value));
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

    final postPosition = _positionService.getById(id);
    position.value = postPosition.position;

    await Future.delayed(const Duration(milliseconds: 100), () {
      scrollCtrl.jumpTo(position.value);
    });
  }

}
