import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

const AndroidInitializationSettings initializationSettingsAndroid =
AndroidInitializationSettings('app_icon');

const InitializationSettings initializationSettings = InitializationSettings(
  android: initializationSettingsAndroid,
);

// await
// flutterLocalNotificationsPlugin.initialize
// (
// initializationSettings);

const AndroidNotificationDetails androidPlatformChannelSpecifics =
AndroidNotificationDetails(
'channel id', 'channel name',
importance: Importance.max, priority: Priority.high, ticker: 'ticker');

const NotificationDetails platformChannelSpecifics =
NotificationDetails(android: androidPlatformChannelSpecifics);

// await flutterLocalNotificationsPlugin.show(
// 0, 'Notification Title', 'Notification Body', platformChannelSpecifics
// ,
// payload
//     :
// '
// item x
// '
// );

