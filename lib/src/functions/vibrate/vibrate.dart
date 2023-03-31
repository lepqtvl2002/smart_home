import 'dart:async';

import 'package:vibration/vibration.dart';

Timer vibrationTimer(Duration duration) {
  var timer = Timer.periodic(duration, (Timer t) {
    // Call your function here
    Vibration.vibrate(duration: 1000);
  });
  return timer;
}