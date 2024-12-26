import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/profile_screen_controller.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product; // 상품 데이터를 받을 필드 추가
  final String productId;
  String userId = '';

  ProductDetailScreen({required this.product, required this.productId}); // 생성자


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
        title: Text('상품정보', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              '앱에서 보기',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 이미지 슬라이더
                SizedBox(
                  height: 300,
                  child: PageView.builder(
                    itemCount: 1, // 상품 메인 이미지 하나만 표시
                    itemBuilder: (context, index) {
                      return Image.network(
                        product['mainImageUrl'] ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/images/placeholder.png'); // 대체 이미지
                        },
                      );
                    },
                  ),
                ),

                // 상품 정보
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['category'] ?? '카테고리', // 카테고리
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        product['name'] ?? '상품 제목', // 상품 제목
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '₩ ${product['price'] ?? '상품 가격'}', // 상품 가격
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

                // 상품 설명
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
                        product['description'] ?? '상품 설명이 없습니다.', // 상품 설명
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
          width: double.infinity, // 버튼을 화면의 가로 너비에 맞게 확장
          child: ElevatedButton(
            onPressed: () {
              // 구매하기 버튼 클릭 시 하단에서 옵션 선택 모달 띄우기
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return ProductOptionsBottomSheet(product: product, productId: productId,); // Pass product data here
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

// 옵션을 표시하는 하단 모달 시트
class ProductOptionsBottomSheet extends StatefulWidget {
  final Map<String, dynamic> product;
  final String productId;

  ProductOptionsBottomSheet({required this.product, required this.productId});

  @override
  _ProductOptionsBottomSheetState createState() =>
      _ProductOptionsBottomSheetState();
}

class _ProductOptionsBottomSheetState extends State<ProductOptionsBottomSheet> {
  Map<String, int> sizeQuantity = {}; // 각 사이즈별 수량 관리
  String userId = ''; // 사용자 ID


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchUserIdAndUpdate(context); // 초기화시 userId 가져오기
    });
  }

  Future<void> fetchUserIdAndUpdate(BuildContext context) async {

    // ProfileScreenController의 fetchUserId 호출 후 userId 업데이트
    ProfileScreenController profileController = ProfileScreenController();
    await profileController.fetchUserId(context); // BuildContext를 전달

    // fetchUserId가 완료된 후 상태 업데이트
    setState(() {
      userId = profileController.userId; // profileController에서 얻은 userId를 현재 페이지의 userId에 저장
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
    String productId = widget.productId;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 사이즈 선택
            Text(
              '사이즈 선택',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _SizeOptionButton(
                  size: 'S',
                  isSelected: sizeQuantity.containsKey('S'),
                  onTap: () {
                    setState(() {
                      if (sizeQuantity.containsKey('S')) {
                        sizeQuantity.remove('S');
                      } else {
                        sizeQuantity['S'] = 1; // 기본 수량 1로 추가
                      }
                    });
                  },
                ),
                _SizeOptionButton(
                  size: 'M',
                  isSelected: sizeQuantity.containsKey('M'),
                  onTap: () {
                    setState(() {
                      if (sizeQuantity.containsKey('M')) {
                        sizeQuantity.remove('M');
                      } else {
                        sizeQuantity['M'] = 1;
                      }
                    });
                  },
                ),
                _SizeOptionButton(
                  size: 'L',
                  isSelected: sizeQuantity.containsKey('L'),
                  onTap: () {
                    setState(() {
                      if (sizeQuantity.containsKey('L')) {
                        sizeQuantity.remove('L');
                      } else {
                        sizeQuantity['L'] = 1;
                      }
                    });
                  },
                ),
                _SizeOptionButton(
                  size: 'XL',
                  isSelected: sizeQuantity.containsKey('XL'),
                  onTap: () {
                    setState(() {
                      if (sizeQuantity.containsKey('XL')) {
                        sizeQuantity.remove('XL');
                      } else {
                        sizeQuantity['XL'] = 1;
                      }
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 12),

            // 선택된 사이즈 정보 표시
            if (sizeQuantity.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: sizeQuantity.keys.map((size) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade200, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${widget.product['name']}',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close, color: Colors.grey),
                                    onPressed: () {
                                      setState(() {
                                        sizeQuantity.remove(size); // 선택된 사이즈 제거
                                      });
                                    },
                                  ),
                                ],
                              ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('사이즈: $size'),
                              Row(
                                children: [
                                  Text('수량:'),
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (sizeQuantity[size]! > 1) {
                                          sizeQuantity[size] = sizeQuantity[size]! - 1;
                                        }
                                      });
                                    },
                                  ),
                                  Text('${sizeQuantity[size]}'),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        sizeQuantity[size] = sizeQuantity[size]! + 1;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                              Text('가격: ₩ ${int.parse(widget.product['price'].toString()) * sizeQuantity[size]!}'),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

            // 총액 표시
            if (sizeQuantity.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  '총 금액 ₩ $totalAmount',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),

            // 구매하기 및 장바구니 버튼
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  // 장바구니 버튼
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        // sizeQuantity가 null인지 체크
                        if (sizeQuantity == null || sizeQuantity.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('상품의 사이즈와 수량을 선택해 주세요.')),
                          );
                          return;
                        }

                        int totalQuantity = 0;
                        List<Map<String, dynamic>> cartItems = [];

                        sizeQuantity.forEach((size, quantity) {
                          totalQuantity += quantity; // 전체 사이즈의 수량 합산

                          // 각 사이즈와 수량에 대해 장바구니 아이템 준비
                          cartItems.add({
                            'size': size ?? '', // null일 경우 기본값으로 빈 문자열
                            'quantity': quantity ?? 0, // quantity가 null일 경우 0으로 처리
                          });
                        });

                        // userId가 null인 경우 처리
                        if (userId == null || userId.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('사용자 ID가 유효하지 않습니다.')),
                          );
                          return;
                        }
                        try {
                          // 각 사이즈와 수량을 포함한 전체 장바구니 아이템을 서버로 전송
                          final response = await CartController.addToCart(
                            userId: userId ?? '', // null일 경우 기본값으로 빈 문자열
                            productId: productId ?? '', // null일 경우 빈 문자열
                            productName: widget.product['name'] ?? '', // null일 경우 빈 문자열
                            sizes: cartItems, // 사이즈와 수량 정보를 포함한 리스트
                            price: int.parse(widget.product['price'].toString()) ?? 0, // 가격
                          );

                          // 응답 코드가 200일 경우 성공 메시지, 아니면 실패 메시지
                          if (response.statusCode == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('장바구니에 상품이 추가되었습니다.')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('장바구니 추가에 실패했습니다. 다시 시도해 주세요.')),
                            );
                          }
                        } catch (e) {
                          // 예외 처리 (서버 연결 실패 등)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('서버와의 연결에 실패했습니다.')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        '장바구니',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),

                  SizedBox(width: 8),
                  // 구매하기 버튼
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // 구매하기 로직
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        '구매하기',
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
  final VoidCallback onTap;

  _SizeOptionButton({
    required this.size,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          size,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}