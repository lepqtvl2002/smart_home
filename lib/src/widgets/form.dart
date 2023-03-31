import 'package:flutter/material.dart';
import 'package:smart_home_pbl5/src/functions/notification/notification.dart';

import '../functions/notification/alert.dart';
import '../functions/notification/toast.dart';
import '../functions/navigate/navigate.dart';
import '../services/service.dart';
import '../session/session.dart';

typedef FormToAdd = _AddDeviceFormState;
typedef FormToLogin = _LoginFormState;

// Add device form
const List<String> _listTypeDevices = ['Light', 'Fan', 'Door'];

class AddDeviceForm extends StatefulWidget {
  final List<String> listDeviceType;

  const AddDeviceForm({super.key, required this.listDeviceType});

  @override
  FormToAdd createState() => _AddDeviceFormState();
}

class _AddDeviceFormState extends State<AddDeviceForm> {
  final _formKey = GlobalKey<FormState>();
  late String? _name;
  String _selectedTypeDevice = _listTypeDevices[0];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButton<String>(
            value: _selectedTypeDevice,
            items: _listTypeDevices.map((deviceType) {
              return DropdownMenuItem<String>(
                value: deviceType,
                child: Text(deviceType),
              );
            }).toList(),
            onChanged: (selectedTypeDevice) {
              setState(() {
                _selectedTypeDevice = selectedTypeDevice!;
              });
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Device's name"),
            validator: (value) {
              if (value!.isEmpty) {
                return "Please type device's name";
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                _name = value!;
              });
            },
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ElevatedButton(
                child: const Text('Cancel'),
                onPressed: () => {closeModal(context)},
              ),
              ElevatedButton(
                child: const Text('Add'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    // Lưu dữ liệu vào cơ sở dữ liệu hoặc xử lý dữ liệu tại đây
                    var selectedTypeId =
                        _listTypeDevices.indexOf(_selectedTypeDevice) + 1;
                    final statusCode =
                        await addDevice(_name!, selectedTypeId.toString());
                    const int success = 200;
                    if (statusCode == success) {
                      if (mounted) {
                        closeModal(context);
                        showSuccess(context, "Successful!!!");
                      }
                    } else {
                      if (mounted) {
                        showError(context, "Add device failed",
                            "Can't add device. Please try again.");
                      }
                    }
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

// Login form
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  FormToLogin createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late String _username = "";
  late String _password = "";

  // Handle login
  void handleLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: Perform login action
      final statusCode = await login(_username.trim(), _password);

      if (statusCode == 200) {
        saveUserLogin(_username);
        if (mounted) {
          navigatePage(context, "/");
        }
      } else {
        if (mounted) {
          showAlert(
              const Text("We couldn't sign you in."),
              const Text(
                  "The username, or password you entered is incorrect. Please try again."),
              [],
              context);
          showWarningNotification(title: "test2", description: "login falied");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
