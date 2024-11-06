import 'dart:io';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart'; // for kIsWeb

class PushNotificationController extends GetxController {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void onInit() {
    super.onInit();
    _initializeFlutterLocalNotifications();  // Initialize local notifications
    _requestNotificationPermission();        // Request notification permissions
    _initializeFCM();                        // Initialize Firebase Cloud Messaging
    fetchJobDetails();
  }

  // Handle Background Notification
  @pragma("vm:entry-point")
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    // Create an instance to call the showNotification method
    final notificationController = Get.find<PushNotificationController>();
    notificationController.showNotification(message);
  }

// Show Notification (Background, Foreground)
  void showNotification(RemoteMessage message) async {
    if (message.notification != null) {
      if (message.notification?.title != null) {
        String truncatedBody =
        _truncateMessage(message.notification!.body ?? "", maxLength: 50);

        AndroidNotificationChannel channel = AndroidNotificationChannel(
          Random.secure().nextInt(100000).toString(),
          "High Importance Notification",
          importance: Importance.max,
        );

        AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channel.id.toString(), channel.name,
            importance: Importance.high,
            channelDescription: "Your channel Description",
            ticker: 'ticker',
            icon: '@mipmap/ic_launcher');

        DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

        NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails,
          iOS: darwinNotificationDetails,
        );

        Future.delayed(Duration.zero, () {
          _flutterLocalNotificationsPlugin.show(
              0,
              message.notification!.title.toString(),
              truncatedBody,
              notificationDetails);
        });
      } else {
        print("Title is null-------->");
      }
    }
  }

  String _truncateMessage(String message, {int maxLength = 50}) {
    if (message.length <= maxLength) {
      return message;
    } else {
      return '${message.substring(0, maxLength)}...';
    }
  }

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();



  // Initialize local notifications plugin
  void _initializeFlutterLocalNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher'); // App's icon for notification

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // Initialize the plugin
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        _onSelectNotification(notificationResponse.payload);
      },
    );

    createNotificationChannel(); // Ensure channel is created
  }

  // Create notification channel for Android
  void createNotificationChannel() {
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',  // id
        'High Importance Notifications',  // name
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  // Request notification permission (for Android and iOS)
  void _requestNotificationPermission() async {
    if (!kIsWeb) {
      NotificationSettings settings = await messaging.requestPermission();
      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        print("User declined or has not accepted notification permission");
      } else {
        print("User granted notification permission");
      }
    }
  }

  // Initialize Firebase Cloud Messaging (FCM)
  void _initializeFCM() async {
    await Firebase.initializeApp(); // Ensure Firebase is initialized

    String? token = await messaging.getToken();
    print("FCM Token: $token");  // This is where you send the token to your backend

    // Handle foreground notifications
    _onForegroundMessage();

    // Handle app opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A notification was opened: ${message.data}');
      _onSelectNotification(message.data['payload']); // Handle notification tap
    });

    // Handle background notifications (when app is in background or terminated)
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }


  // Listen to messages when the app is in foreground
  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // Show a local notification if the message contains one
      if (notification != null && android != null) {
        _showFlutterNotification(notification);
      }
    });
  }

  // Handle showing the notification locally
  void _showFlutterNotification(RemoteNotification notification) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'high_importance_channel',  // Channel ID
      'High Importance Notifications',  // Channel Name
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    flutterLocalNotificationsPlugin.show(
      notification.hashCode,  // Unique ID for each notification
      notification.title,     // Notification title
      notification.body,      // Notification body
      platformChannelSpecifics,  // Details for displaying the notification
    );
  }

  // Handle what happens when a notification is tapped
  Future<void> _onSelectNotification(String? payload) async {
    if (payload != null) {
      print('Notification Payload: $payload');
      // Navigate to a specific screen if needed
      // For example, you can use Get.to() to navigate
    }
  }

  // // Background message handler
  // static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //   print('Handling a background message: ${message.messageId}');
  //   // Optionally show a local notification
  //   // Consider handling the message to notify the user
  // }
  final String baseUrl = 'https://e-labour-app.vercel.app/api/v1';

  Future<void> onSelectNotification(String? payload) async {
    if (payload != null) {
      print('Notification Payload: $payload');
      // Navigate to a specific screen if needed
      // For example, you can use Get.to() to navigate
    }
  }


  Future<void> fetchJobDetails() async {
    const String baseUrl = 'https://your-base-url.com';  // Replace with actual base URL
    const String jobId = '67264c525b745a8b02b454f0';

    // Retrieve token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    // Log the retrieved token
    print('TOKEN: $token');

    if (token == null) {
      print('Error: Auth token not found. Please login again.');
      return;
    }

    final Uri url = Uri.parse('$baseUrl/service-provider/job/$jobId');

    // Send GET request with Bearer token
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print('Notification request is made');

    // Log response details
    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Error body: ${response.body}');
    }
  }


}
