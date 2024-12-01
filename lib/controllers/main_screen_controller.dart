import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MainScreenController extends ChangeNotifier {
  int selectedIndex = 0; // 현재 선택된 탭 인덱스
  final String targetIp = "192.168.25.56"; // 비교할 대상 IP
  List<String> titles = []; // 공지 제목을 저장할 리스트
  List<String> contents = []; // 공지 내용을 저장할 리스트
  List<String> authorNames = []; // 작성자 이름을 저장할 리스트
  List<String> createdAts = []; // 작성일을 저장할 리스트

  void onTabTapped(int index) {
    selectedIndex = index;
    notifyListeners(); // 상태 변경 알림
  }

  Future<void> getNotices() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final currentDate = DateTime.utc(DateTime
        .now()
        .year, DateTime
        .now()
        .month, DateTime
        .now()
        .day).toIso8601String();

    final url = 'http://192.168.25.24:8864/api/users/noticeList/find';
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      notifyListeners();

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        // 서버 응답을 Map<String, dynamic>으로 디코딩
        final Map<String, dynamic> data = jsonDecode(response.body);

        // 만약 응답이 notices라는 키 안에 리스트가 포함되어 있다면
        final List<dynamic> notices = data['notices'];

        // 기존 리스트를 초기화하여 새 데이터를 추가하도록 준비
        titles.clear();
        contents.clear();
        authorNames.clear();
        createdAts.clear();

        // 모든 공지사항을 처리
        if (notices.isNotEmpty) {
          for (var notice in notices) {
            // 각 공지사항의 title, content, authorName, created_at을 가져와 저장
            String noticeTitle = notice['title'] ?? '';
            String noticeContent = notice['content'] ?? ''; // content가 있을 경우 저장
            String noticeAuthorName = notice['authorName'] ?? '';
            String noticeCreatedAt = notice['created_at'] ?? '';

            // 리스트에 값을 추가
            titles.add(noticeTitle);
            contents.add(noticeContent);
            authorNames.add(noticeAuthorName);
            createdAts.add(noticeCreatedAt);

            // 원하는 곳에 공지사항 정보 출력

          }
        }
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      notifyListeners();
    }
  }
}
