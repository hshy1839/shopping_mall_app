import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  // 각 카테고리의 항목들
  final List<Map<String, String>> categories = [
    {'name': '아우터', 'image': 'assets/icons/outer.png'},
    {'name': '상의', 'image': 'assets/icons/top.png'},
    {'name': '하의', 'image': 'assets/icons/pants.png'},
  ];

  final List<Map<String, String>> outerItems = [
    {'name': '가디건', 'image': 'assets/images/cardigan.jpg'},
    {'name': '자켓', 'image': 'assets/images/jacket.jpg'},
    {'name': '코트', 'image': 'assets/images/coat.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('카테고리'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      body: Row(
        children: [
          // 사이드바
          Container(
            width: 120,
            color: Colors.grey[200],
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.asset(categories[index]['image']!),
                  title: Text(categories[index]['name']!),
                  onTap: () {
                    // 카테고리 클릭 시 해당 아이템 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryItemsScreen(
                          categoryName: categories[index]['name']!,
                          items: outerItems, // 임시로 outerItems로 설정
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // 카테고리 아이템 목록
          Expanded(
            child: CategoryItemsScreen(
              categoryName: '아우터',
              items: outerItems,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryItemsScreen extends StatelessWidget {
  final String categoryName;
  final List<Map<String, String>> items;

  CategoryItemsScreen({required this.categoryName, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            categoryName,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // 아이템 클릭 시 아이템 상세보기 화면으로 이동
                },
                child: Column(
                  children: [
                    Image.asset(
                      items[index]['image']!,
                      height: 120,
                      width: 120,
                    ),
                    SizedBox(height: 8),
                    Text(
                      items[index]['name']!,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
