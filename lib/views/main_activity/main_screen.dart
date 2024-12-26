import 'package:attedance_app/controllers/product_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../controllers/notice_screen_controller.dart';
import '../../footer.dart';
import '../../header.dart';
import '../product_activity/product_detail_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Map<String, String>> notices = []; // 공지사항 리스트
  List<Map<String, String>> products = [];

  // 공지사항 불러오기
  Future<void> _loadNotices() async {
    NoticeScreenController controller = NoticeScreenController();
    List<Map<String, String>> fetchedNotices = await controller.fetchNotices();
    setState(() {
      notices = fetchedNotices;
    });
  }

  // 상품 불러오기
  Future<void> _loadProducts() async {
    try {
      ProductController controller = ProductController();
      List<Map<String, String>> fetchedProducts = await controller.fetchProducts();
      setState(() {
        products = fetchedProducts;
      });
    } catch (e) {
      // 데이터를 불러오지 못했을 때 콘솔에 오류 메시지 출력
      print('Error loading products: $e');
    }
  }


  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index; // 탭 변경 시 인덱스를 업데이트
    });
  }

  final List<Map<String, String>> categories = [
    {'name': '남성의류', 'icon': 'assets/icons/cloth_man.png'},
    {'name': '여성의류', 'icon': 'assets/icons/cloth_woman.png'},
    {'name': '아우터', 'icon': 'assets/icons/outer.png'},
    {'name': '상의', 'icon': 'assets/icons/top.png'},
    {'name': '하의', 'icon': 'assets/icons/pants.png'},
    {'name': '패션잡화', 'icon': 'assets/icons/cap.png'},
    {'name': '가방', 'icon': 'assets/icons/bag.png'},
    {'name': '신발', 'icon': 'assets/icons/shoes.png'},
  ];

  final List<String> ads = [
    'assets/images/image1.png',
    'assets/images/nike2.png',
    'assets/images/nike3.png',
  ];

  ScrollController _scrollController = ScrollController();
  bool _isHeaderVisible = true;


  @override
  void initState() {
    super.initState();
    _loadNotices();
    _loadProducts();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
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
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Header는 _isHeaderVisible 값에 따라 보이거나 숨깁니다.
          if (_isHeaderVisible) SliverToBoxAdapter(child: Header()),

          // 광고 슬라이더
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0), // ads 섹션 위쪽 여백 추가
              child: CarouselSlider(
                items: ads.map((ad) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 0.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: AssetImage(ad),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 250.0,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {},
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '공지사항',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 12),
                    if (notices.isNotEmpty)
                      Text(
                        notices[0]['title'] ?? '공지사항 제목',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                        ),
                      )
                    else
                      Text(
                        '공지사항을 불러올 수 없습니다.',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                        ),
                      ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/notice');
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                          textStyle: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Text('전체보기'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),


          // 아이콘과 함께 배치된 카테고리
          // 수정된 카테고리 위젯
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(top: 30.0, left: 8.0, right: 8.0),
              child: Wrap(
                alignment: WrapAlignment.center, // 가운데 정렬
                spacing: 10.0, // 아이템 간의 간격
                runSpacing: 16.0, // 행 간의 간격
                children: categories.map((category) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/shoppingscreen',
                        arguments: category['name'], // 카테고리 이름 전달
                      );
                    },
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 40) / 5, // 한 행에 5개 아이템 배치
                      child: Column(
                        children: [
                          Image.asset(
                            category['icon']!,
                            width: 25, // 아이콘 크기 조정
                            height: 25, // 아이콘 크기 조정
                          ),
                          SizedBox(height: 8),
                          Text(
                            category['name']!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center, // 텍스트 중앙 정렬
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),


          // 추천 상품 섹션
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 26.0, horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFFB0B0B0), width: 1.0), // 위 경계선 설정
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0), // 경계선과 텍스트 사이의 간격
                  child: Text(
                    '전체 상품',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),


          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final product = products[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: GestureDetector(
                      onTap: () {
                        // 상품 상세 화면으로 이동, productId와 product를 넘김
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(
                              product: product,
                              productId: product['id'] ?? '',  // productId 전달
                            ),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.white,
                        elevation: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  product['mainImageUrl'] ?? 'assets/images/nike1.png',
                                  fit: BoxFit.cover,
                                  height: 200,
                                  width: double.infinity,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Center(child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(child: Icon(Icons.error));
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                '₩ ${product['price'] ?? '상품 가격'}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                product['category'] ?? '카테고리',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0.0),
                              child: Text(
                                product['name'] ?? '상품 제목',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: products.length,
              ),
            ),
          )


        ],
      ),
    );
  }
}

//<a href="https://kr.freepik.com/search">kmg design 제작 아이콘</a>
//<a href="https://kr.freepik.com/search">Freepik 제작 아이콘</a>
//<a href="https://kr.freepik.com/search">Freepik 제작 아이콘</a>
//<a href="https://kr.freepik.com/search">LAFS 제작 아이콘</a>
//<a href="https://kr.freepik.com/search">Freepik 제작 아이콘</a>
//<a href="https://kr.freepik.com/search">Mihimihi 제작 아이콘</a>
//<a href="https://kr.freepik.com/search">Pixel perfect 제작 아이콘</a>
//<a href="https://kr.freepik.com/search">graphicmall 제작 아이콘</a>