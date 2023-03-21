import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_home_pbl5/src/functions/navigate/navigate.dart';

import 'package:smart_home_pbl5/src/functions/records/record.dart';
import 'package:smart_home_pbl5/src/services/service.dart';
import 'package:smart_home_pbl5/src/session/session.dart';
import 'package:smart_home_pbl5/src/widgets/widget_custom.dart';

import '../functions/alert/alert.dart';
import '../widgets/drawer.dart';
import '../widgets/form.dart';
import '../widgets/loading.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String _username = "username";
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
  bool isLoadingDevices = true;
  bool isLoadingInformation = true;
  int _count = 1;

  @override
  void initState() {
    super.initState();
    _loadUser();
    if (mounted) {
      timer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
        // Call your function here
        _getDevices();
        _getInformation();
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
      setState(() {
        isLoadingInformation = false;
      });
    }
  }

  // Load list devices
  void _getDevices() async {
    final data = await getDevice();

    if (data != -1) {
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
        setState(() {
          isLoadingDevices = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _count++;
        });
        if (_count % 1000 == 0) {
          showAlert(
              const Text("Failed while loading devices!"),
              const Text(
                  "Have trouble while loading devices! Please login again"),
              [
                ElevatedButton(
                    onPressed: () => {
                          Navigator.pushNamedAndRemoveUntil(
                              context, "/login", (route) => false)
                        },
                    child: const Text("Logout"))
              ],
              context);
        }
      }
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
      navigatePage(context, '/login');
    }
  }

  // Open modal to add device
  void _openModalAddDevice() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Add new device'),
          content: AddDeviceForm(),
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
      drawer: SidebarDrawer(
        username: _username,
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
                      onPressed: () => {
                        showAlert(
                            const Text("Temperature"),
                            Text("$_temperature℃"),
                            [
                              ElevatedButton(
                                  onPressed: () => {closeModal(context)},
                                  child: const Text("OK"))
                            ],
                            context)
                      },
                    ),
                    MyButton(
                        text: const Text("Humidity"),
                        icon: const Icon(
                          Icons.water_drop_outlined,
                          size: 50,
                        ),
                        onPressed: () => {
                          showAlert(
                              const Text("Humidity"),
                              Text("$_humidity%"),
                              [
                                ElevatedButton(
                                    onPressed: () => {closeModal(context)},
                                    child: const Text("OK"))
                              ],
                              context)
                        }),
                    MyButton(
                        text: const Text("Activity"),
                        icon: const Icon(
                          Icons.visibility_outlined,
                          size: 50,
                        ),
                        onPressed: () => {
                          showAlert(
                              const Text("Number of active devices"),
                              Text("$_numberOfActiveDevice devices"),
                              [
                                ElevatedButton(
                                    onPressed: () => {closeModal(context)},
                                    child: const Text("OK"))
                              ],
                              context)
                        }),
                  ]),
                  TableRow(children: <Widget>[
                    Center(
                      child: isLoadingInformation
                          ? const CircularLoading()
                          : Text("$_temperature℃",
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                    ),
                    Center(
                      child: isLoadingInformation
                          ? const CircularLoading()
                          : Text("$_humidity%",
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                    ),
                    Center(
                      child: isLoadingDevices
                          ? const CircularLoading()
                          : Text("$_numberOfActiveDevice",
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                    ),
                  ])
                ],
              ),
            ),
            Wrap(
              children: <Widget>[
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
                isLoadingDevices
                    ? const Center(
                        child: Text("Loading..."),
                      )
                    : CustomCard(
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
                              headerBuilder:
                                  (BuildContext context, bool isExpand) {
                                return ListTile(
                                  title: const Text('Door'),
                                  subtitle: Text(
                                      '$_numberOfActiveDoors door is open'),
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.door_back_door_outlined),
                                  ),
                                );
                              },
                              body: ListDevices(
                                devices: doors,
                                onChange: _switchChange,
                              ),
                              isExpanded: _isPanelDoorExpanded,
                            ),
                            ExpansionPanel(
                              headerBuilder:
                                  (BuildContext context, bool isExpand) {
                                return ListTile(
                                  title: const Text('Light'),
                                  subtitle: Text(
                                      '$_numberOfActiveLights device is activity'),
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.light_mode_sharp),
                                  ),
                                );
                              },
                              body: ListDevices(
                                devices: lights,
                                onChange: _switchChange,
                              ),
                              isExpanded: _isPanelLightExpanded,
                            ),
                            ExpansionPanel(
                              headerBuilder:
                                  (BuildContext context, bool isExpand) {
                                return ListTile(
                                  title: const Text('Fan'),
                                  subtitle: Text(
                                      '$_numberOfActiveFans device is activity'),
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.wind_power),
                                  ),
                                );
                              },
                              body: ListDevices(
                                devices: fans,
                                onChange: _switchChange,
                              ),
                              isExpanded: _isPanelFanExpanded,
                            ),
                          ],
                        ),
                      ),
              ],
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: const RecordAudio(), // Button record
    );
  }
}
