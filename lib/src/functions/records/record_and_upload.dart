// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
//
// class RecordAndUpload extends StatefulWidget {
//   @override
//   _RecordAndUploadState createState() => _RecordAndUploadState();
// }
//
// class _RecordAndUploadState extends State<RecordAndUpload> {
//   final FlutterSoundRecorder _soundRecorder = FlutterSoundRecorder();
//   final FlutterSoundPlayer _soundPlayer = FlutterSoundPlayer();
//   bool _isRecording = false;
//   String _filePath = "";
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   Future<void> _startRecording() async {
//     try {
//       Directory appDirectory = await getApplicationDocumentsDirectory();
//       String filePath =
//           '${appDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.wav';
//       await _soundRecorder.openRecorder();
//       // await _soundRecorder._openAudioSession();
//       await _soundRecorder.startRecorder(
//         codec: Codec.pcm16WAV,
//         toFile: filePath,
//       );
//       setState(() {
//         _filePath = filePath;
//         _isRecording = true;
//       });
//     } catch (e) {
//       print(e.toString());
//     }
//   }
//
//   Future<void> _stopRecording() async {
//     try {
//       await _soundRecorder.stopRecorder();
//       await _soundRecorder.closeRecorder();
//       setState(() {
//         _isRecording = false;
//       });
//       _uploadFile(_filePath);
//     } catch (e) {
//       print(e.toString());
//     }
//   }
//
//   Future<void> _uploadFile(String filePath) async {
//     try {
//       var request = http.MultipartRequest(
//           'POST', Uri.parse('http://34.142.199.189/api/recognize'));
//       request.files.add(await http.MultipartFile.fromPath('sound', filePath));
//       var response = await request.send();
//       print(response.statusCode);
//       if (response.statusCode == 200) {
//         print('Upload success!');
//       } else {
//         print('Upload failed!');
//       }
//     } catch (e) {
//       print(e.toString());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       iconSize: 72.0,
//       icon: Icon(
//         _isRecording ? Icons.stop : Icons.mic,
//         color: _isRecording ? Colors.red : Colors.green,
//       ),
//       onPressed: _isRecording ? _stopRecording : _startRecording,
//     );
//   }
// }
