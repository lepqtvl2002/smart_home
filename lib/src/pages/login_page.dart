import 'package:flutter/material.dart';
import 'package:smart_home_pbl5/src/widgets/form.dart';

// Login page
typedef LoginPageState = _LoginPageState;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: const Center(
        child: LoginForm(),
      ),
    );
  }
}
