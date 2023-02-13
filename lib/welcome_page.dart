import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        child: Container( 
          child: new Text("NITA"),
          color: Colors.amber,
          width: double.infinity,
          height: 100,
          alignment: Alignment.center,
        ),
      ),
    );
    
  }
}