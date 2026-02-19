import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/firebase_options.dart';
import 'package:healthcare/src/controller/Providers/auth_provider/forgot_password_provider.dart';
import 'package:healthcare/src/controller/Providers/auth_provider/login_provider.dart';
import 'package:healthcare/src/controller/Providers/auth_provider/logout_provider.dart';
import 'package:healthcare/src/controller/Providers/auth_provider/sign_up_provider.dart';
import 'package:healthcare/src/controller/Providers/notification_provider/local_notification.dart';
import 'package:healthcare/src/controller/Providers/notification_provider/notification_service_provider.dart';
import 'package:healthcare/src/controller/services/gemini_api_services.dart';
import 'package:healthcare/src/controller/Providers/user_provider/user_role_info_provider.dart';
import 'package:healthcare/src/view/common_screens/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> _backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  await LocalNotificationService.initialize();
  await LocalNotificationService.createNotificationChannels();

  await LocalNotificationService.showNotificationFromMessage(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

  await LocalNotificationService.initialize();
  await LocalNotificationService.createNotificationChannels();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseOptions catch (e) {
    log("Firebase initialization error: $e");
  }

  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(alert: true, badge: true, sound: true);

  String? token = await messaging.getToken();
  log('FCM Token: $token');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserInfoProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => SignUpProvider()),
        ChangeNotifierProvider(create: (context) => ForgotPasswordProvider()),
        ChangeNotifierProvider(create: (context) => LogoutProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProxyProvider<UserInfoProvider, NotificationProvider>(
          create: (context) =>
              NotificationProvider(context.read<UserInfoProvider>()),
          update: (context, userProvider, previous) =>
              NotificationProvider(userProvider),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
