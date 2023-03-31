import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_home_pbl5/src/functions/navigate/navigate.dart';
import 'package:smart_home_pbl5/src/functions/notification/toast.dart';

import 'package:smart_home_pbl5/src/functions/records/record.dart';
import 'package:smart_home_pbl5/src/services/service.dart';
import 'package:smart_home_pbl5/src/session/session.dart';
import 'package:smart_home_pbl5/src/widgets/widget_custom.dart';

import '../functions/notification/alert.dart';
import '../functions/notification/notification.dart';
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
  late dynamic deviceTypes;
  List<dynamic> devices = [];
  List<dynamic> lights = [];
  List<dynamic> fans = [];
  List<dynamic> doors = [];
  List<dynamic> tems = [];
  List<dynamic> others = [];
  int _numberOfActiveDevice = 0;
  int _numberOfActiveDoors = 0;
  int _numberOfActiveLights = 0;
  int _numberOfActiveFans = 0;
  late int _temperature = 0;
  late int _humidity = 0;
  bool _isPanelDoorExpanded = false;
  bool _isPanelLightExpanded = false;
  bool _isPanelFanExpanded = false;
  late dynamic timer;
  bool isLoadingDevices = true;
  bool isLoadingInformation = true;
  bool isLoading = false;
  int _count = 1;

  Map<int, bool> isUpdatingMap = {};

  @override
  void initState() {
    super.initState();
    initializeNotification();
    _loadUser();
    _getDeviceTypes();
    if (mounted) {
      timer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
        // Call your function here
        _getDevices();
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

  // Set all map updating to false
  void _setUpIsLoadingMap() {
    for (var element in devices) {
      setState(() {
        isUpdatingMap[element["id"]] = false;
      });
    }
  }

  // Get device types
  void _getDeviceTypes() async {
    final data = await getDeviceTypes();
    if (data == -1) {
      if (mounted) {
        showError(context, "Something wrong!!!");
      }
    } else {
      if (mounted) {
        setState(() {
          deviceTypes = data["data"];
        });
      }
    }
  }

  // Count active devices
  void _countActiveDevices() {
    _setUpIsLoadingMap();
    int countDoor = 0;
    int countLight = 0;
    int countFan = 0;
    for (int i = 0; i < devices.length; i++) {
      final device = devices[i];
      if (device["status"]) {
        if (device["type"] == deviceTypes["LED"].toString()) {
          countLight++;
        } else if (device["type"] == deviceTypes["FAN"].toString()) {
          countFan++;
        } else if (device["type"] == deviceTypes["DOOR"].toString()) {
          countDoor++;
        } else if (device["type"] == deviceTypes["TEM"].toString()) {
          // Temperature
        } else if (device["type"] == deviceTypes["OTHER"].toString()) {
          // Other devices
        } else {
          // Undefine devices
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

  // Divide type Light(1), Fan(2), Door(3), Temperature and Humidity(4)
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
  void _getTemperatureAndHumidity() {
    double temperature = 0;
    double humidity = 0;
    for (var tem in tems) {
      temperature += tem["data_value"]["tem"];
      humidity += tem["data_value"]["hum"];
    }
    if (mounted) {
      setState(() {
        _temperature = temperature.toInt();
        _humidity = humidity.toInt();
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
          lights = filterDevice(deviceTypes["LED"].toString());
        });
        setState(() {
          fans = filterDevice(deviceTypes["FAN"].toString());
        });
        setState(() {
          doors = filterDevice(deviceTypes["DOOR"].toString());
        });
        setState(() {
          tems = filterDevice(deviceTypes["TEM"].toString());
        });
        setState(() {
          others = filterDevice(deviceTypes["OTHER"].toString());
        });
        setState(() {
          isLoadingDevices = false;
        });
        _getTemperatureAndHumidity();
      }
    } else {
      if (mounted) {
        setState(() {
          _count++;
        });
        if (_count % 10 == 0) {
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

  // Navigate page if have no session
  void _navigatePage(context) async {
    bool isLoggedIn = await checkSession();
    if (isLoggedIn == false) {
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
          content: AddDeviceForm(
            listDeviceType: [],
          ),
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
              childWidget: Table(
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
                                  Text("$_numberOfActiveDevice devices\n"
                                      "$_numberOfActiveDoors devices\n"
                                      "$_numberOfActiveLights devices\n"
                                      "$_numberOfActiveFans devices"),
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
                        childWidget: ExpansionPanelList(
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
                                  onTap: () => {
                                    setState(() {
                                      _isPanelDoorExpanded =
                                          !_isPanelDoorExpanded;
                                    })
                                  },
                                );
                              },
                              body: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(36, 0, 8, 10),
                                child: Wrap(
                                  spacing: 10.0,
                                  runSpacing: 10.0,
                                  children: doors.map((device) {
                                    return SwitchWrapper(
                                      deviceId: device["id"],
                                      isLoading: isUpdatingMap[device["id"]],
                                      value: device["status"],
                                      onChanged: (bool value) async {
                                        if (mounted) {
                                          setState(() {
                                            isUpdatingMap[device["id"]] = true;
                                            device["status"] = value;
                                          });
                                          await updateDevice(
                                              device["id"], value);
                                          setState(() {
                                            isUpdatingMap[device["id"]] = false;
                                          });
                                        }
                                      },
                                      text: device["name"],
                                      onTap: () {},
                                    );
                                  }).toList(),
                                ),
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
                                  onTap: () => {
                                    setState(() {
                                      _isPanelLightExpanded =
                                          !_isPanelLightExpanded;
                                    })
                                  },
                                );
                              },
                              body: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(36, 0, 8, 10),
                                child: Wrap(
                                  spacing: 10.0,
                                  runSpacing: 10.0,
                                  children: lights.map((device) {
                                    return SwitchWrapper(
                                      deviceId: device["id"],
                                      isLoading: isUpdatingMap[device["id"]],
                                      value: device["status"],
                                      onChanged: (bool value) async {
                                        if (mounted) {
                                          setState(() {
                                            isUpdatingMap[device["id"]] = true;
                                            device["status"] = value;
                                          });
                                          await updateDevice(
                                              device["id"], value);
                                          setState(() {
                                            isUpdatingMap[device["id"]] = false;
                                          });
                                        }
                                      },
                                      text: device["name"],
                                      onTap: () {},
                                    );
                                  }).toList(),
                                ),
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
                                  onTap: () => {
                                    setState(() {
                                      _isPanelFanExpanded =
                                          !_isPanelFanExpanded;
                                    })
                                  },
                                );
                              },
                              body: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(36, 0, 8, 10),
                                child: Wrap(
                                  spacing: 10.0,
                                  runSpacing: 10.0,
                                  children: fans.map((device) {
                                    return SwitchWrapper(
                                      deviceId: device["id"],
                                      isLoading: isUpdatingMap[device["id"]],
                                      value: device["status"],
                                      onChanged: (bool value) async {
                                        if (mounted) {
                                          setState(() {
                                            isUpdatingMap[device["id"]] = true;
                                            device["status"] = value;
                                          });
                                          await updateDevice(
                                              device["id"], value);
                                          setState(() {
                                            isUpdatingMap[device["id"]] = false;
                                          });
                                        }
                                      },
                                      text: device["name"],
                                      onTap: () {},
                                    );
                                  }).toList(),
                                ),
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
