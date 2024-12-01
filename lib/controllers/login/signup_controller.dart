import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../login_activity/login.dart';

class SignupController extends ChangeNotifier {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final companyController = TextEditingController();
  final positionController = TextEditingController();
  final teamController = TextEditingController();

  String? errorMessage;

  Future<void> submitData(BuildContext context) async {
    // 비밀번호와 비밀번호 확인 비교
    if (passwordController.text != confirmPasswordController.text) {
      errorMessage = '비밀번호와 비밀번호 확인이 일치하지 않습니다.';
      notifyListeners();
      return;
    }

    // 필수 입력 필드 체크
    if (companyController.text.isEmpty || positionController.text.isEmpty || teamController.text.isEmpty) {
      errorMessage = '회사명, 직급, 팀명은 필수 입력 사항입니다.';
      notifyListeners();
      return;
    }

    final response = await http.post(
      Uri.parse('http://192.168.25.24:8864/api/users/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, Object>{
        'name': nameController.text,
        'username': usernameController.text,
        'password': passwordController.text,
        'phoneNumber': phoneNumberController.text,
        'is_active': false,
        'company': companyController.text,
        'position': positionController.text,
        'team': teamController.text,
      }),
    );

    // 서버 응답 처리
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 성공')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      final responseData = jsonDecode(response.body);
      errorMessage = responseData['message'] ?? '회원가입 실패';
      notifyListeners();
    }
  }


  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneNumberController.dispose();
    companyController.dispose();
    positionController.dispose();
    teamController.dispose();
    super.dispose();
  }
}
