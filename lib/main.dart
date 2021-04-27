import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home/home_screen.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // GoogleFonts.balsa
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      title: 'Habar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // textTheme: GoogleFonts.droidSansTextTheme(
        //   Theme.of(context).textTheme,
        // ),
      ),
      home: SafeArea(child: HomeScreen()),
    );
  }
}
