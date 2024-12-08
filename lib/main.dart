import 'dart:io';

import 'package:attedance_app/views/login_activity/signup.dart';
import 'package:attedance_app/views/main_activity/notice_screen.dart';
import 'package:attedance_app/views/main_activity/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'footer.dart';
import 'views/login_activity/login.dart'; // 로그인 페이지 주석 처리
import 'views/main_activity/main_screen.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase 관련 코드 주석 처리
import 'package:firebase_messaging/firebase_messaging.dart'; // Firebase 관련 코드 주석 처리
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Firebase 푸시 알림 관련 코드 주석 처리

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

void clickMessageEvent(RemoteMessage message) {
  // FCM 알림을 클릭한 후 처리할 로직
  print('알림 클릭됨: ${message.data}');
  // 예: 알림 클릭 시 특정 화면으로 네비게이션
}

// 앱의 메인 화면을 설정
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late PageController _pageController;
  int _currentIndex = 0; // 현재 페이지 인덱스
  final List<Widget> _pages = [
    // 각 페이지를 설정
    MainScreen(),
    //CategoryPage(),
    //HelpPage(),
    //PurchasePage(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  // 페이지 새로 고침 함수
  Future<void> _refresh() async {
    // 여기에 새로 고침 작업을 처리하는 코드를 추가합니다
    await Future.delayed(Duration(seconds: 2)); // 예시로 2초 딜레이
    setState(() {}); // 새로 고침 후 상태 업데이트
  }

  // 탭 변경 함수
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index); // 선택된 페이지로 이동
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      initialRoute: '/main', // 초기 화면 설정
      routes: {
        '/login': (context) => LoginScreen(), // 로그인 페이지
        '/main': (context) => MainScreen(),
        '/signup': (context) => SignupScreen(),
        '/notice': (context) => NoticeScreen(),
        '/profile': (context) => ProfileScreen(),
      },
      home: Scaffold(
        body: RefreshIndicator( // RefreshIndicator 추가
          onRefresh: _refresh, // 새로 고침 콜백 설정
          child: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(), // 페이지 스와이프 방지
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: _pages, // 페이지들
          ),
        ),
        bottomNavigationBar: Footer(onTabTapped: _onTabTapped, selectedIndex: _currentIndex),
      ),
    );
  }
}