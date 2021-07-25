import 'package:get/get.dart';
import 'package:habar/common/services/settings_service.dart';
import 'package:habar/model/settings.dart';

class SettingsCtrl extends GetxController {
  final settings = Settings.empty().obs;
  final SettingsService _service = Get.find();

  @override
  void onInit() {
    super.onInit();

    get();
  }

  @override
  void onClose() {
    super.onClose();

    save();
  }

  void get() {
    settings.value = _service.get();
  }

  Future save() async {
    await _service.save(settings.value);
  }

  Future drop() async {
    settings.value = Settings.empty();
    await _service.drop();
  }
}
