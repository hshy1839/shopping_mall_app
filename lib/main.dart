import 'package:attedance_app/shopping_screen/shopping_screen.dart';
import 'package:attedance_app/views/login_activity/login.dart';
import 'package:attedance_app/views/login_activity/signup.dart';
import 'package:attedance_app/views/main_activity/category_screen.dart';
import 'package:attedance_app/views/main_activity/main_screen.dart';
import 'package:attedance_app/views/main_activity/notice_screen.dart';
import 'package:attedance_app/views/main_activity/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'footer.dart';
import 'package:flutter/services.dart';

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
      onGenerateRoute: (settings) => _generateRoute(settings),
      initialRoute: '/', // 기본 초기 경로
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => _determineInitialScreen());
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
          return snapshot.data!; // 로그인 상태에 맞는 화면 반환
        }
      },
    );
  }

  Future<Widget> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      return MainScreenWithFooter(); // 로그인 시 메인 화면
    } else {
      return LoginScreen(); // 로그인 안 된 경우 로그인 화면
    }
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
    LoginScreen(),
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
