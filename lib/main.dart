import 'package:flutter/material.dart';
// import 'package:tutoapp/pages/home/home.dart';
import 'package:tutoapp/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'T80',
      debugShowCheckedModeBanner: false,
      // home: HomePage(),
      home: const SplashScreen(),
    );
  }
}