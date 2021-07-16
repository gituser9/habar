import 'package:get/get.dart';
import 'package:habar/common/services/hive_service.dart';
import 'package:habar/model/post_position.dart';

class PostPositionService extends GetxService {
  final _hiveService = Get.put(HiveService());

  Future openBox() async {
    await _hiveService.openBoxes('post_position');
  }

  PostPosition getById(String id) {
    var data = _hiveService.getByKey<PostPosition>(_hiveService.postPositionBox, id);

    if (data == null) {
      return PostPosition.empty();
    }

    return data;
  }

  Future save(PostPosition post) async {
    await _hiveService.save<PostPosition>(_hiveService.postPositionBox, post.postId, post);
  }

  Future deleteById(String id) async {
    await _hiveService.deleteByKey(_hiveService.postPositionBox, id);
  }
}
