// ignore_for_file: unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:project/screens/homepage.dart';
import 'package:project/screens/traindata.dart';
import 'package:project/screens/trainroute.dart';
import 'package:project/screens/pnrstatus.dart';
import 'screens/liveStation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 154, 187, 155),
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      initialRoute: "/home",
      routes: {
        "/home": (context) => HomePage(),
        "/trains": (context) => const TrainPage(),
        "/routes": (context) => TrainRoute(trainNumber: ''),
        "/station": (context) => LiveStation(),
        "/pnr": (context) => PnrStatus()
      },
    );
  }
}
