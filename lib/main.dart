import 'package:flutter/material.dart';
import 'package:sipaling_upi/screens/homePage.dart';
import 'package:sipaling_upi/screens/splashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIPALING UPI',
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
        primarySwatch: Colors.red,
      ),
      home: const HomePage(),
    );
  }
}
