library Accelerometer;

import 'dart:async';
import 'dart:math';

import 'package:app_launcher/app_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_nita/main.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Callback for phone Accelerometers
typedef void PhoneAccelerometerCallback();

/// AccelerometerDetector class for phone Accelerometer functionality
class AccelerometerDetector {
  /// User callback for phone Accelerometer
  final PhoneAccelerometerCallback onPhoneAccelerometer;

  /// Accelerometer detection threshold
  final double AccelerometerThresholdGravity;

  /// Minimum time between Accelerometer
  final int AccelerometerSlopTimeMS;

  /// Time before Accelerometer count resets
  final int AccelerometerCountResetTime;

  /// Number of Accelerometers required before Accelerometer is triggered
  final int minimumAccelerometerCount;

  int mAccelerometerTimestamp = DateTime.now().millisecondsSinceEpoch;
  int mAccelerometerCount = 0;
  bool bandera = true;

  /// StreamSubscription for Accelerometer events
  StreamSubscription? streamSubscription;

  /// This constructor waits until [startListening] is called
  AccelerometerDetector.waitForStart({
    required this.onPhoneAccelerometer,
    this.AccelerometerThresholdGravity = 1.5,
    this.AccelerometerSlopTimeMS = 300,
    this.AccelerometerCountResetTime = 2000,
    this.minimumAccelerometerCount = 3,
  });

  /// This constructor automatically calls [startListening] and starts detection and callbacks.
  AccelerometerDetector.autoStart({
    required this.onPhoneAccelerometer,
    this.AccelerometerThresholdGravity = 1.5,
    this.AccelerometerSlopTimeMS = 300,
    this.AccelerometerCountResetTime = 2000,
    this.minimumAccelerometerCount = 3,
  }) {
    startListening();
  }

  /// Starts listening to accelerometer events
  void startListening() {
    streamSubscription = accelerometerEvents.listen(
      (AccelerometerEvent event) async {
        double x = event.x;
        double y = event.y;
        double z = event.z;

        double gX = x / 9.80665;
        double gY = y / 9.80665;
        double gZ = z / 9.80665;

        // gForce will be close to 1 when there is no movement.
        double gForce = sqrt(gX * gX + gY * gY + gZ * gZ);

        if (gForce > AccelerometerThresholdGravity) {
          var now = DateTime.now().millisecondsSinceEpoch;
          // ignore Accelerometer events too close to each other (500ms)
          if (mAccelerometerTimestamp + AccelerometerSlopTimeMS > now) {
            return;
          }

          // reset the Accelerometer count after 3 seconds of no Accelerometers
          if ((mAccelerometerTimestamp + AccelerometerCountResetTime)  < now ) {
            bandera = true;
            mAccelerometerCount = 0;
          }

          mAccelerometerTimestamp = now;
          if (bandera){
            mAccelerometerCount++;
          }
          

          if (mAccelerometerCount >= minimumAccelerometerCount) {
            bandera = false;
            mAccelerometerCount = 0;
            onPhoneAccelerometer();

          }
            
        }
      },
    );
  }

  /// Stops listening to accelerometer events
  void stopListening() {
    streamSubscription?.cancel();
  }
}