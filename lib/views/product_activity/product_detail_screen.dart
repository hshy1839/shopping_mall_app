import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product; // 상품 데이터를 받을 필드 추가
  final String productId;

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
        title: Text('상품정보'),
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
      body: SingleChildScrollView(
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
                      // 이미지 로드 실패 시 대체 이미지 표시
                      return Image.asset('assets/images/placeholder.png');  // 대체 이미지 경로
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


            if (product['additionalImageUrls'] != null && product['additionalImageUrls'].isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '추가 이미지',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    // 추가 이미지들을 수직으로 나열
                    Column(
                      children: List.generate(
                        product['additionalImageUrls'].split(',').length, // ','로 구분된 URL의 개수만큼 반복
                            (index) {
                          final imageUrl = product['additionalImageUrls'].split(',')[index]; // 각 URL 가져오기
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) {
                                print("이미지 로드 실패: $error");
                                return Image.asset('assets/images/placeholder.png');  // 대체 이미지
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),


            // 옵션 선택 (사이즈, 색상) (하단에서 슬라이드업)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // 구매하기 버튼 클릭 시 하단에서 옵션 선택 모달 띄우기
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return ProductOptionsBottomSheet();
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 100),
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
          ],
        ),
      ),
    );
  }
}

// 옵션을 표시하는 하단 모달 시트
class ProductOptionsBottomSheet extends StatefulWidget {
  @override
  _ProductOptionsBottomSheetState createState() =>
      _ProductOptionsBottomSheetState();
}

class _ProductOptionsBottomSheetState extends State<ProductOptionsBottomSheet> {
  String? selectedSize;
  Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 사이즈 선택
          Text(
            '사이즈 선택',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _SizeOptionButton(size: 'S', isSelected: selectedSize == 'S', onTap: () {
                setState(() {
                  selectedSize = 'S';
                });
              }),
              _SizeOptionButton(size: 'M', isSelected: selectedSize == 'M', onTap: () {
                setState(() {
                  selectedSize = 'M';
                });
              }),
              _SizeOptionButton(size: 'L', isSelected: selectedSize == 'L', onTap: () {
                setState(() {
                  selectedSize = 'L';
                });
              }),
              _SizeOptionButton(size: 'XL', isSelected: selectedSize == 'XL', onTap: () {
                setState(() {
                  selectedSize = 'XL';
                });
              }),
            ],
          ),
          SizedBox(height: 16),

          // 색상 선택
          Text(
            '색상 선택',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _ColorOptionButton(color: Colors.red, isSelected: selectedColor == Colors.red, onTap: () {
                setState(() {
                  selectedColor = Colors.red;
                });
              }),
              _ColorOptionButton(color: Colors.blue, isSelected: selectedColor == Colors.blue, onTap: () {
                setState(() {
                  selectedColor = Colors.blue;
                });
              }),
              _ColorOptionButton(color: Colors.green, isSelected: selectedColor == Colors.green, onTap: () {
                setState(() {
                  selectedColor = Colors.green;
                });
              }),
            ],
          ),
          SizedBox(height: 24),

          // 구매하기 버튼
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (selectedSize != null && selectedColor != null) {
                  // 실제 구매 로직 추가
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('구매가 완료되었습니다!')),
                  );
                  Navigator.pop(context); // 모달 닫기
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('사이즈와 색상을 선택해주세요.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
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
        ],
      ),
    );
  }
}

// 사이즈 옵션 버튼 위젯
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
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
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

// 색상 옵션 버튼 위젯
class _ColorOptionButton extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  _ColorOptionButton({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: Colors.black, width: 2)
              : null,
        ),
      ),
    );
  }
}
