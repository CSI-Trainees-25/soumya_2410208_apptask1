import 'package:flutter/material.dart';
import 'package:up_todo/Screen/splashscreen.dart';
import 'Screen/splashscreen.dart';
import 'Screen/contactscreen.dart';
import 'Screen/homescreen.dart';
import 'Screen/loginscreen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'Splash',
      routes: {'Splash': (context) => SplashScreen()},
    ),
  );
}
