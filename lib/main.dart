import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:habar/common/services/settings_service.dart';
import 'package:habar/post/post_ctrl.dart';
import 'package:habar/post/post_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'home/home_screen.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  var srv = Get.put(SettingsService());
  await srv.openBox();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ctrl = Get.put(PostCtrl());

  @override
  Widget build(BuildContext context) {
    // GoogleFonts.balsa
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    return GetMaterialApp(
        title: 'Habar',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // textTheme: GoogleFonts.droidSansTextTheme(
          //   Theme.of(context).textTheme,
          // ),
        ),
        // theme: ThemeData.dark(),
        home: SafeArea(child: HomeScreen()),
        getPages: [
          GetPage(name: '/post/:id', page: () => PostScreen()),
        ],
        routingCallback: (routing) {
          if (routing?.current.startsWith('/post') ?? false) {
            String id = routing?.current.split('/').last ?? '';
            ctrl.postId.value = id;
          }
        });
  }
}
