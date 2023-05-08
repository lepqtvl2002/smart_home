import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:smart_home_pbl5/src/functions/notification/alert.dart';
import 'package:smart_home_pbl5/src/functions/play_audio/audioplay.dart';
import 'package:smart_home_pbl5/src/services/service.dart';
import 'package:smart_home_pbl5/src/widgets/widget_custom.dart';

// Request storage permission
Future<bool> requestStoragePermission() async {
  var status = await Permission.storage.request();
  return status.isGranted;
}

// Request micro permission
Future<void> requestMicPermission() async {
  final status = await Permission.microphone.request();
  if (status == PermissionStatus.granted) {
// Quyền truy cập vào microphone được cấp.
  } else if (status == PermissionStatus.denied) {
// Quyền truy cập vào microphone bị từ chối.
  } else if (status == PermissionStatus.permanentlyDenied) {
// Quyền truy cập vào microphone bị từ chối vĩnh viễn, cần yêu cầu lại từ người dùng trong cài đặt hệ thống.
  }
}

// Record audio
typedef RecordAudioState = _RecordAudioState;

class RecordAudio extends StatefulWidget {
  const RecordAudio({super.key});

  @override
  RecordAudioState createState() => _RecordAudioState();
}

class _RecordAudioState extends State<RecordAudio> {
  final Record _record = Record();
  bool _isRecording = false;
  String _audioPath = "";

  @override
  void initState() {
    super.initState();
  }

// Start recording
  Future<void> _startRecording() async {
    try {
      if (await _record.hasPermission()) {
        Directory appDirectory = await getApplicationDocumentsDirectory();
        String audioPath =
            '${appDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _record.start(
          path: audioPath,
          // encoder: AudioEncoder.AAC,
          // bitRate: 192000,
          // samplingRate: 44100,
        );

        setState(() {
          _isRecording = true;
          _audioPath = audioPath;
        });
      } else {
        await requestMicPermission();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      await requestMicPermission();
    }
  }

// Stop recording
  Future<void> _stopRecording() async {
    try {
      if (_isRecording) {
        await _record.stop();
        setState(() {
          _isRecording = false;
        });

        final result = await sendAudio(_audioPath);
        if (result.isNotEmpty) {
          if (mounted) {
            showAlert(const Text("Result"), Text(result), [], context);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isRecording
        ? ZoomInOutButton(
            child: FloatingActionButton(
            onPressed: _stopRecording,
            child: const Icon(Icons.stop_circle_outlined),
          ))
        : FloatingActionButton(
            onPressed: _startRecording,
            child: const Icon(Icons.mic),
          );
  }
}
