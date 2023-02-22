import 'dart:ui';
import 'dart:async';
import 'package:app_launcher/app_launcher.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_sensors/flutter_sensors.dart';

import 'package:flutter_background_service_android/flutter_background_service_android.dart';

import 'package:flutter_background_service/flutter_background_service.dart'
    show
        AndroidConfiguration,
        FlutterBackgroundService,
        IosConfiguration,
        ServiceInstance;

import 'package:flutter_nita/acelerometer.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

final service = FlutterBackgroundService();
final flutterTts = FlutterTts();
SpeechToText _speechToText = SpeechToText();
AccelerometerDetector? acDetector;


// DialogFlowtter ? dialogFlowtter;


DialogAuthCredentials credentials = DialogAuthCredentials.fromJson({
  "type": "service_account",
  "project_id": "bot-nita-yyhg",
  "private_key_id": "fe0c6e3ca7df0c46a6a4454f3f08d70ab8605453",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC/DFLX+D7/KgpZ\nfsbGetIppCGAsqTr95hsDF2Cx7NXDvlZcxcYh6pneUiiN6iXqvyidGjqgknz5NBw\nbQz0ihiPn+/IET46HyZd/mlrxLsgXGmJ7+vQ2Gkrtul6S+IlrVSfFKm4Ll+aDxy1\nkXOv/aOLyGWLscZEgEEhByemAquVeNWnIKyW1YT3Ql1Uqrekx4DvNlxe9JiT2ner\nKKgXZghAIqvIx/vNhEELH3997PjWyvTlSiQlKFPaTfrxCBQy1Sdv1xi35e+AO+UY\nu/w7Bfb1wuTfrkibnQsr1SzFtpJventq2cm17cn3OjK4mPs/qiwXz/mI711++C1a\nzCkaO2HZAgMBAAECggEAAccW2eOcXhcYmY7EzOqLSs/mtblQ6nQXWBWspLbjWzo1\nK2eLer6W+Gvg2ju/cSEeit0rKdfTEFakuGzob2hDu7JlSeEcSU1wLCNd5ZMusdg1\n7WAbmInlJ+e0LHbJBndFVZQoXq1HD+kDXHdVpspNxF7YoZdoblcb5vGu06xDakj9\nb4XfnOsdeWXx2U3oZFOl4rE23Po0xKv4eXvVACBczivEp6tfcTx7HODFX8+d570l\nFYjDD0Wbm+x/2Xt7f0HgjkHDvkJw5IUD33X83bV6gqT0pAtGBXuIF72MRJFRgXdk\ndSA30kdBaKIulnd3PuB6dwGHOPaxUESKyuo1dn2A8QKBgQDm/FJFp6d5+BaSgFZJ\nfXQbxHLJKM80bBuLgdxgLWISZ+rMW/5RjFzRV7bFJ3kJ/0KIKCcRDd9KUeK4QE6K\nH41n/pyvWDxVEjFuZ/UdSu7755yQNn5OLDLHq6XH9bltttPce+id0Z8Swqu6gqso\ngB4MK3biE+5r4CY0Ga9aoIkGUwKBgQDTvM3ZUiziyTkVfKf7pC37dtum5lE7txUm\nBGE4XGQy6ToyjUqSfXwDNEwm73Qg4KIHx1pkIsJomooJ/Lirk9knCavBv/xkXm6+\nsiIFOoQwR552va3QSm58vwARVroFesEjXyoE1Uboti21dS5wrVhFFPTuam4NE5Wc\nqz6JfODZowKBgAGZoeBFpw1bQJzHMtHTgqhmlfz6wWS1kwNGZQZtig5ilefQg1SB\nSmtQ1j1LZrVBBW74CD1AAVn8czufhmvCiDI+O0ujqtdUBu+i3LnVOQ6ZriX5mqpj\n9/4WHFHkS+KMr68JVLUzLIzuuE3UdecT7CFdc7dhN/ebV+hofSR9lDVtAoGBAIzt\niYUv8LgxflES2yveJszMW35GpaK9RNI88Ah3VimcmiOzbwL5imUHlfgEQKLxYGcV\nBNDJYeQFmAL1tmRcz5fwE+WtRuv2/nbmUUZxoDISOSKHNP0BzXAyIHVp5/5lqc9F\nM85rtfqF5v5ztClC9xFj1XIqXH1Pn7DbOZCBEZdJAoGBAM+QHQ3zDdV26nPnQ62N\nSuvd9OwvOitSsZPbQRCwJqYKXstW8fzQzF25aJ9sOG50lvqfPt6wXiB1koWHcQls\nfXXTF3ZGOt+su9K/RJ5OXMKa0HiCHqTReMHWhxVR0rCCmZtBCazv6L7fJlpDz1l8\niwnuCQmDmOouJsEAAhmCHsiw\n-----END PRIVATE KEY-----\n",
  "client_email": "nita-bot@bot-nita-yyhg.iam.gserviceaccount.com",
  "client_id": "111794036434354193808",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/nita-bot%40bot-nita-yyhg.iam.gserviceaccount.com"
});
DialogFlowtter dialogFlowtter = DialogFlowtter(
  credentials: credentials,
);

  


