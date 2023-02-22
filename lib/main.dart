import 'dart:async';
// import 'dart:convert';


// import 'package:app_launcher/app_launcher.dart';
import 'package:flutter_background_service/flutter_background_service.dart'
    show
        AndroidConfiguration,
        FlutterBackgroundService,
        IosConfiguration,
        ServiceInstance;
        
import 'package:flutter/material.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; 

// import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'background_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:http/http.dart' as http;



// import 'package:flutter_sms/flutter_sms.dart';

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
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  String text = "Stop Service";



  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    _initSpeech();
    _initLocation();
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

              // FloatingActionButton(
              //   onPressed: _sendEmail,
              //           // _sendSMS,
              //           // _location,
              //           //_speechToText.isNotListening ? _startListening : _stopListening,
              //   tooltip: 'Listen',
              // ),
              

            ],
          ),
        ),
      ),
    );
  }


  // void _sendEmail(){
  //   var
  //     Service_id='service_emp11gu',
  //     Template_id='template_t12oyse',
  //     User_id='Tz-1eK_bjtePLr2Tu';
  //   var s = http.post(Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
  //   headers: {
  //       'origin':'http:localhost',
  //       'Content-Type':'application/json'
  //   },
  //   body: jsonEncode({
  //     'service_id': Service_id,
  //     'user_id': User_id,
  //     'template_id': Template_id,
  //     'template_params':{
  //       'name': 'Juan',
  //       'name_contact': 'Heidy',
  //       'message': 'SOS. Mi ubicacion actual:',
  //       'sender_email': 'holmoscampos@gmail.com'
  //     }
  //   })
  //   );
  // }


  



  /// Esto tiene que suceder solo una vez por aplicación
  void _initSpeech() async {
    await _speechToText.initialize();
  }


  void _initLocation() async {
    LocationPermission permission;
    permission = await _geolocatorPlatform.checkPermission();
    if(permission == LocationPermission.denied) {
    permission = await _geolocatorPlatform.requestPermission();
    }
  }


}















