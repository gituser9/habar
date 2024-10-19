import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/controllers/settings_ctrl.dart';
import 'package:habar/common/services/settings_service.dart';
import 'package:habar/common/themes.dart';
import 'package:habar/home/home_screen.dart';
import 'package:habar/model/settings.dart';
import 'package:habar/post/post_ctrl.dart';
import 'package:habar/post/post_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  var srv = Get.put(SettingsService());
  await srv.openBox();

  var setts = srv.get();
  setts.setDefault();

  runApp(MyApp(theme: setts.theme!));
}

class MyApp extends StatelessWidget {
  final ctrl = Get.put(PostCtrl());
  final settingsCtrl = Get.put(SettingsCtrl());
  final AppThemeType theme;

  MyApp({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Habar',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: _getTheme(),
        getPages: [
          GetPage(name: '/post/:id', page: () => PostScreen()),
          GetPage(name: '/ru/post/:id/', page: () => PostScreen()),
          GetPage(name: '/ru/news/:t/:id/', page: () => PostScreen()),
          GetPage(name: '/ru/companies/:name/articles/:id/', page: () => PostScreen()),
          GetPage(name: '/', page: () => SafeArea(child: HomeScreen())),
        ],
        initialRoute: "/",
        opaqueRoute: true,
        routingCallback: (routing) {
          if (routing == null) {
            return;
          }

          if (routing.current == routing.previous) {
            return;
          }

          bool isPostRoute = routing.current.contains('/post/'.toString()) || routing.current.contains('/news/'.toString()) || routing.current.contains('/articles/'.toString());

          if (isPostRoute) {
            String id = routing.current.split('/').where((e) => e.isNotEmpty).firstWhere((e) => int.tryParse(e) != null);

            if (id.isNotEmpty) {
              ctrl.getByID(id);
            }
          }
        });
  }

  ThemeMode _getTheme() {
    return theme == AppThemeType.dark ? ThemeMode.dark : ThemeMode.light;
  }
}
