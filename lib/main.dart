import 'package:flutter/material.dart';
import 'package:zeroth/screens/clock_five.dart';
import 'package:zeroth/screens/clock_four.dart';
import 'package:zeroth/screens/clock_seven.dart';
import 'package:zeroth/screens/clock_three.dart';
import 'package:zeroth/screens/clock_two.dart';
import 'package:zeroth/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(
        screens: [
          // ClockOne(),
          ClockTwoScreen(),
          ClockFour(textList: ["Heroes are born", "Wake up to reality"]),
          ClockThree(),
          ClockFive(),
          // ClockSix(),
          ClockSeven(),
        ],
      ),
    );
  }
}
