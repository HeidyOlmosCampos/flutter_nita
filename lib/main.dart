import 'dart:async';


// import 'package:app_launcher/app_launcher.dart';
import 'package:flutter_background_service/flutter_background_service.dart'
    show
        AndroidConfiguration,
        FlutterBackgroundService,
        IosConfiguration,
        ServiceInstance;
        
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
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

  final flutterTts = FlutterTts();
  late DialogFlowtter dialogFlowtter;
  SpeechToText _speechToText = SpeechToText();

  final TextEditingController _controller = TextEditingController();

  String text = "Stop Service";


  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
   _initSpeech();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 171, 157, 209),
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
              

            ],
          ),
        ),
      ),
    );
  }



  /// Esto tiene que suceder solo una vez por aplicación
  void _initSpeech() async {
    await _speechToText.initialize();
    // _speechEnabled = await _speechToText.initialize();
    // setState(() {});
  }


}















