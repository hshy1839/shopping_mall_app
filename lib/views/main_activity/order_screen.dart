import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  final String productId;
  final List<Map<String, dynamic>> sizes;
  final int totalAmount;

  // 생성자 정의
  const OrderScreen({
    Key? key,
    required this.productId,
    required this.sizes,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('전달된 데이터:');
    print('상품 ID: $productId');
    print('사이즈 및 수량: $sizes');
    print('총 금액: $totalAmount');

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('주문 상품 총 ${sizes.length}개'),
              Divider(thickness: 1),
              _buildProductRow(),
              Divider(thickness: 1),
              _buildClickableRow('배송지 정보', '입력하기'),
              Divider(thickness: 1),
              _buildSectionTitle('쿠폰 / 포인트'),
              _buildCouponRow(),
              Divider(thickness: 1),
              _buildPriceDetails(totalAmount),
              Divider(thickness: 1),
              _buildSectionTitle('결제 방법'),
              _buildPaymentOptions(),
              SizedBox(height: 30),
              _buildPayButton(totalAmount, productId, sizes),
            ],
          ),
        ),
      ),
    );
  }
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

  Widget _buildProductRow() {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(Icons.image, size: 50, color: Colors.grey),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '브랜드셀렉',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '아디다스 운동화 - 상세설명',
                style: TextStyle(color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Text('76,900원', style: TextStyle(color: Colors.red)),
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
          // 결제 로직
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

