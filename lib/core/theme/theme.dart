import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    cupertinoOverrideTheme: CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black, fontFamily: "SF Pro Display"),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    cupertinoOverrideTheme: CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white, fontFamily: "SF Pro Display"),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
