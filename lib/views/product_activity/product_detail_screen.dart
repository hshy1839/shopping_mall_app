import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/profile_screen_controller.dart';
import '../../controllers/product_controller.dart';
import '../main_activity/order_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;
  final String productId;

  ProductDetailScreen({required this.product, required this.productId});

  String formatPrice(int price) {
    final formatter = NumberFormat('#,###');
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('상품정보',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 300,
                  child: Image.network(
                    product['mainImageUrl'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/placeholder.png');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['category'] ?? '카테고리',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        product['name'] ?? '상품 제목',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '₩ ${formatPrice(int.parse(product['price'] ?? '0'))}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(),
                // 추가 이미지
                if (product['additionalImageUrls'] != null &&
                    product['additionalImageUrls'].isNotEmpty)
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '추가 이미지',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 15),
                        Column(
                          children: List.generate(
                            product['additionalImageUrls']
                                .split(',')
                                .length, // ','로 구분된 URL의 개수만큼 반복
                                (index) {
                              final imageUrl =
                              product['additionalImageUrls'].split(',')[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset('assets/images/placeholder.png'); // 대체 이미지
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                Divider(),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '상품 설명',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        product['description'] ?? '상품 설명이 없습니다.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return ProductOptionsBottomSheet(
                    product: product,
                    productId: productId,
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              '구매하기',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductOptionsBottomSheet extends StatefulWidget {
  final Map<String, dynamic> product;
  final String productId;
  ProductOptionsBottomSheet({required this.product, required this.productId});

  @override
  _ProductOptionsBottomSheetState createState() =>
      _ProductOptionsBottomSheetState();
}
String formatPrice(int price) {
  final formatter = NumberFormat('#,###');
  return formatter.format(price);
}

class _ProductOptionsBottomSheetState extends State<ProductOptionsBottomSheet> {
  Map<String, int> sizeQuantity = {};
  Map<String, int> sizeStock = {}; // 서버에서 가져온 사이즈 재고
  String userId = '';


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchProductInfo(); // 상품 정보 가져오기
      await fetchUserId(); // 사용자 ID 가져오기
    });
  }

  Future<void> fetchProductInfo() async {
    final productController = ProductController();
    final productInfo =
    await productController.getProductInfoById(widget.productId);

    setState(() {
      sizeStock = Map<String, int>.from(productInfo['sizeStock'] ?? {});
    });
  }

  Future<void> fetchUserId() async {
    final profileController = ProfileScreenController();
    await profileController.fetchUserId(context);
    setState(() {
      userId = profileController.userId;
    });
  }

  int get totalAmount {
    int sum = 0;
    sizeQuantity.forEach((size, qty) {
      sum += int.parse(widget.product['price'].toString()) * qty;
    });
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    // 재고가 있는 사이즈만 필터링
    final availableSizes = sizeStock.entries.where((entry) => entry.value > 0).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '사이즈 선택',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 16),
            if (availableSizes.isEmpty)
              Center(
                child: Text(
                  '품절된 상품입니다.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: availableSizes.map((entry) {
                  final size = entry.key;

                  return _SizeOptionButton(
                    size: size,
                    isSelected: sizeQuantity.containsKey(size),
                    isDisabled: false, // 재고가 있는 경우만 표시
                    onTap: () {
                      setState(() {
                        if (sizeQuantity.containsKey(size)) {
                          sizeQuantity.remove(size);
                        } else {
                          sizeQuantity[size] = 1; // 기본 수량 1로 설정
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            if (sizeQuantity.isNotEmpty)
              Expanded(
                child: ListView(
                  children: sizeQuantity.keys.map((size) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${widget.product['name']} ($size)',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.grey),
                                  onPressed: () {
                                    setState(() {
                                      sizeQuantity.remove(size);
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '가격: ₩ ${formatPrice(int.parse(widget.product['price'].toString()) * sizeQuantity[size]!)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (sizeQuantity[size]! > 1) {
                                            sizeQuantity[size] = sizeQuantity[size]! - 1;
                                          }
                                        });
                                      },
                                      icon: Icon(Icons.remove_circle_outline),
                                    ),
                                    Text(
                                      '${sizeQuantity[size]}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (sizeQuantity[size]! < sizeStock[size]!) {
                                            sizeQuantity[size] = sizeQuantity[size]! + 1;
                                          }
                                        });
                                      },
                                      icon: Icon(Icons.add_circle_outline),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            if (sizeQuantity.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  '총 금액 ₩ ${formatPrice(totalAmount)}',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (sizeQuantity.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('사이즈와 수량을 선택해주세요.')),
                          );
                          return;
                        }

                        List<Map<String, dynamic>> selectedSizes = sizeQuantity.entries
                            .map((entry) => {
                          'size': entry.key,
                          'quantity': entry.value,
                        })
                            .toList();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderScreen(
                              productId: widget.productId,
                              sizes: selectedSizes,
                              totalAmount: totalAmount,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        '결제하기',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class _SizeOptionButton extends StatelessWidget {
  final String size;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  _SizeOptionButton({
    required this.size,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        margin: EdgeInsets.only(right: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isDisabled
              ? Colors.grey.shade300
              : isSelected
              ? Colors.blue
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          size,
          style: TextStyle(
            color: isDisabled
                ? Colors.grey
                : isSelected
                ? Colors.white
                : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
