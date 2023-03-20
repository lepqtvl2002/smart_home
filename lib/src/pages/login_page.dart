import 'package:flutter/material.dart';
import 'package:smart_home_pbl5/src/services/service.dart';
import 'package:smart_home_pbl5/src/session/session.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late String _username;
  late String _password;

  // Handle login
  void handleLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: Perform login action
      final statusCode = await login(_username.trim(), _password);

      if (statusCode == 200) {
        saveUserLogin(_username);
        navigatePage(context);
      } else {
        print("Login Failed!");
      }
    }
  }

  // Navigate page function
  void navigatePage(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // Form login
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onSaved: (value) {
                  _username = value!;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: handleLogin,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


