import 'package:flutter/material.dart';
import 'package:smart_home_pbl5/src/services/service.dart';

// Button micro while recording
class ZoomInOutButton extends StatefulWidget {
  final Widget child;

  const ZoomInOutButton({required this.child});

  @override
  _ZoomInOutButtonState createState() => _ZoomInOutButtonState();
}

class _ZoomInOutButtonState extends State<ZoomInOutButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _animation =
        Tween<double>(begin: 50.0, end: 80.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          width: _animation.value,
          height: _animation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// Button show information (temperature, humidity, number of active devices)
class MyButton extends StatelessWidget {
  final Text text;
  final Icon icon;
  final VoidCallback onPressed;

  const MyButton(
      {super.key,
      required this.text,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon,
              text,
            ],
          ),
        ));
  }
}

// Wrapper title and switch
class SwitchWrapper extends StatelessWidget {
  final String text;
  final void Function(bool) onChanged;
  final bool value;

  const SwitchWrapper(
      {super.key,
      required this.text,
      required this.onChanged,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// Form add device
class FormAddDevice extends StatefulWidget {
  const FormAddDevice({super.key});

  @override
  _FormAddDeviceState createState() => _FormAddDeviceState();
}

class _FormAddDeviceState extends State<FormAddDevice> {
  final _formKey = GlobalKey<FormState>();
  late String? _name;
  static const List<String> _listTypeDevices = ['Light', 'Fan', 'Door'];
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
                onPressed: () {},
              ),
              ElevatedButton(
                child: const Text('Add'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    // Lưu dữ liệu vào cơ sở dữ liệu hoặc xử lý dữ liệu tại đây
                    print(_name);
                    print(_selectedTypeDevice);
                    var _selectedTypeId =
                        _listTypeDevices.indexOf(_selectedTypeDevice) + 1;
                    print(_selectedTypeId);
                    final msg =
                        await addDevice(_name!, _selectedTypeId.toString());
                    print(msg);
                    if (msg == "OK") {
                      print("Success");
                    } else {
                      print("Failed!");
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

// Card custom
class CustomCard extends Card {
  @override
  final Widget child;

  const CustomCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}
