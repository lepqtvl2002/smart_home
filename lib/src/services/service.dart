import 'dart:convert';

import 'package:http/http.dart' as http;

const apiKey = 'd976fd59f8abe562280067f4e0b064ea';
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
Future<String> login(String username, String password) async {
  final uri = Uri.parse("$url/login");
  final response = await http.post(
    uri,
    headers: <String, String>{"Content-Type": "application/json"},
    body: jsonEncode(
        <String, String>{'username': username, 'password': password}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final msg = data["msg"].toString();
    if (msg == "Successfully authenticated")
      accessToken = data["access_token"].toString();
    return msg;
  } else {
    final msg = 'Failed to post data. Error code: ${response.statusCode}';
    return msg;
  }
}

// Get all devices
Future<dynamic> getDevice() async {
  final uri = Uri.parse("$url/devices");
  final response = await http.get(uri, headers: {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json'
  });
  final body = response.body;
  final data = jsonDecode(body);
  return data;
}

// Update device
Future<void> updateDevice(deviceId, value) async {
  final uri = Uri.parse('$url/devices/$deviceId');
  final response = await http.put(uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(<String, bool>{'status': value}));

  print(jsonDecode(response.body));
  if (response.statusCode == 200) {
    print('Resource updated successfully');
  } else {
    print('Failed to update resource: ${response.statusCode}');
  }
}

// Add device
Future<String> addDevice(String name, String type) async {
  final uri = Uri.parse("$url/devices");
  final response = await http.post(
    uri,
    headers: <String, String>{
      'Authorization': 'Bearer $accessToken',
      "Content-Type": "application/json"
    },
    body: jsonEncode(<String, String>{'name': name, 'type': type}),
  );

  print(jsonDecode(response.body));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final msg = data["message"].toString();
    return msg;
  } else {
    final msg = 'Failed to post data. Error code: ${response.statusCode}';
    return msg;
  }
}

