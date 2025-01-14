import 'package:flutter/material.dart';
import '../../controllers/profile_screen_controller.dart';
import '../../controllers/product_controller.dart';

class OrderDetailScreen extends StatefulWidget {
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final ProfileScreenController _controller = ProfileScreenController();
  final ProductController _productController = ProductController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders(); // 주문 데이터를 가져옵니다.
  }

  Future<void> fetchOrders() async {
    try {
      await _controller.fetchUserOrders(context); // 주문 데이터를 가져옵니다.
      setState(() {
        isLoading = false; // 로딩 상태를 false로 설정
      });
    } catch (e) {
      print('주문 데이터를 가져오는 중 오류 발생: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String> fetchMainImage(String productId) async {
    try {
      final productInfo = await _productController.getProductInfoById(productId);
      return productInfo['mainImageUrl'] ?? ''; // mainImageUrl 반환
    } catch (e) {
      print('상품 정보를 가져오는 중 오류 발생: $e');
      return ''; // 오류 발생 시 빈 문자열 반환
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '주문내역',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : _controller.orders.isEmpty
          ? Center(
        child: Text(
          '주문 내역이 없습니다.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _controller.orders.length,
          itemBuilder: (context, index) {
            final order = _controller.orders[index];
            return _buildOrderItem(order);
          },
        ),
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> order) {
    final items = order['items'] as List<dynamic>? ?? [];
    final formattedDate = _formatDate(order['createdAt'] ?? '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var item in items)
          FutureBuilder<String>(
            future: fetchMainImage(item['productId'] ?? ''),
            builder: (context, snapshot) {
              final mainImageUrl = snapshot.data ?? '';
              return Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.grey[300]!, width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8.0,
                      spreadRadius: 2.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: mainImageUrl.isNotEmpty
                                ? Image.network(
                              mainImageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            )
                                : Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey,
                              child: Icon(Icons.image, color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['productName'] ?? '상품명 없음',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '사이즈: ${item['sizes']?[0]['size'] ?? '알 수 없음'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  '수량: ${item['sizes']?[0]['quantity'] ?? 0}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '총 ${item['totalPrice'] ?? 0} 원',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Divider(color: Colors.grey[300]),
                      Text(
                        '결제 상태: ${order['paymentStatus'] ?? '알 수 없음'}',
                        style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '주문 상태: ${order['orderStatus'] ?? '알 수 없음'}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '주문일시: $formattedDate',
                        style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        SizedBox(height: 16),
      ],
    );
  }

  String _formatDate(String originalDate) {
    try {
      final dateTime = DateTime.parse(originalDate).toLocal();
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return originalDate; // 날짜 형식이 잘못된 경우 원본 반환
    }
  }
}
