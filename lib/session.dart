import 'package:shared_preferences/shared_preferences.dart';

// Store session
Future<void> saveUserLogin(String userLogin) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userLogin', userLogin);
}

// Get session
Future<String> getUserLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userLogin') ?? '';
}

// Check session
Future<bool> checkSession() async {
  String user = await getUserLogin();
  if (user.isEmpty) {
    return false;
  } else {
    return true;
  }
}

// Clear session
void clearSession() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}
