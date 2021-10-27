import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;


class NotificationService {

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('tasktodo_logo');

    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestSoundPermission: false,
      requestBadgePermission: false,
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {}
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  } 

  Future<void> showNotification({required int id, required String title, required String body, required int seconds}) async {
    await flutterLocalNotificationsPlugin.schedule(
      id, 
      title, 
      body, 
      DateTime.now().add(Duration(seconds: seconds)), 
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_notif',
          'alarm_notif',
          icon: 'tasktodo_logo',
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
        ),
        iOS: IOSNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),  
      androidAllowWhileIdle: true
    );
  }

  Future<void> showOneHourBeforeNotification({required int id, required String title, required String body}) async {
    await flutterLocalNotificationsPlugin.schedule(
      id, 
      title, 
      body, 
      DateTime.now().add(const Duration(seconds: 10)), 
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_notif',
          'alarm_notif',
          icon: 'tasktodo_logo',
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
        ),
        iOS: IOSNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),  
      androidAllowWhileIdle: true
    );
  }

}