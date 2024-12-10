import 'package:flutter/material.dart';
import '../../controllers/profile_screen_controller.dart';
import '../../footer.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileScreenController _controller = ProfileScreenController(); // 컨트롤러 인스턴스
  final String username = "회원님"; // 사용자 이름
  final int couponCount = 3; // 쿠폰 개수
  final int orderCount = 5; // 주문내역 개수
  final int reviewCount = 2; // 나의 리뷰 개수
  final int inquiryCount = 1; // 문의 개수

  int _selectedIndex = 4; // 마이페이지 탭의 인덱스는 4로 설정

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
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, color: Colors.white, size: 30.0),
                  ),
                  SizedBox(width: 16.0),
                  Text(
                    '$username',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey[300], thickness: 1.0),
            // 쿠폰, 주문내역, 나의 리뷰, 문의
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                      // 주문내역 화면으로 이동
                    },
                  ),
                  _buildStatItem(
                    context,
                    title: '나의 리뷰',
                    count: reviewCount,
                    onTap: () {
                      // 나의 리뷰 화면으로 이동
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
            Divider(color: Colors.grey[300], thickness: 1.0),
            // 공지사항, 약관 및 정책
            ListTile(
              title: Text('공지사항'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.grey),
              onTap: () {
                // 공지사항 화면으로 이동
              },
            ),
            Divider(color: Colors.grey[300], thickness: 1.0),
            ListTile(
              title: Text('개인정보 수정'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.grey),
              onTap: () {
                // 개인정보 수정 화면으로 이동
              },
            ),
            Divider(color: Colors.grey[300], thickness: 1.0),
            ListTile(
              title: Text('고객센터'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.grey),
              onTap: () {
                // 고객센터 화면으로 이동
              },
            ),
            Divider(color: Colors.grey[300], thickness: 1.0),
            ListTile(
              title: Text('개인정보처리방침'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.grey),
              onTap: () {
                // 개인정보 처리방침 화면으로 이동
              },
            ),
            Divider(color: Colors.grey[300], thickness: 1.0),
            ListTile(
              title: Text('서비스 이용약관'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.grey),
              onTap: () {
                // 서비스 이용약관 화면으로 이동
              },
            ),
            Divider(color: Colors.grey[300], thickness: 1.0),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.logout), // 로그아웃 아이콘 추가
                  SizedBox(width: 10),
                  Text('로그아웃'),
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
