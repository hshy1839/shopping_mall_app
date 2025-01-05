import 'dart:async';
import 'package:flutter/material.dart';
import '../../controllers/order_screen_controller.dart'; // OrderScreenController를 import
import '../../controllers/product_controller.dart';

class OrderScreen extends StatefulWidget {
  final String productId;
  final List<Map<String, dynamic>> sizes;
  final int totalAmount;

  const OrderScreen({
    Key? key,
    required this.productId,
    required this.sizes,
    required this.totalAmount,
  }) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Map<String, dynamic>? productInfo;
  bool isLoading = true;
  String? address; // 배송지 정보

  @override
  void initState() {
    super.initState();
    fetchProductInfo();
  }

  Future<void> fetchProductInfo() async {
    final productsController = ProductController();
    try {
      final info = await productsController.getProductInfoById(widget.productId);
      setState(() {
        productInfo = info;
        isLoading = false;
      });
    } catch (e) {
      print('제품 정보를 불러오는 중 오류 발생: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleOrderSubmission() async {
    if (address == null || address!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('배송지를 입력해주세요.')),
      );
      return;
    }

    try {
      // 주문 데이터 생성
      final List<Map<String, dynamic>> items = [
        {
          'productId': widget.productId,
          'productName': productInfo?['name'] ?? '제품명 없음',
          'sizes': widget.sizes,
          'price': productInfo?['price'] ?? 0,
          'totalPrice': widget.totalAmount,
        }
      ];

      final List<Map<String, dynamic>> account = [
        {
          'accountName': '홍길동', // 예시 데이터
          'accountNumber': '123-456-7890', // 예시 데이터
        }
      ];

      // 서버로 데이터 전송
      final response = await OrderScreenController.addToOrder(
        account: account,
        items: items,
        totalAmount: widget.totalAmount.toDouble(),
        address: address!,
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('주문이 성공적으로 완료되었습니다.')),
        );
        Navigator.pop(context); // 주문 성공 시 이전 화면으로 돌아가기
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('주문 실패: ${response.body}')),
        );
      }
    } catch (e) {
      print('주문 중 오류 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('주문 중 오류가 발생했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '주문 화면',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : productInfo == null
          ? Center(child: Text('제품 정보를 불러올 수 없습니다.'))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('주문 상품 '),
              Divider(thickness: 1),
              _buildProductRow(productInfo!),
              Divider(thickness: 1),
              _buildClickableRow('배송지 정보', '입력하기'),
              Divider(thickness: 1),
              _buildSectionTitle('쿠폰 / 포인트'),
              _buildCouponRow(),
              Divider(thickness: 1),
              _buildPriceDetails(widget.totalAmount),
              Divider(thickness: 1),
              SizedBox(height: 30),
              _buildPayButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleOrderSubmission, // 결제 버튼 클릭 시 _handleOrderSubmission 호출
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          '₩ ${widget.totalAmount} 결제하기',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildClickableRow(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 16)),
        GestureDetector(
          onTap: () {
            _showAddressInputSheet(context);
          },
          child: Text(actionText, style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

  void _showAddressInputSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(labelText: '배송지'),
                onChanged: (value) {
                  setState(() {
                    address = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('배송지 저장', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildProductRow(Map<String, dynamic> productInfo) {
    // 상품의 총 수량 계산
    int totalQuantity = widget.sizes.fold<int>(0, (sum, item) => sum + (item['quantity'] as int? ?? 0));

    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(5),
          ),
          child: productInfo['mainImageUrl'] != null
              ? Image.network(
            productInfo['mainImageUrl'],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error, color: Colors.grey);
            },
          )
              : Icon(Icons.image, size: 50, color: Colors.grey),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productInfo['category'] ?? '설명 없음',
                style: TextStyle(color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                productInfo['name'] ?? '제품명 없음',
                style: TextStyle(color: Colors.black),
              ),

              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '₩ ${productInfo['price'] ?? '0'}',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '수량: $totalQuantity개',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCouponRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('쿠폰: 없음'),
      ],
    );
  }

  Widget _buildPriceDetails(int totalAmount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('총 금액:'),
        Text('₩ $totalAmount'),
      ],
    );
  }
}
