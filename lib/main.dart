import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart'
    show
        AndroidConfiguration,
        FlutterBackgroundService,
        IosConfiguration,
        ServiceInstance;
        
import 'package:flutter/material.dart';
import 'background_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeService();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String text = "Stop Service";

  @override
  Widget build(BuildContext context) {
   // Size size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 168, 146, 228),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //for listen Continuous change in foreground we will be using Stream builder
              StreamBuilder<Map<String, dynamic>?>(
                  stream: FlutterBackgroundService().on('update'),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final data = snapshot.data!;
                    int? counter = data["counter"];
                    DateTime? date = DateTime.tryParse(data["current_date"]);
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Counter => $counter'),
                          Text(date.toString()),
                        ],
                      ),
                    );
                  }),
              Expanded(
                child: Container( 
                  width: double.infinity,
                  height: 100,
                  alignment: Alignment.center, 
                  child: Text(
                    "NITA",
                    style: TextStyle(
                      fontSize: 100,
                      //color: Colors.amber,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 11
                        ..color = const Color.fromARGB(255, 16, 26, 36),
                    )
                  ),
                ),
              ),

              const Expanded(
                child: Image(
                  image: AssetImage('assets/bruce.png')
                ),
              ),

              Expanded(
                child: SvgPicture.asset(
                  "assets/microphone-solid.svg",
                  height: 100,
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: GestureDetector(
              //     child: Container(
              //         padding: const EdgeInsets.symmetric(
              //             vertical: 10, horizontal: 20),
              //         decoration: BoxDecoration(
              //             color: Colors.blueAccent,
              //             borderRadius: BorderRadius.circular(16)),
              //         child: const Text(
              //           "Foreground Mode",
              //           style: TextStyle(color: Colors.white),
              //         )),
              //     onTap: () {
              //       FlutterBackgroundService().invoke("setAsForeground");
              //     },
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: GestureDetector(
              //     child: Container(
              //         padding: const EdgeInsets.symmetric(
              //             vertical: 10, horizontal: 20),
              //         decoration: BoxDecoration(
              //             color: Colors.blueAccent,
              //             borderRadius: BorderRadius.circular(16)),
              //         child: const Text(
              //           "Background Mode",
              //           style: TextStyle(color: Colors.white),
              //         )),
              //     onTap: () {
              //       print('start');
              //       FlutterBackgroundService().invoke("setAsBackground");
              //     },
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: GestureDetector(
              //     child: Container(
              //       padding: const EdgeInsets.symmetric(
              //           vertical: 10, horizontal: 20),
              //       decoration: BoxDecoration(
              //           color: Colors.blueAccent,
              //           borderRadius: BorderRadius.circular(16)),
              //       child: Text(
              //         text,
              //         style: const TextStyle(color: Colors.white),
              //       ),
              //     ),
              //     onTap: () async {
              //       final service = FlutterBackgroundService();
              //       // final service = widget.appStateService.service;
              //       var isRunning = await service.isRunning();
              //       if (isRunning) {
              //         service.invoke("stopService");
              //       } else {
              //         service.startService();
              //       }

              //       if (!isRunning) {
              //         text = 'Stop Service';
              //       } else {
              //         text = 'Start Service';
              //       }
              //       setState(() {});
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}




/*
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
*/


