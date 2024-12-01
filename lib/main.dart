import 'dart:io';

import 'package:attedance_app/login_activity/signup.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'login_activity/login.dart'; // 로그인 페이지 주석 처리
import 'main_screen.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase 관련 코드 주석 처리
import 'package:firebase_messaging/firebase_messaging.dart'; // Firebase 관련 코드 주석 처리
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Firebase 푸시 알림 관련 코드 주석 처리

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); // Firebase 초기화 코드 주석 처리

  // FirebaseMessaging fbMsg = FirebaseMessaging.instance;
  // String? fcmToken = await fbMsg.getToken(vapidKey: "BGRA_GV..........keyvalue");
  // print("token-------------------------: $fcmToken");

  // FCM 토큰 갱신 이벤트 리스너
  // fbMsg.onTokenRefresh.listen((nToken) {
  //   print("새로 받은 토큰: $nToken");
  //   // 서버에 해당 토큰 저장 로직 구현
  // });

  // Firebase Notification 설정
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  // FlutterLocalNotificationsPlugin();
  // AndroidNotificationChannel? androidNotificationChannel;

  // if (Platform.isIOS) {
  //   await reqIOSPermission(fbMsg); // iOS 권한 요청
  // } else if (Platform.isAndroid) {
  //   // Android 8 (API 26) 이상부터 채널설정이 필수
  //   androidNotificationChannel = const AndroidNotificationChannel(
  //     'important_channel', // id
  //     'Important_Notifications', // name
  //     description: '중요도가 높은 알림을 위한 채널.',
  //     // description
  //     importance: Importance.high,
  //   );
  //   Future<void> reqAndroidPermission() async {
  //     if (Platform.isAndroid) {
  //       // Android 13 이상에서는 명시적으로 알림 권한을 요청해야 함
  //       if (await Permission.notification.isDenied) {
  //         // 권한이 거부된 경우 요청
  //         await Permission.notification.request();
  //       }
  //     }
  //   }

  //   await flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
  //       ?.createNotificationChannel(androidNotificationChannel);

  //   await reqAndroidPermission();
  // }

  // 백그라운드에서 알림 처리
  // FirebaseMessaging.onBackgroundMessage(fbMsgBackgroundHandler);

  // 포어그라운드에서 알림 처리
  // FirebaseMessaging.onMessage.listen((message) {
  //   fbMsgForegroundHandler(message, flutterLocalNotificationsPlugin, androidNotificationChannel);
  // });

  // 메세지 클릭 이벤트 처리
  // await setupInteractedMessage(fbMsg);

  runApp(const MyApp());
}

// iOS 권한 요청 함수
// Future reqIOSPermission(FirebaseMessaging fbMsg) async {
//   NotificationSettings settings = await fbMsg.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
// }

// Firebase Background Messaging 핸들러
// Future<void> fbMsgBackgroundHandler(RemoteMessage message) async {
//   print("[FCM - Background] MESSAGE : ${message.messageId}");
// }

// Firebase Foreground Messaging 핸들러
// Future<void> fbMsgForegroundHandler(
//     RemoteMessage message,
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
//     AndroidNotificationChannel? channel) async {
//   print('[FCM - Foreground] MESSAGE : ${message.data}');

//   if (message.notification != null) {
//     print('Message also contained a notification: ${message.notification}');
//     flutterLocalNotificationsPlugin.show(
//         message.hashCode,
//         message.notification?.title,
//         message.notification?.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             channel!.id,
//             channel.name,
//             icon: '@mipmap/ic_launcher',
//             visibility: NotificationVisibility.public,
//             priority: Priority.high,
//             importance: Importance.high,
//           ),
//         ));
//   }
// }

// FCM 메시지 클릭 이벤트 정의
// Future<void> setupInteractedMessage(FirebaseMessaging fbMsg) async {
//   RemoteMessage? initialMessage = await fbMsg.getInitialMessage();
//   if (initialMessage != null) clickMessageEvent(initialMessage);
//   FirebaseMessaging.onMessageOpenedApp.listen(clickMessageEvent);
// }

void clickMessageEvent(RemoteMessage message) {
  // FCM 알림을 클릭한 후 처리할 로직
  print('알림 클릭됨: ${message.data}');
  // 예: 알림 클릭 시 특정 화면으로 네비게이션
}

// 앱의 메인 화면을 설정
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login', // 초기 화면 설정
      routes: {
        '/login': (context) => LoginScreen(), // 로그인 페이지
        '/main': (context) => MainScreen(),
        '/signup': (context) => SignupScreen(),
      },
    );
  }
}
