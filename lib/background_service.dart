import 'dart:ui';
import 'dart:async';
import 'package:app_launcher/app_launcher.dart';
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
import 'package:shake/shake.dart';

final service = FlutterBackgroundService();
final flutterTts = FlutterTts();

// ShakeDetector? detector;
AccelerometerDetector? acDetector;

int _counter = 0;

Future initializeService() async {

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

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  // print('FLUTTER BACKGROUND FETCH');
  return true;
}

void onStart(ServiceInstance service) async {

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


// void _initShakeListen() async {
//   detector = ShakeDetector.waitForStart(onPhoneShake: speak);
// }

// void _startListening() async {
//   detector?.startListening();
// }

// void _stopListening() async {
//   detector?.stopListening();
// }

// void speak() {
//   flutterTts.speak("detectado");
//   _counter++;
// }


void _initShakeListen() async {
  acDetector = AccelerometerDetector.waitForStart(onPhoneAccelerometer: speak);
}

void _startListening() async {
  acDetector?.startListening();
  _counter++;
}

void _stopListening() async {
  acDetector?.stopListening();
}

void speak() {
  flutterTts.speak("movimiento detectado");
   _counter++;
}


void launch() {
  //  AppLauncher.openApp(androidApplicationId: "com.whatsapp");
   AppLauncher.openApp(androidApplicationId: "com.example.flutter_nita");
}

