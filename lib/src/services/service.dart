import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_home_pbl5/src/session/session.dart';

import '../functions/play_audio/audioplay.dart';

//
const url = "http://34.142.199.189/api";

// Login
Future<int> login(String username, String password) async {
  final uri = Uri.parse("$url/login");
  final response = await http.post(
    uri,
    headers: <String, String>{"Content-Type": "application/json"},
    body: jsonEncode(
        <String, String>{'username': username, 'password': password}),
  );

  if (kDebugMode) {
    print("login ${response.statusCode}");
  }
  if (response.statusCode == 200) {
    final body = response.body;
    final data = jsonDecode(body);
    saveAccessToken(data["access_token"]);
  }
  return response.statusCode;
}

// Get all devices
Future<dynamic> getDevice() async {
  final uri = Uri.parse("$url/devices");
  final accessToken = await getAccessToken();
  final response = await http.get(uri, headers: {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json'
  });

  if (response.statusCode == 200) {
    final body = response.body;
    final data = jsonDecode(body);
    return data;
  } else {
    if (kDebugMode) {
      print("get devices ${response.statusCode}");
    }
    return -1;
  }
}

// Get device types
Future<dynamic> getDeviceTypes() async {
  final uri = Uri.parse("$url/devices/type");
  final accessToken = await getAccessToken();
  final response = await http.get(uri, headers: {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json'
  });

  if (response.statusCode == 200) {
    final body = response.body;
    final data = jsonDecode(body);
    return data;
  } else {
    if (kDebugMode) {
      print("get devices ${response.statusCode}");
    }
    return -1;
  }
}

// Update device
Future<int> updateDevice(deviceId, value) async {
  final uri = Uri.parse('$url/devices/$deviceId');
  final accessToken = await getAccessToken();
  final response = await http.put(uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(<String, bool>{'status': value}));

  if (kDebugMode) {
    print("update ${response.statusCode}");
  }

  return response.statusCode;
}

// Add device
Future<int> addDevice(String name, String type) async {
  final uri = Uri.parse("$url/devices");
  final accessToken = await getAccessToken();
  final response = await http.post(
    uri,
    headers: <String, String>{
      'Authorization': 'Bearer $accessToken',
      "Content-Type": "application/json"
    },
    body: jsonEncode(<String, String>{'name': name, 'type': type}),
  );

  if (kDebugMode) {
    print("create ${response.statusCode}");
  }

  return response.statusCode;
}

// Delete device
Future<int> deleteDevice(int idDevice) async {
  final uri = Uri.parse("$url/devices/$idDevice");
  final accessToken = await getAccessToken();
  final response = await http.delete(
    uri,
    headers: <String, String>{
      'Authorization': 'Bearer $accessToken',
      "Content-Type": "application/json"
    },
  );

  if (kDebugMode) {
    print("create ${response.statusCode}");
  }

  return response.statusCode;
}

// Send file audio to server
Future<String> sendAudio(String audioPath) async {
  final uri = Uri.parse("$url/recognize");
  final accessToken = await getAccessToken();
  final request = http.MultipartRequest("POST", uri);

  request.headers['Authorization'] = 'Bearer $accessToken';
  request.files.add(await http.MultipartFile.fromPath('sound', audioPath));

  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseStream =
          await response.stream.transform(utf8.decoder).toList();
      final result = responseStream.join();
      return result;
    } else {
      return 'Request failed with status code: ${response.statusCode}';
    }
  } catch (e) {
    throw Exception('Request failed: $e');
  }
}

Future<String> sendAudioFile(String audioFilePath) async {
  final uri = Uri.parse("$url/recognize");
  final accessToken = await getAccessToken();
  final file = File(audioFilePath);
  final headers = {
    HttpHeaders.authorizationHeader: 'Bearer $accessToken',
    HttpHeaders.contentTypeHeader: 'multipart/form-data',
    // change to your audio type
  };

  // create multipart request
  var request = http.MultipartRequest('POST', uri);
  request.headers.addAll(headers);
  // add file to request
  var audioFile = await http.MultipartFile.fromPath('sound', file.path);
  request.files.add(audioFile);

  print(audioFilePath);

  try {
    // send request and get response
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseJson = await utf8.decodeStream(response.stream);
      return responseJson;
    } else {
      return 'Failed to send audio: ${response.statusCode}';
    }
  } catch (error) {
    return 'Failed to send audio: ${error.toString()}';
  }
}
