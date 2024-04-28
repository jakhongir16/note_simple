import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
 brightness: Brightness.dark,
 colorScheme: ColorScheme.dark(
  background: Colors.grey.shade900,
  primary: const Color.fromARGB(255, 52, 52, 52),
  secondary: Colors.grey.shade700,
  inversePrimary: Colors.grey.shade300,
 ),
   textTheme: ThemeData.dark().textTheme.apply(
     bodyColor: Colors.grey[300],
     displayColor: Colors.white,
   ),
);