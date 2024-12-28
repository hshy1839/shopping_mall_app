import 'package:attedance_app/views/main_activity/cart_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

// 화면들 import
import 'package:attedance_app/views/login_activity/login.dart';
import 'package:attedance_app/views/login_activity/signup.dart';
import 'package:attedance_app/views/main_activity/category_screen.dart';
import 'package:attedance_app/views/main_activity/main_screen.dart';
import 'package:attedance_app/views/main_activity/notice_screen.dart';
import 'package:attedance_app/views/main_activity/profile_screen.dart';
import 'footer.dart';
import 'package:attedance_app/shopping_screen/shopping_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compete Exercise App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _determineInitialScreen(), // 초기 화면을 결정합니다.
      onGenerateRoute: (settings) => _generateRoute(settings),
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MainScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case '/notice':
        return MaterialPageRoute(builder: (_) => NoticeScreen());
      case '/shoppingscreen':
        return MaterialPageRoute(
          builder: (_) => ShoppingScreen(categoryName: 'Selected Category'),
        );
      case '/cart':
        return MaterialPageRoute(builder: (_) => CartDetailScreen());
      default:
        return MaterialPageRoute(builder: (_) => MainScreenWithFooter());
    }
  }

  Widget _determineInitialScreen() {
    return FutureBuilder<Widget>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error occurred'));
        } else {
          // 로그인 상태에 맞는 화면 반환
          if (snapshot.data is LoginScreen) {
            return LoginScreen(); // 로그인 화면 반환
          } else {
            return MainScreenWithFooter(); // 로그인 후 메인 화면
          }
        }
      },
    );
  }

  Future<Widget> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final token = prefs.getString('token'); // 토큰을 확인

    // 로그인 안 된 경우 로그인 화면
    if (!isLoggedIn || token == null) {
      return LoginScreen();
    }
    return MainScreenWithFooter(); // 로그인 후 메인 화면
  }
}

class MainScreenWithFooter extends StatefulWidget {
  @override
  _MainScreenWithFooterState createState() => _MainScreenWithFooterState();
}

class _MainScreenWithFooterState extends State<MainScreenWithFooter> {
  int _currentIndex = 0;

  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    MainScreen(),
    CategoryScreen(),
    LoginScreen(), // 로그인 화면을 추가하여 리디렉션 처리
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: _pages,
        ),
      ),
      bottomNavigationBar: Footer(onTabTapped: _onTabTapped, selectedIndex: _currentIndex),
    );
  }

  Future<void> _refresh() async {
    setState(() {
      // 필요한 상태를 업데이트합니다.
    });
  }
}
