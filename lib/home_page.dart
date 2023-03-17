import 'dart:async';

import 'package:flutter/material.dart';

import 'package:smart_home_pbl5/record.dart';
import 'package:smart_home_pbl5/service.dart';
import 'package:smart_home_pbl5/session.dart';
import 'package:smart_home_pbl5/widget_custom.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String _username;
  List<dynamic> devices = [];
  List<dynamic> lights = [];
  List<dynamic> fans = [];
  List<dynamic> doors = [];
  int _numberOfActiveDevice = 0;
  int _numberOfActiveDoors = 0;
  int _numberOfActiveLights = 0;
  int _numberOfActiveFans = 0;
  late int _temperature = 0;
  late int _humidity = 0;
  bool _isPanelDoorExpanded = false;
  bool _isPanelLightExpanded = false;
  bool _isPanelFanExpanded = false;
  late var timer;

  @override
  void initState() {
    super.initState();
    _loadUser();
    if (mounted) {
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        // Call your function here
        _getDevices();
        // _getInformation();
        _countActiveDevices();
        _navigatePage(context);
      });
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  // Count active devices
  void _countActiveDevices() {
    int countDoor = 0;
    int countLight = 0;
    int countFan = 0;
    for (int i = 0; i < devices.length; i++) {
      final device = devices[i];
      if (device["status"]) {
        switch (device["type"]) {
          case "1":
            countLight++;
            break;
          case "2":
            countFan++;
            break;
          case "3":
            countDoor++;
            break;
          default:
            print("Type undefine?!");
        }
      }
    }
    if (mounted) {
      setState(() {
        _numberOfActiveDoors = countDoor;
        _numberOfActiveLights = countLight;
        _numberOfActiveFans = countFan;
        _numberOfActiveDevice = countDoor + countLight + countFan;
      });
    }
  }

  // Divide type Light(1), Fan(2), Door(3)
  List<dynamic> filterDevice(String typeDevice) {
    List<dynamic> listDevice = [];

    for (int i = 0; i < devices.length; i++) {
      final device = devices[i];
      if (device["type"] == typeDevice) {
        listDevice.add(devices[i]);
      }
    }
    return listDevice;
  }

  // Get temperature, humidity
  void _getInformation() async {
    final data = await getTemperatureAndHumidity();
    if (mounted) {
      setState(() {
        _temperature = (data['temp'] - 273.15).round();
        _humidity = data['humidity'];
      });
    }
    print("$_temperature $_humidity");
  }

  // Load list devices
  void _getDevices() async {
    final data = await getDevice();

    if (data["detail"].toString() == "null") {
      if (mounted) {
        setState(() {
          devices = data["data"];
        });
        setState(() {
          lights = filterDevice("1");
        });
        setState(() {
          fans = filterDevice("2");
        });
        setState(() {
          doors = filterDevice("3");
        });
      }
    } else {
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  // Change status of device
  Future<Set<void>> Function(bool value) _switchChange(deviceId, value) {
    return (value) async => {await updateDevice(deviceId, value)};
  }

  // Navigate page if have no session
  void _navigatePage(context) async {
    bool isLoggedIn = await checkSession();
    if (!isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  // Open modal to add device
  void _openModalAddDevice() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Add new device'),
          content: FormAddDevice(),
        );
      },
    );
  }

  // Load username
  void _loadUser() async {
    String username = await getUserLogin();
    if (mounted) {
      setState(() {
        _username = username;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(_username),
              currentAccountPicture: CircleAvatar(
                child: Text(
                  _username[0].toUpperCase(),
                  style: const TextStyle(fontSize: 50,),
                ),
              ),
              accountEmail: null,
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                // Handle home button tap
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                // Handle settings button tap
              },
            ),
            ListTile(
              title: const Text('Log out'),
              onTap: () {
                // Clear session
                clearSession();
                clearToken();
              },
            ),
          ],
        ),
        // Drawer content goes here
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CustomCard(
              // Show overview information (temperature, humidity, and number of active devices)
              child: Table(
                children: [
                  TableRow(children: <Widget>[
                    MyButton(
                        text: const Text("Feels like"),
                        icon: const Icon(
                          Icons.thermostat,
                          size: 50,
                        ),
                        onPressed: () => {}),
                    MyButton(
                        text: const Text("Humidity"),
                        icon: const Icon(
                          Icons.water_drop_outlined,
                          size: 50,
                        ),
                        onPressed: () => {}),
                    MyButton(
                        text: const Text("Activity"),
                        icon: const Icon(
                          Icons.visibility_outlined,
                          size: 50,
                        ),
                        onPressed: () => {}),
                  ]),
                  TableRow(children: <Widget>[
                    Center(
                      child: Text("$_temperature℃",
                          style: Theme.of(context).textTheme.headlineMedium),
                    ),
                    Center(
                      child: Text("$_humidity%",
                          style: Theme.of(context).textTheme.headlineMedium),
                    ),
                    Center(
                      child: Text("$_numberOfActiveDevice",
                          style: Theme.of(context).textTheme.headlineMedium),
                    ),
                  ])
                ],
              ),
            ),
            Row(
              // Button add device
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: _openModalAddDevice,
                  icon: const Text("Add new device"),
                  label: const Icon(Icons.add),
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
            CustomCard(
              // Expansion panel list contain switch control device
              child: ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    if (index == 0) {
                      _isPanelDoorExpanded = !isExpanded;
                    } else if (index == 1) {
                      _isPanelLightExpanded = !isExpanded;
                    } else {
                      _isPanelFanExpanded = !isExpanded;
                    }
                  });
                },
                children: <ExpansionPanel>[
                  // Item of expansion panel list, include : Lights, Fans, and Doors
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpand) {
                      return ListTile(
                        title: const Text('Door'),
                        subtitle: Text('$_numberOfActiveDoors door is open'),
                        leading: const CircleAvatar(
                          child: Icon(Icons.door_back_door_outlined),
                        ),
                      );
                    },
                    body: Container(
                      padding: const EdgeInsets.fromLTRB(36, 0, 8, 10),
                      child: Wrap(
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: doors.map((device) {
                          return SwitchWrapper(
                              text: device["name"],
                              onChanged:
                                  _switchChange(device["id"], device["status"]),
                              value: device["status"]);
                        }).toList(),
                      ),
                    ),
                    isExpanded: _isPanelDoorExpanded,
                  ),
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpand) {
                      return ListTile(
                        title: const Text('Light'),
                        subtitle:
                            Text('$_numberOfActiveLights device is activity'),
                        leading: const CircleAvatar(
                          child: Icon(Icons.light_mode_sharp),
                        ),
                      );
                    },
                    body: Container(
                      padding: const EdgeInsets.fromLTRB(36, 0, 8, 10),
                      child: Wrap(
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: lights.map((light) {
                          return SwitchWrapper(
                              text: light["name"],
                              onChanged:
                                  _switchChange(light["id"], light["status"]),
                              value: light["status"]);
                        }).toList(),
                      ),
                    ),
                    isExpanded: _isPanelLightExpanded,
                  ),
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpand) {
                      return ListTile(
                        title: const Text('Fan'),
                        subtitle:
                            Text('$_numberOfActiveFans device is activity'),
                        leading: const CircleAvatar(
                          child: Icon(Icons.wind_power),
                        ),
                      );
                    },
                    body: Container(
                      padding: const EdgeInsets.fromLTRB(36, 0, 8, 10),
                      child: Wrap(
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: fans.map((fan) {
                          return SwitchWrapper(
                              text: fan["name"],
                              onChanged:
                                  _switchChange(fan["id"], fan["status"]),
                              value: fan["status"]);
                        }).toList(),
                      ),
                    ),
                    isExpanded: _isPanelFanExpanded,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: const RecordAudio(), // Button record
    );
  }
}
