import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final AppThemeType theme;

  MyApp({Key? key, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // GoogleFonts.balsa
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.white,
    //   statusBarIconBrightness: Brightness.dark,
    // ));

    return GetMaterialApp(
        title: 'Habar',
        /*theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // textTheme: GoogleFonts.droidSansTextTheme(
          //   Theme.of(context).textTheme,
          // ),
        ),*/
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        // themeMode: ThemeMode.dark,
        themeMode: _getTheme(),
        home: SafeArea(child: HomeScreen()),
        getPages: [
          GetPage(name: '/post/:id', page: () => PostScreen()),
        ],
        routingCallback: (routing) {
          if (routing?.current.startsWith('/post') ?? false) {
            String id = routing?.current.split('/').last ?? '';
            ctrl.postId.value = id;
            ctrl.addPostListener();
          }
        });
  }

  ThemeMode _getTheme() {
    return theme == AppThemeType.dark ? ThemeMode.dark : ThemeMode.light;
  }
}
