import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

Future<void> playSound() async {
  AudioPlayer audioPlayer = AudioPlayer();
  late Source audioUrl;
  audioUrl = UrlSource(
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
  await audioPlayer.play(audioUrl);
}
