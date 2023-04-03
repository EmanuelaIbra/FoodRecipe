import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodrecipe/firebase_options.dart';
import 'package:foodrecipe/screens/HomePage.dart';
import 'package:foodrecipe/screens/SignInPage.dart';
import 'package:foodrecipe/screens/SignUpPage.dart';
import 'package:foodrecipe/screens/AddFood.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import "package:firebase_messaging/firebase_messaging.dart";
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'recipes_channel', // id
  'Recipes', // title
  // description
  importance: Importance.high,
);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            color: Colors.blue,
            playSound: true,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  });
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;

  void signup() async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: 'ela@gmail.com', password: "123456");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Recipe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.white54,
          textTheme: TextTheme(bodyText2: TextStyle(color: Colors.white54))),
      home: SignUpPage(),
    );
  }
}
