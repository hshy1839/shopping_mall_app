import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../views/login_activity/login.dart';

class SignupController extends ChangeNotifier {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final detailAddressController = TextEditingController();


  String errorMessage = '';

  Future<void> submitData(BuildContext context) async {
    if (nameController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        detailAddressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('칸을 모두 채워주세요'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(usernameController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('아이디는 영문자와 숫자조합으로만 가능합니다.')),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      errorMessage = '비밀번호와 비밀번호 확인이 일치하지 않습니다.';
      notifyListeners();
      return;
    }

    final response = await http.post(
      Uri.parse('http://3.36.74.8:8865/api/users/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, Object>{
        'name': nameController.text,
        'username': usernameController.text,
        'password': passwordController.text,
        'phoneNumber': phoneController.text,
        'is_active': false,
      }),
    );

    if (response.statusCode == 200) {
      final userId = jsonDecode(response.body)['id'];
      final token = jsonDecode(response.body)['token']; // 서버로부터 받은 토큰

      // 배송지 정보를 서버에 전송
      final shippingAddress = {
        'address': addressController.text,
        'address2': detailAddressController.text
      };

      var shippingResponse = await addOrUpdateShipping(token, shippingAddress);

      if (shippingResponse == 200 || shippingResponse == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 성공')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        // 배송지 정보 등록 실패
        errorMessage = '배송지 정보 등록 실패';
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('배송지 정보 등록 실패')),
        );
      }
    } else {
      // 회원가입 실패 처리
      final responseData = jsonDecode(response.body);
      errorMessage = responseData['message']; // 서버로부터 구체적인 오류 메시지 받기

      // 서버 메시지에 따라 사용자 친화적인 메시지로 변경
      if (errorMessage == '이미 사용 중인 username입니다.') {
        errorMessage = '이미 사용 중인 아이디입니다.';
      } else if (errorMessage == '이미 사용 중인 phoneNumber입니다.') {
        errorMessage = '이미 사용 중인 전화번호입니다.';
      }

      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }

  }


  Future<int> addOrUpdateShipping(String token, Map<String, dynamic> shippingAddress) async {
    var url = Uri.parse('http://3.36.74.8:8865/api/shipping');
    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'shippingAddress': shippingAddress}),
      );

      return response.statusCode;  // 상태 코드 반환
    } catch (e) {
      print('배송지 정보 저장 에러: $e');
      return 500; // 서버 에러 가정
    }
  }


  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
