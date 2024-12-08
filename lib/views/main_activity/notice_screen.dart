import 'package:flutter/material.dart';

class NoticeScreen extends StatelessWidget {
  final List<Map<String, String>> notices = [
    {
      'title': '이번 주 특별 할인 이벤트!',
      'content': '이번 주는 특별 할인 주간입니다! 많은 관심 부탁드립니다.',
      'date': '2024-12-01',
    },
    {
      'title': '새로운 기능 추가!',
      'content': '앱에 새로운 운동 기록 기능이 추가되었습니다. 확인해 보세요.',
      'date': '2024-12-02',
    },
    {
      'title': '시스템 점검 안내',
      'content': '내일 오전 10시부터 12시까지 시스템 점검이 진행됩니다.',
      'date': '2024-12-03',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '공지사항',
          style: TextStyle(
            color: Colors.black, // 텍스트 색상 검정
            fontWeight: FontWeight.bold, // 텍스트 Bold
            fontSize: 18.0, // 텍스트 크기
          ),
        ),
        centerTitle: true, // 텍스트를 중앙에 배치
        backgroundColor: Colors.white, // AppBar 배경 흰색
        elevation: 0.5, // 그림자 효과
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // 뒤로가기 아이콘
          onPressed: () {
            Navigator.pop(context); // 이전 화면으로 이동
          },
        ),
      ),
      body: Container(
        color: Colors.white, // 배경 흰색
        child: ListView.builder(
          itemCount: notices.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  title: Text(
                    notices[index]['title']!,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    notices[index]['date']!,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),
                  ),
                  onTap: () {
                    // 공지 클릭 시 동작
                  },
                ),
                Divider(
                  color: Colors.grey[300],
                  thickness: 1.0,
                  height: 1.0,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
