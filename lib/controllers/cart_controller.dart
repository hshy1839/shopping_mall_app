import 'dart:convert';
import 'package:http/http.dart' as http;

class CartController {
  static const String apiUrl = 'http://localhost:8864/api/product/cart'; // 서버 주소

  // 장바구니에 상품 추가하는 함수
  static Future<void> addToCart({
    required String userId,
    required String productId,
    required String productName,
    required String size,
    required int quantity,
    required int price,
  }) async {
    try {
      // API 요청에 사용할 데이터
      final Map<String, dynamic> data = {
        'userId': userId,
        'productId': productId,
        'productName': productName,
        'size': size,
        'quantity': quantity,
        'price': price,
      };

      // POST 요청을 보내기 위한 headers와 body 설정
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      // 요청이 성공했는지 확인
      if (response.statusCode == 200) {
        print('장바구니에 상품이 추가되었습니다.');
      } else {
        print('장바구니 추가 실패: ${response.body}');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
  }
}
