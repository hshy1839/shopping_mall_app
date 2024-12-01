import 'package:attedance_app/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'footer.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<String> categories = ['추천', '베스트', '신상품', '의류', '뷰티'];
  final List<Map<String, String>> products = [
    {'image': 'https://via.placeholder.com/150', 'name': '상품 1', 'price': '₩20,000'},
    {'image': 'https://via.placeholder.com/150', 'name': '상품 2', 'price': '₩30,000'},
    {'image': 'https://via.placeholder.com/150', 'name': '상품 3', 'price': '₩15,000'},
    {'image': 'https://via.placeholder.com/150', 'name': '상품 4', 'price': '₩25,000'},
    {'image': 'https://via.placeholder.com/150', 'name': '상품 5', 'price': '₩25,000'},
    {'image': 'https://via.placeholder.com/150', 'name': '상품 6', 'price': '₩25,000'},
    {'image': 'https://via.placeholder.com/150', 'name': '상품 7', 'price': '₩25,000'},
    {'image': 'https://via.placeholder.com/150', 'name': '상품 8', 'price': '₩25,000'},
  ];

  ScrollController _scrollController = ScrollController();
  bool _isHeaderVisible = true;

  void _onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // 스크롤 리스너를 추가하여 스크롤 상태를 감지
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  // 스크롤 상태를 감지하는 리스너 함수
  void _scrollListener() {
    // 스크롤 방향을 감지하여 헤더 표시 여부를 결정
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_isHeaderVisible) {
        setState(() {
          _isHeaderVisible = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_isHeaderVisible) {
        setState(() {
          _isHeaderVisible = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header는 _isHeaderVisible 값에 따라 보이거나 숨깁니다.
          if (_isHeaderVisible) Header(),

          // 카테고리 탭
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    label: Text(categories[index]),
                    selected: selectedIndex == index,
                    onSelected: (selected) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          // 상품 목록
          Expanded(
            child: NotificationListener<ScrollUpdateNotification>(
              onNotification: (notification) {
                if (notification.scrollDelta! < 0) {
                  // 사용자가 위로 스크롤 시
                  if (!_isHeaderVisible) {
                    setState(() {
                      _isHeaderVisible = true;
                    });
                  }
                } else if (notification.scrollDelta! > 0) {
                  // 사용자가 아래로 스크롤 시
                  if (_isHeaderVisible) {
                    setState(() {
                      _isHeaderVisible = false;
                    });
                  }
                }
                return true;
              },
              child: GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.75,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                            child: Image.network(
                              product['image']!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product['name']!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            product['price']!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Footer(
        selectedIndex: selectedIndex,
        onTabTapped: _onTabTapped,
      ),
    );
  }
}
