import 'package:get/get.dart';
import 'package:habar/model/post.dart';
import 'package:hive/hive.dart';

class HiveService extends GetxService {
  late Box postBox;

  @override
  void onInit() async {
    super.onInit();

    Hive.registerAdapter(PostAdapter());
    Hive.registerAdapter(AuthorAdapter());
    Hive.registerAdapter(ScoreStatsAdapter());
    Hive.registerAdapter(HubDataAdapter());
    Hive.registerAdapter(PostLabelAdapter());
    Hive.registerAdapter(StatisticsAdapter());
    Hive.registerAdapter(TagAdapter());
    Hive.registerAdapter(LeadDataAdapter());
  }

  @override
  void onClose() async {
    super.onClose();

    if (postBox.isOpen) {
      await postBox.close();
    }
  }

  Future openBoxes() async {
    postBox = await Hive.openBox('posts');
  }

  Future<int> clear(Box box) async {
    return await box.clear();
  }

  Future saveAll<T>(Box box, Map<String, T> data) async {
    await box.putAll(data);
  }

  Future save<T>(Box box, dynamic key, T data) async {
    await box.put(key, data);
  }

  List<T> getAll<T>(Box box) {
    final maps = box.toMap();

    if (maps.isEmpty) {
      return [];
    }

    List<T> result = maps.values.map((e) => e as T).toList();

    // maps.values.forEach((value) {
    //   final item = value as T;
    //   result.add(item);
    // });

    // for (final ite)

    return result;
  }

  T? getByKey<T>(Box box, dynamic key) {
    if (!box.containsKey(key)) {
      return null;
    }

    return box.get(key);
  }

  Future deleteByKey(Box box, dynamic key) async {
    await box.delete(key);
  }
}