int _counter = 0;

Future initializeService() async {
  // _initSpeech;
if( await _speechToText.initialize()){
  _initShakeListen();
  

  await service.configure(
    androidConfiguration: AndroidConfiguration(// this will executed when app is in foreground or background in separated isolate
      onStart: onStart,
      autoStart: true,// auto start service
      isForegroundMode: true,      
    ),

    iosConfiguration: IosConfiguration(
      autoStart: true, // auto start service
      onForeground: onStart,// this will executed when app is in foreground in separated isolate
      onBackground: onIosBackground,// you have to enable background fetch capability on xcode project
    ),
  );
  await service.startService();
}
}

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  // print('FLUTTER BACKGROUND FETCH');
  return true;
}

void onStart(ServiceInstance service) async {
  
if(await _speechToText.initialize()){ 
  
  DartPluginRegistrant.ensureInitialized();
  _initShakeListen();
  

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();//set as foreground
    });

    service.on('setAsBackground').listen((event) async {
      service.setAsBackgroundService(); //set as background
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground NOTIFICACIONES
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Nita app",
        content: "Actualizado en ${DateTime.now()}",
      );
    }

    _startListening();

    /// you can see this log in logcat
   // print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

    // test using external plugin
    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "counter": _counter,
      },
    );
  });
}
}


void _initShakeListen() async {
  acDetector = AccelerometerDetector.waitForStart(onPhoneAccelerometer: _hacer);
}

void _startListening() async {
  acDetector?.startListening();
  _counter++;
}

void _stopListening() async {
  acDetector?.stopListening();
}

void _speak(String text) {
  flutterTts.speak(text);
   _counter++;
}


/// Esto tiene que suceder solo una vez por aplicación
void _initSpeech() async {
  await _speechToText.initialize();
}

/// Cada vez que inicie una sesión de reconocimiento de voz
void _startListeningSpeech() async {
  await _speechToText.listen(
    onResult: _onSpeechResult,
    listenFor: Duration(seconds: 15),
    pauseFor: Duration(seconds: 5),
  );
}

/// Detener manualmente la sesión de reconocimiento de voz activa
void _stopListeningSPeech() async {
  await _speechToText.stop();
}

/// Esta es la devolución de palabras reconocidas.
void _onSpeechResult(SpeechRecognitionResult result) {
  if(result.finalResult){
    sendMessage(result.recognizedWords);
  }
}

void _hacer() async {
  //  print('antes de tts --------------------------------------------------------------------------');
  //  _speak('detectado');
  //  print('despues de tts --------------------------------------------------------------------------');
  //  print('antes de speech **************************************************************************');

  // _speechToText.initialize(); 
  //  await _speechToText.listen(onResult: _onSpeechResult); 
   _startListeningSpeech();
  //  print('despues de speech ***************************************************************************');
}






sendMessage(String text) async { //toma el "text" y lo envia a dialogflow
  if (text.isEmpty) {
    print('Message esta vacio');
  } else {
    DetectIntentResponse response = await dialogFlowtter!.detectIntent(
        queryInput: QueryInput(text: TextInput(text: text, languageCode: 'es'))
    );//aqui devuelve la respuesta de dialogflow hacia flutter

    if (response.message == null) return;

    String? action = response.queryResult!.action; //el nombre de la accion
    String ? msg = response.text; //response.message!.text!.text![0];

    _accionDialog(action!, msg!); //llama a la accion a realizar
  }
}

_accionDialog(String action, String msg) { //async {
  switch (action) {
    case 'ubicacion': _speak(msg.replaceAll('[x]', 'Los Negros Santa Cruz'));
      break;

    case 'input.welcome': _speak(msg);
      break;

    case 'input.unknown': _speak(msg);
          //_startListeningSpeech();
      break;
      
    default: null;
  }
}


void launch() {
  //  AppLauncher.openApp(androidApplicationId: "com.whatsapp");
   AppLauncher.openApp(androidApplicationId: "com.example.flutter_nita");
}


