import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreenController extends ChangeNotifier {
  String userId = ''; // 사용자 ID 초기화

  Future<void> fetchUserId(BuildContext context) async {
    try {
      // SharedPreferences에서 토큰을 가져옵니다.
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      // token이 비어있으면 예외 처리
      if (token.isEmpty) {
        throw Exception('토큰이 없습니다.');
      }


      // 서버에서 사용자 정보를 가져옵니다.
      final response = await http.get(
        Uri.parse('http://10.56.36.57:8863/api/users/userinfoget'),
        headers: {
          'Authorization': 'Bearer $token', // 헤더에 토큰 추가
        },
      );


      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // 응답에서 user 객체 내부의 _id에 접근
        if (data['user'] != null && data['user']['_id'] != null) {
          userId = data['user']['_id']; // 서버에서 받은 userId를 설정
          notifyListeners(); // 상태 변경을 UI에 반영
        } else {
          throw Exception('유저 ID를 찾을 수 없습니다. ${response.body}');
        }
      } else {
        throw Exception('사용자 정보 가져오기 실패: ${response.body}');
      }
    } catch (e) {
      // 오류 발생 시 처리
      print('오류 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사용자 정보를 가져오는 데 실패했습니다.')),
      );
      throw e; // 오류를 던져서 호출한 곳에서 처리할 수 있도록
    }
  }


  // 로그아웃 로직
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');  // 토큰 제거
    await prefs.setBool('isLoggedIn', false);  // 로그인 상태 제거

    // 로그아웃 후 로그인 화면으로 이동
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
