import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/profile_screen_controller.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileScreenController _controller = ProfileScreenController(); // 프로필 컨트롤러 인스턴스

  String username = "회원님"; // 초기 사용자 이름
  String name = "회원"; // 초기 이름
  int orderCount = 0; // 초기 주문 내역 개수
  int cartCount = 0; // 장바구니 항목 개수
  int inquiryCount = 0; // 문의 개수 초기화

  @override
  void initState() {
    super.initState();
    fetchUserDetails(); // 사용자 정보 가져오기
    fetchUserOrders(); // 주문 내역 가져오기
  }

  Future<void> fetchUserDetails() async {
    try {
      // 사용자 정보 가져오기
      await _controller.fetchUserDetails(context);

      setState(() {
        username = _controller.username; // 사용자 이름 업데이트
        name = _controller.name;
      });
    } catch (e) {
      print('사용자 정보를 가져오는 중 오류 발생: $e');
    }
  }

  Future<void> fetchUserOrders() async {
    try {
      // 주문 내역 가져오기
      await _controller.fetchUserOrders(context);

      setState(() {
        orderCount = _controller.orders.length; // 주문 내역 개수 업데이트
      });
    } catch (e) {
      print('주문 내역을 가져오는 중 오류 발생: $e');
    }
  }



  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '마이페이지',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            // 회원 이름 섹션
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 왼쪽 정렬
                children: [
                  Text(
                    '안녕하세요,',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    '$name 님',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // 장바구니, 주문내역, 문의 (하나의 사각형으로 묶음)

            SizedBox(height: 20.0),
            Divider(color: Colors.grey[300], thickness: 1.0),

            // 공지사항, 약관 및 정책
            ListTile(
              title: Text('공지사항', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              leading: Icon(Icons.notifications, color: Colors.grey), // 공지사항 아이콘
              trailing: Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.grey),
              onTap: () {
                Navigator.pushNamed(context, '/notice');
              },
            ),
            Divider(color: Colors.grey[300], thickness: 1.0),

            ListTile(
              title: Text('개인정보 수정', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              leading: Icon(Icons.person_outline, color: Colors.grey), // 개인정보 수정 아이콘
              trailing: Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.grey),
              onTap: () {
                Navigator.pushNamed(context, '/userinfo'); // 개인정보 수정 화면으로 이동
              },
            ),
            Divider(color: Colors.grey[300], thickness: 1.0),
            ListTile(
              title: Text('결제 계좌 정보', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              leading: Icon(Icons.call, color: Colors.grey), // 고객센터 아이콘
              trailing: Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.grey),
              onTap: () {
                // 고객센터 화면으로 이동
                Navigator.pushNamed(context, '/accountInfo');
              },
            ),
            Divider(color: Colors.grey[300], thickness: 1.0),
            ListTile(
              title: Text('로그아웃', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              leading: Icon(Icons.logout, color: Colors.grey),
              trailing: Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.grey),
              onTap: () => _controller.logout(context), // 로그아웃 함수 호출
            ),
          ],
        ),
      ),
    );
  }

  // 통계 항목 빌드 함수
  Widget _buildStatItem(BuildContext context, {required String title, required int count, required Function? onTap}) {
    return GestureDetector(
      onTap: onTap != null ? () => onTap() : null, // onTap이 null이면 아무 동작도 하지 않음
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 8.0),
          Text(
            '$count',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
