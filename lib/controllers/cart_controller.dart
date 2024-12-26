import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartController {
  static const String apiUrl = 'http://192.168.25.45:8863/api/cart'; // 서버 주소

  // 장바구니에 상품 추가하는 함수
  static Future<http.Response> addToCart({
    required String userId,
    required String productId,
    required String productName,
    required List<Map<String, dynamic>> sizes, // 여러 사이즈를 리스트로 받음
    required int price,
  }) async {
    try {
      // API 요청에 사용할 데이터
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString('token') ?? '';
      final Map<String, dynamic> data = {
        'userId': userId,
        'productId': productId,
        'productName': productName,
        'sizes': sizes, // 사이즈 배열을 전달
        'price': price,
      };
      print('API 요청 데이터: $data');
      // POST 요청을 보내기 위한 headers와 body 설정
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // JWT 토큰을 헤더에 추가
        },
        body: json.encode(data),
      );

      // 요청이 성공했는지 확인
      if (response.statusCode == 200) {
        print('장바구니에 상품이 추가되었습니다.');
      } else {
        print('장바구니 추가 실패: ${response.body}');
      }

      return response;  // response 객체 반환
    } catch (e) {
      print('오류 발생: $e');
      rethrow;  // 오류가 발생하면 다시 던짐
    }
  }
}
