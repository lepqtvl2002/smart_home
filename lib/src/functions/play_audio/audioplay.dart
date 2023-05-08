import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

Future<void> playSound(String url) async {
  AudioPlayer audioPlayer = AudioPlayer();
  late Source audioUrl;
  audioUrl = UrlSource(url);
  await audioPlayer.play(audioUrl);
}
