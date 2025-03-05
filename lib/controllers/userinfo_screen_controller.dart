import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserInfoScreenController {
  String name = "";
  String username = "";
  String phoneNumber = "";
  String address = "";
  String detailAddress = '';


  // 사용자 정보 가져오기
  Future<void> fetchUserInfo(BuildContext context) async {
    try {
      // SharedPreferences에서 토큰 가져오기
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        throw Exception('로그인 정보가 없습니다. 다시 로그인해주세요.');
      }

      // 서버 요청
      final response = await http.get(
        Uri.parse('http://3.36.74.8:8865/api/users/userinfoget'), // 서버 주소에 맞게 수정
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // SharedPreferences에서 가져온 토큰 사용
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true && data['user'] != null) {
          final user = data['user'];
          name = user['name'] ?? '';
          username = user['username'] ?? ''; // username은 읽기 전용
          phoneNumber = user['phoneNumber'] ?? '';
        } else {
          throw Exception('사용자 정보를 불러올 수 없습니다.');
        }
      } else {
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (error) {
      print('사용자 정보 가져오기 오류: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사용자 정보를 가져오는 중 오류가 발생했습니다.')),
      );
    }
  }

  Future<void> fetchShippingInfo(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        throw Exception('로그인 정보가 없습니다. 다시 로그인해주세요.');
      }

      final response = await http.get(
        Uri.parse('http://3.36.74.8:8865/api/shippinginfo'),  // :id는 적절한 사용자 ID로 대체해야 합니다.
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // 'shipping' 필드로 래핑된 데이터에 접근
        final shippingData = data['shipping'];
        if (shippingData != null) {
          address = shippingData['shippingAddress']['address'] ?? '';
          detailAddress = shippingData['shippingAddress']['address2'] ?? '';
        } else {
          throw Exception('배송지 정보가 없습니다.');
        }
      } else {
        throw Exception('배송지 정보를 불러오는데 실패했습니다.');
      }
    } catch (error) {
      print('배송지 정보 가져오기 오류: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('배송지 정보를 가져오는 중 오류가 발생했습니다.')),
      );
    }
  }
  Future<void> updateShippingInfo(BuildContext context, String updatedAddress, String updatedDetailAddress) async {
    try {
      // SharedPreferences에서 토큰 가져오기
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        throw Exception('로그인 정보가 없습니다. 다시 로그인해주세요.');
      }

      // 서버 요청
      final response = await http.put(
        Uri.parse('http://3.36.74.8:8865/api/shipping/update'), // 서버 주소에 맞게 수정
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // SharedPreferences에서 가져온 토큰 사용
        },
        body: json.encode({
          'shippingAddress': { // 서버가 이런 구조를 요구하는지 확인 필요
            'address': updatedAddress.trim(),
            'address2': updatedDetailAddress.trim(),
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          address = updatedAddress;
          detailAddress = updatedDetailAddress;
          print('배송 정보가 성공적으로 업데이트되었습니다.');

        } else {
          print('사용자 정보를 업데이트할 수 없습니다.');
        }
      } else {
        print('서버 오류: ${response.statusCode}');
      }
    } catch (error) {
      print('사용자 정보 업데이트 오류: $error');
       print('사용자 정보를 업데이트하는 중 오류가 발생했습니다.');

    }
  }
  // 사용자 정보 업데이트 (이름과 전화번호만)
  Future<void> updateUserInfo(BuildContext context, String updatedName, String updatedPhoneNumber) async {
    try {
      // SharedPreferences에서 토큰 가져오기
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        throw Exception('로그인 정보가 없습니다. 다시 로그인해주세요.');
      }

      // 서버 요청
      final response = await http.put(
        Uri.parse('http://3.36.74.8:8865/api/users/userinfoUpdate'), // 서버 주소에 맞게 수정
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // SharedPreferences에서 가져온 토큰 사용
        },
        body: json.encode({
          'name': updatedName.trim(), // 이름 업데이트
          'phoneNumber': updatedPhoneNumber.trim(), // 전화번호 업데이트
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          name = updatedName;
          phoneNumber = updatedPhoneNumber;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('사용자 정보가 성공적으로 업데이트되었습니다.')),
          );
        } else {
          throw Exception('사용자 정보를 업데이트할 수 없습니다.');
        }
      } else {
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (error) {
      print('사용자 정보 업데이트 오류: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사용자 정보를 업데이트하는 중 오류가 발생했습니다.')),
      );
    }
  }
}
