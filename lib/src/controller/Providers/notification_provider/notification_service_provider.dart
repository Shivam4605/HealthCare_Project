import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthcare/src/controller/Providers/notification_provider/local_notification.dart';
import 'package:healthcare/src/controller/Providers/user_provider/user_role_info_provider.dart';
import 'package:healthcare/src/controller/local_storage/user_credential_local.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Background message received: ${message.messageId}');
  log('Title: ${message.notification?.title}');
  log('Body: ${message.notification?.body}');
  log('Data: ${message.data}');

  if (message.notification != null) {
    await LocalNotificationService.showNotificationFromMessage(message);
  }
}

class NotificationProvider extends ChangeNotifier {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final UserInfoProvider userProvider;

  NotificationProvider(this.userProvider);

  bool _enabled = false;
  String? _token;

  bool get enabled => _enabled;
  String? get token => _token;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;
  String? get _role => userProvider.userModel.selectedRole;

  Future<void> init() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        log('No user logged in');
        return;
      }

      await LocalNotificationService.initialize();
      await LocalNotificationService.createNotificationChannels();

      await _setupMessageHandlers();

      final doc = await _db.collection("usersNotification").doc(user.uid).get();

      if (doc.exists) {
        _enabled = doc.data()?['notificationsEnabled'] ?? false;
        _token = doc.data()?['fcmToken'];
      }

      final settings = await _messaging.getNotificationSettings();

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        _enabled = false;
        log('Notifications not authorized');
      }

      _listenTokenRefresh();

      notifyListeners();
      log('NotificationProvider initialized successfully');
    } catch (e) {
      log("Init Error: $e");
    }
  }

  Future<void> _setupMessageHandlers() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log("Foreground message received");

      await LocalNotificationService.showNotificationFromMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log("Notification tapped from background");
      _handleNotificationTap(message);
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      log("Opened from terminated state");
      _handleNotificationTap(initialMessage);
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    log('Handling notification tap: ${message.data}');

    if (message.data.containsKey('screen')) {
      final screen = message.data['screen'];
      log('Navigate to screen: $screen');

      switch (screen) {
        case 'appointments':
          log('Navigate to appointments screen');
          // Navigator.pushNamed(context, '/appointments');
          break;
        case 'profile':
          log('Navigate to profile screen');
          // Navigator.pushNamed(context, '/profile');
          break;
        case 'chat':
          log('Navigate to chat screen');
          // Navigator.pushNamed(context, '/chat');
          break;
        default:
          log('Unknown screen: $screen');
      }
    }
  }

  Future<void> enableNotifications() async {
    try {
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
      );

      log('Permission status: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        _enabled = true;

        _token = await _messaging.getToken();
        log('FCM Token: $_token');

        if (_role != null && _role!.isNotEmpty) {
          await _messaging.subscribeToTopic(_role!);
          log('Subscribed to topic: $_role');
        }

        await _messaging.subscribeToTopic("general");
        log('Subscribed to topic: general');

        await _saveToFirestore();

        notifyListeners();
        log('Notifications enabled successfully');
      } else {
        log('Permission denied');
      }
    } catch (e) {
      log('Error enabling notifications: $e');
    }
  }

  Future<void> disableNotifications() async {
    if (_role != null && _role!.isNotEmpty) {
      await _messaging.unsubscribeFromTopic(_role!);
    }

    await _messaging.unsubscribeFromTopic("general");

    await _messaging.deleteToken();

    _enabled = false;
    _token = null;

    await _db.collection("usersNotification").doc(_uid).set({
      "notificationsEnabled": false,
      "fcmToken": null,
    }, SetOptions(merge: true));

    notifyListeners();
  }

  Future<void> toggle(bool value) async {
    value ? await enableNotifications() : await disableNotifications();
  }

  Future<void> _saveToFirestore() async {
    try {
      Map<String, dynamic> data = await UserCredentials()
          .fetchUserCredentials();

      await _db.collection("usersNotification").doc(_uid).set({
        "notificationsEnabled": true,
        "fcmToken": _token,
        "role": data['selectedRole'] ?? _role,
        "platform": 'android',
        "updatedAt": FieldValue.serverTimestamp(),
        "createdAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      log('Notification settings saved to Firestore');
    } catch (e) {
      log('Error saving to Firestore: $e');
    }
  }

  void _listenTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      _token = newToken;
      log('Token refreshed: $newToken');

      try {
        await _db.collection("usersNotification").doc(_uid).set({
          "fcmToken": newToken,
          "updatedAt": FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        log('New token saved to Firestore');
      } catch (e) {
        log('Error saving refreshed token: $e');
      }
    });
  }

  Future<void> sendTestNotification() async {
    await LocalNotificationService.showNotification(
      title: 'Test Notification',
      body: 'This is a test notification from Healthcare App',
      payload: 'test_payload',
    );
  }

  /// Delete FCM token (on logout)
  Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      _token = null;

      await _db.collection("usersNotification").doc(_uid).set({
        "fcmToken": FieldValue.delete(),
        "notificationsEnabled": false,
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      log('FCM token deleted');
    } catch (e) {
      log('Error deleting token: $e');
    }
  }
}
