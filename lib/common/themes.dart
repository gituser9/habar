import 'package:flutter/material.dart';

class AppTheme {
  static final light = ThemeData.light().copyWith(
    // scaffoldBackgroundColor: Colors.white,
    bottomAppBarColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      actionsIconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static final dark = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.grey.shade900,
    appBarTheme: const AppBarTheme(
        actionsIconTheme: IconThemeData(color: Colors.grey),
        titleTextStyle: TextStyle(
          color: Colors.grey,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        )),
    textTheme: TextTheme(
      bodyText2: TextStyle(color: Colors.grey.shade400),
      bodyText1: TextStyle(color: Colors.grey.shade400),
    ),
  );
}
