import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final Function(int) onTabTapped;
  final int selectedIndex; // 현재 선택된 탭의 인덱스 추가

  Footer({required this.onTabTapped, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white, // Footer 배경 색상 설정
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 홈 탭
          _buildFooterItem(
            context,
            icon: Icons.home_outlined,
            label: '홈',
            index: 0,
          ),
          // 1:1 문의 탭

          _buildFooterItem(
            context,
            icon: Icons.menu_outlined,
            label: '카테고리',
            index: 1,
          ),
          // 구매내역 탭
          _buildFooterItem(
            context,
            icon: Icons.receipt_long_outlined,
            label: '주문내역',
            index: 2,
          ),
          // 마이페이지 탭
          _buildFooterItem(
            context,
            icon: Icons.person_outline,
            label: '마이페이지',
            index: 3,
          ),
        ],
      ),
    );
  }

  // Footer 아이템 빌드 함수
  Widget _buildFooterItem(BuildContext context, {required IconData icon, required String label, required int index}) {
    return GestureDetector(
      onTap: () => onTabTapped(index), // 탭을 눌렀을 때 해당 인덱스 호출
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: selectedIndex == index ? Colors.black : Colors.grey, // 선택된 경우 검은색
          ),
          SizedBox(height: 4), // 아이콘과 텍스트 사이 간격
          Text(
            label,
            style: TextStyle(
              color: selectedIndex == index ? Colors.black : Colors.grey,
              fontSize: 12, // 텍스트 크기
            ),
          ),
        ],
      ),
    );
  }
}
