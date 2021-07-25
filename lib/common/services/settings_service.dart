import 'package:get/get.dart';
import 'package:habar/common/services/hive_service.dart';
import 'package:habar/model/settings.dart';

class SettingsService extends GetxService {
  final _hiveService = Get.put(HiveService());
  static const String _settingsKey = '0';

  Future openBox() async {
    await _hiveService.openBoxes('settings');
  }

  Settings get() {
    var data = _hiveService.getByKey<Settings>(_hiveService.settingsBox, _settingsKey);

    if (data == null) {
      return Settings.empty();
    }

    return data;
  }

  Future save(Settings settings) async {
    await _hiveService.save<Settings>(_hiveService.settingsBox, _settingsKey, settings);
  }

  Future drop() async {
    await _hiveService.deleteByKey(_hiveService.postPositionBox, _settingsKey);
  }
}
