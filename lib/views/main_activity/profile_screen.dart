import 'package:flutter/material.dart';
import '../../controllers/profile_screen_controller.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileScreenController _controller = ProfileScreenController(); // 컨트롤러 인스턴스
  String username = "회원님"; // 초기 사용자 이름
  int orderCount = 0; // 초기 주문 내역 개수
  final int couponCount = 3; // 쿠폰 개수
  final int inquiryCount = 1; // 문의 개수

  int _selectedIndex = 4; // 마이페이지 탭의 인덱스는 4로 설정

  @override
  void initState() {
    super.initState();
    fetchUserDetailsAndOrders(); // 사용자 정보와 주문 내역 가져오기
  }

  Future<void> fetchUserDetailsAndOrders() async {
    try {
      // 사용자 정보 가져오기
      await _controller.fetchUserDetails(context);
      // 주문 내역 가져오기
      await _controller.fetchUserOrders(context);

      setState(() {
        username = _controller.username; // 사용자 이름 업데이트
        orderCount = _controller.orders.length; // 주문 내역 개수 업데이트
      });
    } catch (e) {
      print('데이터를 가져오는 중 오류 발생: $e');
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index; // 탭 변경 시 인덱스를 업데이트
    });
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
                    '$username 님',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            // 쿠폰, 주문내역, 나의 리뷰, 문의 (하나의 사각형으로 묶음)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!), // 테두리 색상
                  borderRadius: BorderRadius.circular(12.0), // 둥근 모서리
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      context,
                      title: '쿠폰',
                      count: couponCount,
                      onTap: () {
                        // 쿠폰 화면으로 이동
                      },
                    ),
                    _buildStatItem(
                      context,
                      title: '주문내역',
                      count: orderCount,
                      onTap: () {
                        Navigator.pushNamed(context, '/orderdetail'); // 주문내역 화면으로 이동
                      },
                    ),
                    _buildStatItem(
                      context,
                      title: '문의',
                      count: inquiryCount,
                      onTap: () {
                        // 문의 화면으로 이동
                      },
                    ),
                  ],
                ),
              ),
            ),
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
                // 개인정보 수정 화면으로 이동
              },
            ),
            Divider(color: Colors.grey[300], thickness: 1.0),
            ListTile(
              title: Text('고객센터', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              leading: Icon(Icons.call, color: Colors.grey), // 고객센터 아이콘
              trailing: Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.grey),
              onTap: () {
                // 고객센터 화면으로 이동
              },
            ),
            Divider(color: Colors.grey[300], thickness: 1.0),
            ListTile(
              title: Text('개인정보처리방침', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              leading: Icon(Icons.security, color: Colors.grey), // 개인정보처리방침 아이콘
              trailing: Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.grey),
              onTap: () {
                // 개인정보 처리방침 화면으로 이동
              },
            ),
            Divider(color: Colors.grey[300], thickness: 1.0),
            ListTile(
              title: Text('서비스 이용약관', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              leading: Icon(Icons.description, color: Colors.grey), // 서비스 이용약관 아이콘
              trailing: Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.grey),
              onTap: () {
                // 서비스 이용약관 화면으로 이동
              },
            ),
            Divider(color: Colors.grey[300], thickness: 1.0),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.logout, color: Colors.grey), // 로그아웃 아이콘 추가
                  SizedBox(width: 10),
                  Text('로그아웃', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.grey),
              onTap: () => _controller.logout(context), // 로그아웃 실행
            ),
          ],
        ),
      ),
    );
  }

  // 통계 항목 빌드 함수
  Widget _buildStatItem(BuildContext context, {required String title, required int count, required Function onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
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
