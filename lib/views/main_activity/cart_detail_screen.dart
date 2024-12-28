import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/profile_screen_controller.dart';

class CartDetailScreen extends StatefulWidget {
  @override
  _CartDetailScreenState createState() => _CartDetailScreenState();
}

class _CartDetailScreenState extends State<CartDetailScreen> {
  final CartController cartController = CartController();
  List<Map<String, dynamic>> cartItems = []; // 서버에서 받은 데이터를 저장할 리스트

  @override
  void initState() {
    super.initState();
    _loadCartData();
  }

  // 장바구니 데이터 로드
  Future<void> _loadCartData() async {
    try {
      // ProfileScreenController에서 userId와 token을 가져옴
      final profileController = ProfileScreenController();
      await profileController.fetchUserId(context); // userId를 fetchUserId로 가져옴

      final String userId = profileController.userId;
      final String token = await _getToken(); // token을 SharedPreferences에서 불러옴

      if (userId.isEmpty || token.isEmpty) {
        throw Exception('로그인 정보가 부족합니다.');
      }

      // CartController의 fetchCartData 호출
      final items = await CartController().fetchCartData(userId, token);

      // mounted 확인 후 setState 호출
      if (mounted) {
        setState(() {
          cartItems = items;
        });
      }
    } catch (e) {
      showErrorDialog(e.toString());
    }
  }

  // token을 SharedPreferences에서 가져오는 함수
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  // 오류 다이얼로그 표시
  void showErrorDialog(String message) {
    print(message);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('오류'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  // 총 금액 계산
  int getTotalPrice() {
    return cartItems.fold(0, (total, item) {
      // totalPrice를 int로 변환
      return total + (item['totalPrice'] as num).toInt();
    });
  }

  // 선택된 아이템 삭제
  void _deleteSelectedItems() {
    setState(() {
      cartItems.removeWhere((item) => item['isSelected'] == true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('장바구니'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteSelectedItems,
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? Center(child: CircularProgressIndicator()) // 데이터가 비었을 경우 로딩 표시
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: Checkbox(
                    value: item['isSelected'] ?? false,
                    onChanged: (value) {
                      setState(() {
                        item['isSelected'] = value;
                      });
                    },
                  ),
                  title: Text(item['productName']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item['sizes'] is List) ...[
                        // 'sizes'가 List일 때
                        for (var size in item['sizes'])
                          Text("${size['size']} | 수량: ${size['quantity']}"),
                      ] else if (item['sizes'] is Map) ...[
                        // 'sizes'가 Map일 때
                        Text("Size: ${item['sizes']['size']} | 수량: ${item['sizes']['quantity']}"),
                      ] else ...[
                        // sizes가 예상하지 못한 형태일 때
                        Text("사이즈 정보 없음"),
                      ]
                    ],
                  ),
                  trailing: Text("${item['totalPrice']} 원"),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPriceRow("총 상품 금액", "${getTotalPrice()} 원"),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // 주문하기 버튼 동작
                  },
                  child: Text("주문하기"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 가격 정보를 표시하는 행 생성
  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value),
      ],
    );
  }
}
