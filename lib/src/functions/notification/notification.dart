import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> requestNotificationPermission() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();
}

void initializeNotification() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    onDidReceiveLocalNotification: (id, title, body, payload) {},
  );

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> showFireNotification(
    {required String title, String? description}) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('Fire notice', 'Fire notice',
          channelDescription: 'Send notifications when a fire occurs',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false);

  const DarwinNotificationDetails iosPlatformChannelSpecifics =
      DarwinNotificationDetails();

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics);

  await FlutterLocalNotificationsPlugin()
      .show(0, title, description, platformChannelSpecifics, payload: 'item x');
}

Future<void> showWarningNotification(
    {required String title, String? description}) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('Warning', 'Warning safety',
          channelDescription: 'Send notifications when danger is detected',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false);

  const DarwinNotificationDetails iosPlatformChannelSpecifics =
      DarwinNotificationDetails();

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics);

  await FlutterLocalNotificationsPlugin()
      .show(0, title, description, platformChannelSpecifics, payload: 'item x');
}

Future<void> showNotification(
    {required String title, String? description}) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('Notification', 'Notification info',
          channelDescription: 'Send notifications',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false);

  const DarwinNotificationDetails iosPlatformChannelSpecifics =
      DarwinNotificationDetails();

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics);

  await FlutterLocalNotificationsPlugin()
      .show(0, title, description, platformChannelSpecifics, payload: 'item x');
}
