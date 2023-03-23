import 'package:flutter/material.dart';

class AppTheme {
  static final light = ThemeData.light().copyWith(
    // scaffoldBackgroundColor: Colors.white,
    useMaterial3: true,
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
    bottomAppBarTheme: const BottomAppBarTheme(color: Colors.white),
  );

  static final dark = ThemeData.dark().copyWith(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.grey.shade900,
    appBarTheme: const AppBarTheme(
        actionsIconTheme: IconThemeData(color: Colors.grey),
        titleTextStyle: TextStyle(
          color: Colors.grey,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        )),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.grey.shade400),
      bodyLarge: TextStyle(color: Colors.grey.shade400),
    ),
  );
}
