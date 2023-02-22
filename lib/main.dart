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
import 'package:speech_to_text/speech_recognition_result.dart';
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
  bool _speechEnabled = false;

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
        backgroundColor: Color.fromARGB(255, 168, 146, 228),
        body: Center(
          // child: Chat(),
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
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              //   color: Colors.deepPurple,
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: TextField(
              //           controller: _controller,
              //           style: TextStyle(color: Colors.white),
              //         )
              //       ),
              //       IconButton(
              //           onPressed: () {
              //           _initSpeech();
              //              sendMessage(_controller.text);
              //              _controller.clear();
              //           },
              //           icon: Icon(Icons.send)
              //       )
              //     ],
              //   ),
              // ),
              FloatingActionButton(
                onPressed: _startListening,
                        //_speechToText.isNotListening ? _startListening : _stopListening,
                tooltip: 'Listen',
                child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
              ),

              
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
          queryInput: QueryInput(text: TextInput(text: text, languageCode: 'es'))
      );//aqui devuelve la respuesta de dialogflow hacia flutter

      if (response.message == null) return;

      String? action = response.queryResult!.action; //el nombre de la accion
      String ? msg = response.text; //response.message!.text!.text![0];

      _accionDialog(action!, msg!); //llama a la accion a realizar
    }
  }

  _accionDialog(String action, String msg) async {
    switch (action) {
      case 'ubicacion': _speak(msg.replaceAll('[x]', 'Los Negros Santa Cruz'));
        
        break;
      default: _speak('Podrias repetirlo por favor');
    }
  }

  void _speak(String text) { //de texto a voz
    flutterTts.speak(text);
  }

  /// Esto tiene que suceder solo una vez por aplicación
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    // setState(() {});
  }

  /// Cada vez que inicie una sesión de reconocimiento de voz
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    // setState(() {});
  }

  /// Detener manualmente la sesión de reconocimiento de voz activa
  /// Tenga en cuenta que también hay tiempos de espera que impone cada plataforma
  /// y el complemento SpeechToText admite la configuración de tiempos de espera en el
  /// método de escucha.
  void _stopListening() async {
    await _speechToText.stop();
    // setState(() {});
  }

  /// Esta es la devolución de llamada que llama el complemento SpeechToText cuando
  /// la plataforma devuelve palabras reconocidas.
  void _onSpeechResult(SpeechRecognitionResult result) {
    if(result.finalResult){
      sendMessage(result.recognizedWords);
      // print(result.recognizedWords);
    }
  }
}