// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'dart:typed_data';
//
// class LocalNotificationService {
//   static FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   static void initialize() {
//     // initializationSettings  for Android and ios
//     var iosInitialization = const DarwinInitializationSettings();
//     var androidInitialization =
//         const AndroidInitializationSettings("@mipmap/ic_launcher");
//     var initializationSettings = InitializationSettings(
//         android: androidInitialization, iOS: iosInitialization);
//
//     notificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         // Handle notification tap
//       },
//     );
//
//     // Create notification channels for Android
//     _createNotificationChannels();
//   }
//
//   static void _createNotificationChannels() async {
//     // Create patrol notification channel
//     AndroidNotificationChannel patrolChannel = AndroidNotificationChannel(
//       'patrol_channel',
//       'Patrol Alerts',
//       description: 'Notifies 5 minutes before patrol starts',
//       importance: Importance.high,
//       playSound: true,
//       sound: RawResourceAndroidNotificationSound('alert_sound'),
//       enableVibration: true,
//       vibrationPattern: Int64List.fromList([0, 250, 250, 250]),
//     );
//
//     // Create SOS notification channel
//     AndroidNotificationChannel sosChannel = AndroidNotificationChannel(
//       'pushnotificationappSOS',
//       'SOS Alerts',
//       description: 'Emergency SOS notifications',
//       importance: Importance.max,
//       playSound: true,
//       sound: RawResourceAndroidNotificationSound('alert_sound'),
//       enableVibration: true,
//       vibrationPattern: Int64List.fromList([0, 500, 250, 500]),
//     );
//
//     // Create general notification channel
//     const AndroidNotificationChannel generalChannel =
//         AndroidNotificationChannel(
//       'pushnotificationapp',
//       'General Notifications',
//       description: 'General app notifications',
//       importance: Importance.high,
//       playSound: true,
//       enableVibration: true,
//     );
//
//     await notificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(patrolChannel);
//
//     await notificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(sosChannel);
//
//     await notificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(generalChannel);
//   }
//
//   static void createanddisplaynotification(RemoteMessage? message) async {
//     try {
//
//       final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//       NotificationDetails notificationDetails = const NotificationDetails(
//           android: AndroidNotificationDetails(
//             "pushnotificationapp",
//             "pushnotificationapp",
//             importance: Importance.max,
//             priority: Priority.high,
//             styleInformation: BigTextStyleInformation(''),
//             playSound: true,
//           ),
//           iOS: DarwinNotificationDetails());
//       NotificationDetails notificationDetailsSOS = const NotificationDetails(
//           android: AndroidNotificationDetails(
//             "pushnotificationappSOS",
//             "pushnotificationappSOS",
//             importance: Importance.max,
//             priority: Priority.high,
//             playSound: true,
//             sound: RawResourceAndroidNotificationSound('alert_sound'),
//             styleInformation: BigTextStyleInformation(''),
//             // "sos_sound.mp3"
//           ),
//           iOS: DarwinNotificationDetails(
//             sound: "alert_sound.mp3",
//           ));
//       await notificationsPlugin.show(
//         id,
//         message?.notification?.title,
//         message?.notification?.body,
//         message?.notification?.title!.toLowerCase().contains("sos") == true
//             ? notificationDetailsSOS
//             : notificationDetails,
//         payload: message?.data.toString(),
//       );
//     } on Exception catch (e) {
//       debugPrint('error $e');
//     }
//   }
//
//   Future<void> scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime startTime,
//   }) async {
//     final now = tz.TZDateTime.now(tz.local);
//     var scheduledTime =
//         tz.TZDateTime.from(startTime, tz.local).subtract(Duration(minutes: 5));
//
//     // If the scheduled time is in the past, adjust it to fire 5 seconds later from now
//     if (scheduledTime.isBefore(now)) {
//       print('⚠️ Scheduled time is in the past. Adjusting to now + 5 seconds.');
//       scheduledTime = now.add(Duration(seconds: 5));
//     }
//
//     print('--- SCHEDULING PATROL NOTIFICATION ---');
//     print('Notification ID: $id');
//     print('Title: $title');
//     print('Body: $body');
//     print('Patrol Start Time: $startTime');
//     print('Notification will fire at: $scheduledTime');
//     print('Current time: $now');
//
//     // Cancel existing notification with same ID
//     await notificationsPlugin.cancel(id);
//
//     await notificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       scheduledTime,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           'patrol_channel',
//           'Patrol Alerts',
//           channelDescription: 'Notifies 5 minutes before patrol starts',
//           importance: Importance.high,
//           priority: Priority.high,
//           sound: RawResourceAndroidNotificationSound('alert_sound'),
//           playSound: true,
//           enableVibration: true,
//           vibrationPattern: Int64List.fromList([0, 250, 250, 250]),
//           showWhen: true,
//           when: 0,
//         ),
//         iOS: DarwinNotificationDetails(
//           sound: 'alert_sound.aiff',
//           presentSound: true,
//         ),
//       ),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//
//     print('✅ Notification scheduled successfully with ID: $id');
//   }
//
//   Future<void> cancelNotification(int id) async {
//     await notificationsPlugin.cancel(id);
//     print('Notification cancelled with ID: $id');
//   }
//
//   Future<void> cancelAllNotifications() async {
//     await notificationsPlugin.cancelAll();
//     print('All notifications cancelled');
//   }
//
//   Future<List<PendingNotificationRequest>> getPendingNotifications() async {
//     return await notificationsPlugin.pendingNotificationRequests();
//   }
// }
