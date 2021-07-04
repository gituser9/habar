import 'package:get/get.dart';
import 'package:habar/common/services/hive_service.dart';
import 'package:habar/model/post.dart';

class SavedPostService extends GetxService {
  final _hiveService = Get.put(HiveService());
  final _savedPostIds = List<String>.empty().obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future openBox() async {
    await _hiveService.openBoxes();

    final posts = _hiveService.getAll<Post>(_hiveService.postBox);
    posts.sort((p1, p2) => p1.timePublished.isBefore(p2.timePublished) ? 1 : 0);
    _savedPostIds.value = posts.map((post) => post.id).toList();
  }

  RxList<String> get savedIds => _savedPostIds;

  bool isSaved(String id) {
    return _savedPostIds.contains(id);
  }

  List<Post> getAll() {
    return _hiveService.getAll<Post>(_hiveService.postBox);
  }

  Post getById(String id) {
    var data = _hiveService.getByKey<Post>(_hiveService.postBox, id);

    if (data == null) {
      return Post.empty();
    }

    return data;
  }

  Future save(Post post) async {
    await _hiveService.save<Post>(_hiveService.postBox, post.id, post);
    _savedPostIds.add(post.id);
  }

  Future deleteById(String id) async {
    await _hiveService.deleteByKey(_hiveService.postBox, id);
    _savedPostIds.remove(id);
  }
}
