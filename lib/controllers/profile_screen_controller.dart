import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreenController {
  // 로그아웃 로직
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');  // 토큰 제거
    await prefs.setBool('isLoggedIn', false);  // 로그인 상태 제거

    // 로그아웃 후 로그인 화면으로 이동
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
