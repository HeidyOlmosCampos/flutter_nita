import 'dart:async';

import 'package:app_launcher/app_launcher.dart';
import 'package:flutter_background_service/flutter_background_service.dart'
    show
        AndroidConfiguration,
        FlutterBackgroundService,
        IosConfiguration,
        ServiceInstance;
        
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'background_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';

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

  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
  final flutterTts = FlutterTts();

  String text = "Stop Service";


  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 168, 146, 228),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //for listen Continuous change in foreground we will be using Stream builder
              // StreamBuilder<Map<String, dynamic>?>(
              //   stream: FlutterBackgroundService().on('update'),
              //   builder: (context, snapshot) {
              //     if (!snapshot.hasData) {
              //       return const Center(
              //         child: CircularProgressIndicator(),
              //       );
              //     }
              //     final data = snapshot.data!;
              //     int? counter = data["counter"];
              //     DateTime? date = DateTime.tryParse(data["current_date"]);
              //     return Expanded(
              //       child: Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Text('Counter => $counter'),
              //           Text(date.toString()),
              //         ],
              //       ),
              //     );
              //   }
              // ),
              Expanded(
                child: Container( 
                  width: double.infinity,
                  height: 100,
                  alignment: Alignment.center, 
                  child: Text(
                    "NITA",
                    style: TextStyle(
                      fontSize: 100,
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


              Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                color: Colors.deepPurple,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(color: Colors.white),
                      )
                    ),
                    IconButton(
                        onPressed: () {
                          sendMessage(_controller.text);
                          _controller.clear();
                        },
                        icon: Icon(Icons.send)
                    )
                  ],
                ),
              )

              
            ],
          ),
        ),
      ),
    );
  }



  sendMessage(String text) async { //toma el "text" y lo envia a dialogflow
    if (text.isEmpty) {
      print('Message esta vacio');
    } else {

      DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text))
      );//aqui devuelve la respuesta de dialogflow hacia flutter

      String? action = response.queryResult!.action; //el nombre de la accion

      if (response.message == null) return;

      String msg = response.message!.text!.text![0];
      speak(msg); 
    }
  }

  void speak(String text) {
    flutterTts.speak(text);
  }
}