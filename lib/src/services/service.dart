import 'dart:convert';

import 'package:http/http.dart' as http;

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

  print("login ${response.statusCode}");
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

  print("update ${response.statusCode}");
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

  print("create ${response.statusCode}");
  return response.statusCode;
}

