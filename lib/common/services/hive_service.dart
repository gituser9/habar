import 'package:get/get.dart';
import 'package:habar/model/post.dart';
import 'package:habar/model/post_position.dart';
import 'package:habar/model/settings.dart';
import 'package:hive/hive.dart';

class HiveService extends GetxService {
  late Box postBox;
  late Box postPositionBox;
  late Box settingsBox;

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
    Hive.registerAdapter(PostPositionAdapter());
    Hive.registerAdapter(SettingsAdapter());
    Hive.registerAdapter(AppThemeTypeAdapter());
  }

  @override
  void onClose() async {
    super.onClose();

    if (postBox.isOpen) {
      await postBox.close();
    }
  }

  Future openBoxes(String boxName) async {
    switch (boxName) {
      case 'posts':
        postBox = await Hive.openBox(boxName);
        break;
      case 'settings':
        settingsBox = await Hive.openBox(boxName);
        break;
      case 'post_position':
        postPositionBox = await Hive.openBox(boxName);
        break;
    }
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
