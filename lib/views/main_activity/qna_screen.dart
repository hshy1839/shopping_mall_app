import 'package:flutter/material.dart';
import '../../controllers/qna_controller.dart'; // QnaController 경로에 맞게 수정
import 'notice_detail_screen.dart';

class QnaScreen extends StatefulWidget {
  @override
  _QnaScreenState createState() => _QnaScreenState();
}

class _QnaScreenState extends State<QnaScreen> {
  List<Map<String, dynamic>> qnaQuestions = []; // QnA 데이터를 저장할 리스트
  final QnaController _controller = QnaController(); // QnA 컨트롤러 인스턴스
  bool _isLoading = true; // 로딩 상태 관리

  @override
  void initState() {
    super.initState();
    _fetchQnaQuestions();
  }

  Future<void> _fetchQnaQuestions() async {
    try {
      final fetchedQuestions = await _controller.getQnaInfo(); // 토큰 기반 QnA 조회
      setState(() {
        qnaQuestions = fetchedQuestions;
        _isLoading = false; // 로딩 완료
      });
    } catch (e) {
      print('QnA 정보 조회 중 오류: $e');
      setState(() {
        _isLoading = false; // 오류 발생 시에도 로딩 상태 해제
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '1:1 문의',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // 로딩 중일 때 표시
          : qnaQuestions.isEmpty
          ? Center(child: Text('문의 내역이 없습니다.')) // 데이터가 없을 때 표시
          : ListView.builder(
        itemCount: qnaQuestions.length,
        itemBuilder: (context, index) {
          final question = qnaQuestions[index];
          final hasAnswer = (question['answer'] != null && question['answer'].isNotEmpty);

          return Column(
            children: [
              ListTile(
                title: Text(
                  question['title'] ?? '제목 없음',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  question['createdAt'] ?? '날짜 없음',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
                trailing: Text(
                  hasAnswer ? '답변 완료' : '답변 전',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: hasAnswer ? Colors.green : Colors.red,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoticeDetailScreen(
                        title: question['title'] ?? '제목 없음',
                        date: question['createdAt'] ?? '날짜 없음',
                        content: question['body'] ?? '내용 없음',
                      ),
                    ),
                  );
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/qnaCreate');
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
