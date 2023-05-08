import 'dart:async';

import 'package:vibration/vibration.dart';

// Vibrate again after while
Timer vibrationTimer(Duration duration) {
  var timer = Timer.periodic(duration, (Timer t) {
    // Call your function here
    Vibration.vibrate(duration: 1000);
  });
  return timer;
}

// Stop vibrate after a while
void vibrateTime(Duration duration) {
  Timer timer = vibrationTimer(const Duration(seconds: 2));
  Future.delayed(duration, () {
    timer.cancel();
  });
}