// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
// import 'dart:async';
//
// import 'local_notification_service.dart';
// import 'notification_dialog.dart';
// import '../../main.dart'; // Import to access navigatorKey
//
// Future<dynamic> onBackgroundMessageHandler(RemoteMessage message) async {}
//
// class NotificationTrigger {
//   static bool _isInitialized = false;
//   static StreamSubscription<RemoteMessage>? _foregroundSubscription;
//   static StreamSubscription<RemoteMessage>? _backgroundSubscription;
//   static String? _lastMessageId;
//   static Timer? _debounceTimer;
//   static int _initializationCount = 0;
//
//   static Future<void> requestPermissions() async {
//     try {
//       // Request permission for iOS
//       NotificationSettings settings =
//           await FirebaseMessaging.instance.requestPermission(
//         alert: true,
//         announcement: false,
//         badge: true,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: false,
//         sound: true,
//       );
//
//       // Get FCM token
//       String? token = await FirebaseMessaging.instance.getToken();
//       debugPrint('FCM Token: $token');
//
//       // Set foreground notification presentation options
//       await FirebaseMessaging.instance
//           .setForegroundNotificationPresentationOptions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//     } catch (e) {
//       debugPrint("Error requesting permissions: $e");
//     }
//   }
//
//   static trigger(BuildContext context) async {
//     _initializationCount++;
//
//     if (_isInitialized) {
//       return;
//     }
//
//     try {
//       // Request permissions first
//       await requestPermissions();
//
//       // Handle initial message when app is opened from terminated state
//       FirebaseMessaging.instance.getInitialMessage().then((message) async {
//         if (message != null) {
//           LocalNotificationService.createanddisplaynotification(message);
//           _showInAppDialog(message);
//         } else {
//           debugPrint("No initial message found");
//         }
//       });
//
//       // Handle foreground messages - Cancel previous subscription if exists
//       _foregroundSubscription?.cancel();
//
//       _foregroundSubscription = FirebaseMessaging.onMessage.listen(
//         (message) async {
//           if (message.notification != null) {
//             LocalNotificationService.createanddisplaynotification(message);
//
//             _showInAppDialog(message);
//           } else {
//             debugPrint("Message has no notification object");
//           }
//         },
//         onError: (error) {
//           debugPrint("Error in onMessage listener: $error");
//         },
//       );
//
//       // Handle when app is opened from background state - Cancel previous subscription if exists
//       _backgroundSubscription?.cancel();
//
//       _backgroundSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
//         (message) async {
//           LocalNotificationService.createanddisplaynotification(message);
//           _showInAppDialog(message);
//         },
//         onError: (error) {
//           debugPrint("Error in onMessageOpenedApp listener: $error");
//         },
//       );
//
//       _isInitialized = true;
//     } catch (e) {
//       debugPrint("Error initializing notification trigger: $e");
//     }
//   }
//
//   static void _showInAppDialog(RemoteMessage message) {
//     // Create a unique message ID for debouncing (without timestamp)
//     final messageId =
//         '${message.notification?.title}_${message.notification?.body}';
//
//     // Debounce mechanism - prevent multiple dialogs for same message
//     if (_lastMessageId == messageId) {
//       return;
//     }
//
//     _lastMessageId = messageId;
//
//     // Cancel any existing debounce timer
//     _debounceTimer?.cancel();
//
//     // Set a new debounce timer
//     _debounceTimer = Timer(const Duration(milliseconds: 2000), () {
//       _lastMessageId = null; // Reset after delay
//     });
//
//     try {
//       // Use the global navigator key to get the current context
//       final context = navigatorKey.currentContext;
//
//       if (context != null && context.mounted) {
//         // Show dialog immediately without post frame callback
//         try {
//           NotificationDialogService.showNotificationDialog(
//             context,
//             message,
//             onAction: () {
//               _handleNotificationTap(message);
//             },
//           );
//         } catch (e) {
//           debugPrint("Error showing notification dialog: $e");
//         }
//       } else {
//         debugPrint("Global context not available or not mounted");
//       }
//     } catch (e) {
//       debugPrint("Error showing in-app dialog: $e");
//     }
//   }
//
//   static void _handleNotificationTap(RemoteMessage message) {
//     // Handle different types of notifications
//     final title = message.notification?.title?.toLowerCase() ?? '';
//
//     if (title.contains('sos') || title.contains('emergency')) {
//       debugPrint("Handling SOS/Emergency notification");
//       // You can add navigation logic here
//       // Get.to(() => SOSScreen());
//     } else if (title.contains('patrol')) {
//       debugPrint("Handling Patrol notification");
//       // You can add navigation logic here
//       // Get.to(() => PatrolScreen());
//     } else {
//       debugPrint("Handling general notification");
//       // You can add navigation logic here
//       // Get.to(() => NotificationScreen());
//     }
//   }
//
//   // Method to cleanup listeners
//   static void dispose() {
//     _foregroundSubscription?.cancel();
//     _backgroundSubscription?.cancel();
//     _debounceTimer?.cancel();
//     _isInitialized = false;
//     _lastMessageId = null;
//   }
// }
