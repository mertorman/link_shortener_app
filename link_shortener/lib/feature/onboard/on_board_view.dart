import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:link_shortener/feature/onboard/on_board_model.dart';
import 'package:link_shortener/feature/views/homepage.dart';
import 'package:link_shortener/product/padding/page_padding.dart';

class OnBoardView extends StatefulWidget {
  const OnBoardView({Key? key}) : super(key: key);

  @override
  State<OnBoardView> createState() => _OnBoardViewState();
}

class _OnBoardViewState extends State<OnBoardView>
    with SingleTickerProviderStateMixin {
  final String _next = 'Next';
  final String _start = 'Start';
  final String _skipTile = 'Skip';

  late final TabController _tabController;
  int _selectedIndex = 0;
  bool get _startStatus => _selectedIndex == pageController.page?.toInt();
  bool get _isFirstPage => _selectedIndex == 0;
  bool get _isLastPage =>
      OnBoardModels.onBoardItems.length - 1 == _selectedIndex;

  PageController pageController = PageController();

  @override
  void initState() {
    _tabController =
        TabController(length: OnBoardModels.onBoardItems.length, vsync: this);
    super.initState();
  }

  void _incrementAndChange([int? value]) {
    if (_isLastPage && value == null) {
      return;
    }
    _incrementSelectedPage(value);
    _changeIndicator(_selectedIndex);
  }

  void _incrementSelectedPage([int? value]) {
    setState(() {
      if (value != null) {
        _selectedIndex = value;
      } else {
        _selectedIndex++;
      }
    });
  }

  void _changeIndicator(int value) {
    _tabController.animateTo(value);
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        actions: [
          TextButton(
              onPressed: () {
                box.put('introduction', false);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
              },
              child: Text(_skipTile))
        ],
        leading: _isFirstPage
            ? null
            : IconButton(
                onPressed: () {
                  pageController.previousPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                },
                icon: Icon(
                  Icons.chevron_left_outlined,
                  color: Colors.grey,
                ),
              ),
      ),
      body: Padding(
        padding: const PagePadding.all(),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (value) {
                  _incrementAndChange(value);
                },
                itemCount: OnBoardModels.onBoardItems.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Image.asset(
                          OnBoardModels.onBoardItems[index].imageWithPath),
                      SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: Text(
                          OnBoardModels.onBoardItems[index].title,
                          style: TextStyle(
                              color: Color(0XFF303030),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                              fontSize: 30,
                              fontStyle: FontStyle.normal),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: Text(
                            OnBoardModels.onBoardItems[index].description,
                            style: TextStyle(
                                color: Color(0XFF303030),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontStyle: FontStyle.normal)),
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TabPageSelector(
                  controller: _tabController,
                ),
                FloatingActionButton(
                  onPressed: () {
                    _incrementAndChange();
                    pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                    if (_startStatus) {
                      box.put('introduction', false);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ));
                    }
                  },
                  child: Text(_isLastPage ? _start : _next),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
