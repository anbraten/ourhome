import 'package:flutter/material.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  primaryColor: Colors.green[300],
  appBarTheme: AppBarTheme(
    foregroundColor: Colors.white,
    backgroundColor: Colors.green[300],
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.green[300],
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(10),
      minimumSize: const Size(double.infinity, 50),
      backgroundColor: Colors.green[300],
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.green[300],
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Corben',
      fontWeight: FontWeight.w700,
      fontSize: 24,
      color: Colors.black,
    ),
  ),
);
