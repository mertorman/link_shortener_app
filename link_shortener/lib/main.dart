// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:link_shortener/feature/views/homepage.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      builder: (context, child) => ResponsiveWrapper.builder(
          child,
 
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(480, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          ],),
      theme: ThemeData(useMaterial3: true),
      title: 'MeoLink Shorter',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}


