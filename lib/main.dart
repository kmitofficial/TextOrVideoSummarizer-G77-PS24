import 'package:flutter/material.dart';
import 'package:summarizeai/color_schemes.g.dart';
import 'package:summarizeai/screens/Home.dart';
import 'package:summarizeai/utils/Hexcolor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme, scaffoldBackgroundColor: HexColor('#ffe4c4')),
      // darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: Home()
    );
  }
}
