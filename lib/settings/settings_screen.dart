import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/controllers/settings_ctrl.dart';
import 'package:habar/common/themes.dart';
import 'package:habar/model/settings.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsCtrl _ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки', style: TextStyle(color: Get.isDarkMode ? Colors.grey : Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: GetBuilder<SettingsCtrl>(
          init: _ctrl,
          builder: (_) => _buildBody(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _ctrl.save();
  }

  Widget _buildBody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Obx(() => SwitchListTile(
                title: const Text('Показывать изображения в ленте'),
                value: _ctrl.settings.value.isShowImage,
                onChanged: (bool newValue) {
                  _ctrl.settings.value.isShowImage = newValue;
                  _ctrl.update();
                  _ctrl.save();
                },
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Obx(() => SwitchListTile(
                title: const Text('Показывать краткое описание в ленте'),
                value: _ctrl.settings.value.isShowPostPreview,
                onChanged: (bool newValue) {
                  _ctrl.settings.value.isShowPostPreview = newValue;
                  _ctrl.update();
                  _ctrl.save();
                },
              )),
        ),
        const Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: const Text('Размер текста в постах', style: const TextStyle(fontSize: 16)),
          ),
        ),
        Obx(() => Column(
              children: [
                Slider(
                  value: _ctrl.settings.value.postTextSize,
                  min: 2.0,
                  max: 100.0,
                  label: _ctrl.settings.value.postTextSize.round().toString(),
                  onChanged: (double value) {
                    _ctrl.settings.value.postTextSize = value.roundToDouble();
                    _ctrl.update();
                    _ctrl.save();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: _ctrl.settings.value.theme == AppThemeType.dark
                                ? Colors.grey.shade800
                                : Colors.grey.shade200,
                            borderRadius: const BorderRadius.all(const Radius.circular(4)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Есть много вариантов Lorem Ipsum, но большинство из них имеет не всегда приемлемые модификации, '
                              'например, юмористические вставки или слова, которые даже отдалённо не напоминают латынь.',
                              style: TextStyle(fontSize: _ctrl.settings.value.postTextSize),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
        const Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: const Text('Размер текста в комментариях', style: const TextStyle(fontSize: 16)),
          ),
        ),
        Obx(() => Column(
              children: [
                Slider(
                  value: _ctrl.settings.value.commentTextSize,
                  min: 2.0,
                  max: 100.0,
                  label: _ctrl.settings.value.commentTextSize.round().toString(),
                  onChanged: (double value) {
                    _ctrl.settings.value.commentTextSize = value.roundToDouble();
                    _ctrl.update();
                    _ctrl.save();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: _ctrl.settings.value.theme == AppThemeType.dark
                                ? Colors.grey.shade800
                                : Colors.grey.shade200,
                            borderRadius: const BorderRadius.all(const Radius.circular(4)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Есть много вариантов Lorem Ipsum, но большинство из них имеет не всегда приемлемые модификации, '
                              'например, юмористические вставки или слова, которые даже отдалённо не напоминают латынь.',
                              style: TextStyle(fontSize: _ctrl.settings.value.commentTextSize),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Obx(() => SwitchListTile(
                title: const Text('Использовать бесконечную прокрутку'),
                value: _ctrl.settings.value.isInfinityScroll!,
                onChanged: (bool newValue) {
                  _ctrl.settings.value.isInfinityScroll = newValue;
                  _ctrl.update();
                  _ctrl.save();
                },
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Obx(() => SwitchListTile(
                title: const Text('Темная тема'),
                value: _ctrl.settings.value.theme == AppThemeType.dark,
                onChanged: (bool isDark) {
                  if (isDark) {
                    _ctrl.settings.value.theme = AppThemeType.dark;
                    Get.changeTheme(AppTheme.dark);
                  } else {
                    _ctrl.settings.value.theme = AppThemeType.light;
                    Get.changeTheme(AppTheme.light);
                  }

                  _ctrl.update();
                  _ctrl.save();
                },
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            child: const Text('Сбросить настройки'),
            onPressed: () async {
              _ctrl.settings.value = Settings.empty();
              _ctrl.update();
              await _ctrl.drop();
            },
          ),
        ),
      ],
    );
  }
}
