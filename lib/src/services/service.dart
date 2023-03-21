import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../functions/alert/alert.dart';

const apiKey = '51112130206065637c98f0e2371626fb';
const lat = '16.0678';
const lon = '108.2208';
const weatherUrl =
    'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey';

// Get temperature and humidity (blocked, can not use)
Future<dynamic> getTemperatureAndHumidity() async {
  final response = await http.get(Uri.parse(weatherUrl));
  final data = jsonDecode(response.body);
  return data['main'];
}

//
const url = "http://34.142.199.189/api";
String accessToken = "";

// Clear access token
void clearToken() {
  accessToken = "";
}

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
    accessToken = data["access_token"];
  }
  return response.statusCode;
}

// Get all devices
Future<dynamic> getDevice() async {
  final uri = Uri.parse("$url/devices");
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

// Send file audio to server
Future<String> sendAudio(String audioPath) async {
  final uri = Uri.parse("$url/recognize");
  final request = http.MultipartRequest("POST", uri);

  final multipartFile = await http.MultipartFile.fromPath("audio", audioPath);
  request.files.add(multipartFile);
  String result = "";
  http.StreamedResponse response = await request.send();
  final e = await response.stream.transform(utf8.decoder).toList();
  result = e[0];
  return result;
}
