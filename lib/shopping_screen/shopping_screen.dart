import 'package:flutter/material.dart';

class ShoppingScreen extends StatelessWidget {
  final String categoryName; // 카테고리 이름

  ShoppingScreen({required this.categoryName}); // 생성자로 카테고리 이름을 받음

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          categoryName, // 전달받은 카테고리 이름 사용
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildCategorySection(context),
          const Divider(),
          _buildFilterSection(),
          const Divider(),
          _buildRecommendedSection(),
        ],
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    final categories = [
      "아우터",
      "상의",
      "팬츠",
      "원피스/세트",
      "스커트",
      "언더웨어",
      "조끼/베스트",
      "올인원",
      "바지/레깅스",
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Wrap(
        spacing: 16.0, // 각 아이템 간의 가로 간격
        runSpacing: 16.0, // 각 줄 간의 세로 간격
        children: categories.map((category) {
          return SizedBox(
            width: MediaQuery.of(context).size.width / 5 - 20, // 한 줄에 5개씩
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.image, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  category,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFilterSection() {
    final filters = [
      "추천순",
      "가격",
      "색상",
      "카테고리",
      "소재",
      "핏",
      "스타일",
      "계절",
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: filters.map((filter) {
          return ChoiceChip(
            label: Text(filter),
            selected: false,
            onSelected: (selected) {},
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecommendedSection() {
    final products = [
      {"name": "상품1", "price": "₩34,200", "image": "assets/images/nike2.png"},
      {"name": "상품2", "price": "₩30,300", "image": "assets/images/nike2.png"},
      {"name": "상품3", "price": "₩15,900", "image": "assets/images/nike2.png"},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "회원님을 위한 추천 상품",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product["name"]!,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    product["price"]!,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
