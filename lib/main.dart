import 'package:flutter/material.dart';
import 'package:up_todo/Screen/splashscreen.dart';
import 'Screen/splashscreen.dart';
import 'Screen/contactscreen.dart';
import 'Screen/homescreen.dart';
import 'Screen/loginscreen.dart';
import 'Screen/CreateAcc.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/Splash': (context) => SplashScreen(),
        '/login': (context) => login_screen(),
        '/contact': (context) => ContactScreen(),
        '/createacc': (context) => CreateAccScreen(),
        '/home': (context) => HomeScreen(),
      },
    ),
  );
}
