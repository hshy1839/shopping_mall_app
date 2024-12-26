import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../footer.dart';
import '../../header.dart';

class ProductController {
  Future<List<Map<String, String>>> fetchProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? ''; // 저장된 토큰 불러오기

      if (token.isEmpty) {
        throw Exception('토큰이 없습니다. 로그인 상태를 확인하세요.');
      }

      final response = await http.get(
        Uri.parse('http://192.168.25.45:8863/api/products/allProduct'),
        headers: {
          'Authorization': 'Bearer $token', // Bearer 토큰 추가
        },
      );

      // 응답 데이터 출력
      print('API 응답: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);

        // 디코드된 데이터 출력
        print('디코드된 응답: $decodedResponse');

        if (decodedResponse is Map<String, dynamic> && decodedResponse['products'] is List<dynamic>) {
          final List<dynamic> data = decodedResponse['products'];
          const serverUrl = 'http://192.168.25.45:8863'; // 서버 URL 설정

          return data.reversed.map((item) {
            final originalDate = item['createdAt']?.toString() ?? '';
            final formattedDate = _formatDate(originalDate);

            // category 값을 main > sub 형식으로 변환
            final category = item['category'] != null && item['category'] is Map<String, dynamic>
                ? '${item['category']['main'] ?? ''} > ${item['category']['sub'] ?? ''}'
                : '';

            // mainImage 값 처리
            final mainImageUrl = item['mainImage'] != null && item['mainImage'] is List<dynamic>
                ? (item['mainImage'] as List<dynamic>).isNotEmpty
                ? '$serverUrl${item['mainImage'][0]}' // 서버 URL 추가
                : ''  // 비어있으면 빈 문자열 반환
                : '';  // mainImage가 null이거나 List가 아니면 빈 문자열 반환

            // additionalImages 값 처리: 여러 개의 이미지 URL을 배열로 저장
            final additionalImageUrls = item['additionalImages'] != null && item['additionalImages'] is List<dynamic>
                ? (item['additionalImages'] as List<dynamic>).map((image) => '$serverUrl$image').toList() // 서버 URL 추가
                : [];  // 빈 배열 반환

            // 상품 ID 추가
            final productId = item['_id']?.toString() ?? '';

            return {
              'id': productId,  // id 추가
              'name': item['name']?.toString() ?? '',
              'price': item['price']?.toString() ?? '',
              'category': category,
              'mainImageUrl': mainImageUrl, // mainImageUrl 추가
              'description' : item['description']?.toString() ?? '',
              'additionalImageUrls': additionalImageUrls.join(','), // 추가 이미지들을 ','로 구분하여 저장
              'created_at': formattedDate,
            };
          }).toList();
        } else {
          throw Exception('응답 데이터 형식이 올바르지 않습니다.');
        }
      } else {
        print('API 호출 실패: ${response.statusCode}, ${response.body}');
        return [];
      }

    } catch (error) {
      print('공지사항 조회 중 오류 발생: $error');
      return [];
    }
  }

  // 날짜 포맷 함수
  String _formatDate(String originalDate) {
    try {
      final dateTime = DateTime.parse(originalDate);
      return DateFormat('yyyy년 MM월 dd일').format(dateTime); // 원하는 형식으로 포맷팅
    } catch (e) {
      return originalDate; // 날짜 형식이 잘못된 경우 원본 반환
    }
  }
}
