import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderCheckScreen extends StatefulWidget {
  const OrderCheckScreen({Key? key}) : super(key: key);



  @override
  _OrderCheckScreenState createState() => _OrderCheckScreenState();


}

class _OrderCheckScreenState extends State<OrderCheckScreen> {
  List<dynamic> orders = [];
  bool isLoading = true;

  int _selectedIndex = 2; // 마이페이지 탭의 인덱스는 4로 설정

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index; // 탭 변경 시 인덱스를 업데이트
    });
  }

  @override
  void initState() {
    super.initState();
    fetchOrderData();
  }

  Future<void> fetchOrderData() async {
    try {
      // 서버 요청 URL
      const String apiUrl = 'http://192.168.203.46:8863/api/orders'; // 서버 URL을 입력하세요.

      // 토큰이 필요하면 SharedPreferences에서 가져옵니다.
      // final prefs = await SharedPreferences.getInstance();
      // final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token', // JWT 토큰이 필요하면 추가
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          orders = jsonDecode(response.body)['orders'];
          isLoading = false;
        });
      } else {
        throw Exception('주문 데이터를 불러오는 데 실패했습니다.');
      }
    } catch (e) {
      print('오류 발생: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주문 내역'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
          ? const Center(child: Text('주문 내역이 없습니다.'))
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _buildOrderCard(order);
        },
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '주문 번호: ${order['_id'] ?? '알 수 없음'}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text('총 금액: ₩${order['totalAmount']}'),
            const SizedBox(height: 8),
            Text('결제 상태: ${order['paymentStatus']}'),
            const SizedBox(height: 8),
            Text('주문 상태: ${order['orderStatus']}'),
            const SizedBox(height: 8),
            Text('상품 정보:'),
            ..._buildOrderItems(order['items']),
            const SizedBox(height: 8),
            Text('배송지: ${order['address'] ?? '없음'}'),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOrderItems(List<dynamic> items) {
    return items.map((item) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          '- ${item['productName']} (₩${item['price']}, 수량: ${item['sizes'].fold(0, (sum, size) => sum + size['quantity'])}개)',
        ),
      );
    }).toList();
  }
}
