import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/core/config/env/logger_config.dart';

class FirebaseConfiguration {
  static Future<void> initFirebaseConfiguration() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final String? fcmToken = await FirebaseMessaging.instance.getToken();
    logg(fcmToken);

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      logg('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      logg('User granted provisional permission');
    } else {
      logg('User declined or has not accepted permission');
      return;
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.setAutoInitEnabled(true);
  }

  static Future<void> initEvent(BuildContext context) async {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? value) async {
      if (value != null) {
        logg(
          '[FIREBASE] getInitialMessage ------------ ${value.data}',
        );
      }
    });

    FirebaseMessaging.onMessage.listen(_firebaseMessagingHandler);

    FirebaseMessaging.onMessageOpenedApp
        .listen(_firebaseMessagingOpenedAppHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    logg(
      '''[FIREBASE] firebaseMessagingBackgroundHandler ${message.messageId}''',
    );
    logg(
      '''[FIREBASE] message.title ${message.notification?.title}''',
    );
    logg(
      '''[FIREBASE] message.body ${message.notification?.body}''',
    );
    logg(
      '''[FIREBASE] message.data: ${message.data}''',
    );
  }

  static Future<void> _firebaseMessagingHandler(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    logg('''[FIREBASE] firebaseMessagingHandler ${message.messageId}''');
    logg(
      '''[FIREBASE] message.title: ${message.notification?.title}''',
    );
    logg(
      '''[FIREBASE] message.body: ${message.notification?.body}''',
    );

    if (notification != null && android != null && !kIsWeb) {
      logg(
        '[FIREBASE] message.data: ${message.data}',
      );
    }
  }

  static Future<void> _firebaseMessagingOpenedAppHandler(
    RemoteMessage message,
  ) async {
    logg(
      '''[FIREBASE] firebaseMessagingOpenedAppHandler ${message.messageId}''',
    );
    logg('[FIREBASE] message.data---${message.data}');
  }
}
