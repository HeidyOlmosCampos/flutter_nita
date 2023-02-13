import 'package:flutter/material.dart';
import 'package:flutter_nita/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: WelcomePage(),

    );
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     primaryColor: Colors.white,
    //     // primarySwatch: Colors.blue,
    //   ),
    //   home: const WelcomePage(),
    // );
  }
}



