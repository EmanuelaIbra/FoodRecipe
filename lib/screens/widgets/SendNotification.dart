import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> sendNotification(String recipeName) async {
  String serverToken =
      'AAAAWMHn_s0:APA91bGfb5pMft68uT3giI5QB6Ri3Blp9C3pwB56i6vKbdOq6w6OT0uWyhI6faQFkHW6bYIqzY4k9ZcKffovr0rQl5hKzUdzo3rNg-JP5sDDIo7pisHgTydX8iizl6B7DABTdWfRj1Hz';
  String topic = 'recipes';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  await firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  await firebaseMessaging.subscribeToTopic(topic);

  var message = {
    'notification': {'title': 'New Recipe Added', 'body': recipeName},
    'to': '/topics/$topic'
  };

  try {
    var response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'key=$serverToken',
            },
            body: jsonEncode(message));

    print('Notification sent with response code ${response.statusCode}');
  } catch (e) {
    print('Error sending notification: $e');
  }
}
