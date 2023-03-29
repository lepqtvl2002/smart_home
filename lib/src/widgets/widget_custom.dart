import 'package:flutter/material.dart';
import 'package:smart_home_pbl5/src/services/service.dart';
import 'package:smart_home_pbl5/src/widgets/loading.dart';

import '../functions/notification/alert.dart';
import '../functions/navigate/navigate.dart';

// Button micro while recording
typedef ZoomButton = _ZoomInOutButtonState;

class ZoomInOutButton extends StatefulWidget {
  final Widget child;

  const ZoomInOutButton({super.key, required this.child});

  @override
  ZoomButton createState() => _ZoomInOutButtonState();
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
        return SizedBox(
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

// Card custom
class CustomCard extends Card {
  final Widget childWidget;

  const CustomCard({Key? key, required this.childWidget}) : super(key: key);

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
        child: childWidget,
      ),
    );
  }
}

// Wrapper title and switch
typedef SwitchWrapperState = _SwitchWrapperState;

class SwitchWrapper extends StatefulWidget {
  final String text;
  final void Function(bool) onChanged;
  final void Function() onTap;
  final bool value;
  final bool? isLoading;
  final int deviceId;

  const SwitchWrapper(
      {super.key,
      required this.text,
      required this.onTap,
      required this.onChanged,
      required this.value,
      this.isLoading,
      required this.deviceId});

  @override
  SwitchWrapperState createState() => _SwitchWrapperState();
}

class _SwitchWrapperState extends State<SwitchWrapper> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Text(
              widget.text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          (widget.isLoading!)
              ? const CircularLoading()
              : PopupMenuAction(
                  deviceId: widget.deviceId,
                ),
          Switch(
            value: widget.value,
            onChanged: widget.onChanged,
          ),
        ],
      ),
    );
  }
}

// Menu
enum ActionItem { remove }

class PopupMenuAction extends StatefulWidget {
  final int deviceId;

  const PopupMenuAction({super.key, required this.deviceId});

  @override
  State<PopupMenuAction> createState() => _PopupMenuActionState();
}

class _PopupMenuActionState extends State<PopupMenuAction> {
  ActionItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PopupMenuButton<ActionItem>(
        initialValue: selectedMenu,
        // Callback that sets the selected popup menu item.
        onSelected: (ActionItem item) {
          setState(() {
            selectedMenu = item;
          });
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<ActionItem>>[
          PopupMenuItem<ActionItem>(
            value: ActionItem.remove,
            child: TextButton(
                onPressed: () => {
                      showAlert(
                          const Text("Delete device"),
                          const Text("Are you sure?"),
                          <Widget>[
                            OutlinedButton(
                              child: const Text("Cancel"),
                              onPressed: () {
                                closeModal(context);
                              },
                            ),
                            ElevatedButton(
                                child: const Text("Delete"),
                                onPressed: () async {
                                  var statusCode =
                                      await deleteDevice(widget.deviceId);
                                  if (statusCode == 200) {
                                    if (mounted) {
                                      closeModal(context);
                                    }
                                  } else {
                                    if (mounted) {
                                      showAlert(
                                          const Text("Delete device failed"),
                                          const Text(
                                              "Can't delete this device. Please try again."),
                                          <Widget>[
                                            ElevatedButton(
                                                onPressed: () =>
                                                    {closeModal(context)},
                                                child: const Text("OK"))
                                          ],
                                          context);
                                    }
                                  }
                                }),
                          ],
                          context)
                    },
                child: const Text("Remove")),
          )
        ],
      ),
    );
  }
}
