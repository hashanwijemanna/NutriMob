import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class SlidingPages extends StatefulWidget {
  @override
  _SlidingPagesState createState() => _SlidingPagesState();
}

class _SlidingPagesState extends State<SlidingPages> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/slider1.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                color: Colors.green,
                child: Center(child: Text('Page 2')),
              ),
              Container(
                color: Colors.blue,
                child: Center(child: Text('Page 3')),
              ),
            ],
          ),
          if (_currentPage != 0)
            Positioned(
              left: 16,
              bottom: 16,
              child: ElevatedButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Text('Previous'),
              ),
            ),
          if (_currentPage != 2)
            Positioned(
              right: 16,
              bottom: 16,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.green, // Text color
                ),
                onPressed: () {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Text('Next'),
              ),
            ),
          if (_currentPage == 2)
            Positioned(
              right: 16,
              bottom: 16,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.green, // Text color
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NextPage()),
                  );
                },
                child: Text('Finish'),
              ),
            ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 3,
                effect: WormEffect(
                  dotColor: Colors.white.withOpacity(0.5),
                  activeDotColor: Colors.white,
                  dotHeight: 12,
                  dotWidth: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Page'),
      ),
      body: Center(
        child: Text('You have finished the slides!'),
      ),
    );
  }
}
