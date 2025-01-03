import 'dart:async';
import 'package:flutter/material.dart';

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
      print(productInfo);
    } catch (e) {
      print('제품 정보를 불러오는 중 오류 발생: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  int _calculateTotalQuantity() {
    return widget.sizes.fold<int>(0, (sum, item) => sum + (item['quantity'] as int? ?? 0));
  }


  @override
  Widget build(BuildContext context) {
    final totalQuantity = _calculateTotalQuantity();
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
              _buildSectionTitle('주문 상품 총 $totalQuantity개'),
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
              _buildSectionTitle('결제 방법'),
              _buildPaymentOptions(),
              SizedBox(height: 30),
              _buildPayButton(widget.totalAmount, widget.productId, widget.sizes),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
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



  Widget _buildClickableRow(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 16)),
        Text(actionText, style: TextStyle(color: Colors.blue)),
      ],
    );
  }

  Widget _buildCouponRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('쿠폰', style: TextStyle(fontSize: 16)),
        Row(
          children: [
            Text(
              '전체 0장, 적용 가능 0장',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black,
                elevation: 0,
              ),
              child: Text('쿠폰 선택'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceDetails(int totalAmount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '총 결제금액',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '₩ $totalAmount',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildPaymentButton('간편결제'),
        _buildPaymentButton('카드'),
        _buildPaymentButton('현금'),
        _buildPaymentButton('휴대폰'),
      ],
    );
  }

  Widget _buildPaymentButton(String title) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: Text(title),
    );
  }

  Widget _buildPayButton(int totalAmount, String productId, List<dynamic> sizes) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          print('결제하기: 상품ID=$productId, 사이즈=$sizes, 총금액=$totalAmount');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          '₩ $totalAmount 결제하기',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
