import 'package:flutter/material.dart';

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

// List devices dropdown
class ListDevices extends StatelessWidget {
  final List<dynamic> devices;
  final Future<Set<void>> Function(bool) Function(dynamic, dynamic) onChange;

  const ListDevices({Key? key, required this.devices, required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(36, 0, 8, 10),
      child: Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        children: devices.map((device) {
          return SwitchWrapper(
              text: device["name"],
              onChanged: onChange(device["id"], device["status"]),
              value: device["status"]);
        }).toList(),
      ),
    );
  }
}
