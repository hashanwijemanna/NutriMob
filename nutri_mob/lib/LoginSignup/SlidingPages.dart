import 'package:flutter/material.dart';
import 'package:nutri_mob/BMI CAL.dart'; // Make sure this import is correct

class SlidingPages extends StatefulWidget {
  @override
  _SlidingPagesState createState() => _SlidingPagesState();
}

class _SlidingPagesState extends State<SlidingPages> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    Future.delayed(Duration(seconds: 8)).then((_) {
      if (_pageController.hasClients && _currentPage < 2) {
        _pageController.animateToPage(
          _currentPage + 1,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        ).then((_) {
          // Restart auto-slide after animation completes
          _startAutoSlide();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
              _startAutoSlide(); // Restart auto-slide on page change
            },
            children: [
              buildPage(
                backgroundImage: 'assets/background1.gif',
                title: 'Welcome to NutriMob',
                description: 'Easily track your nutrition and health goals.',
              ),
              buildPage(
                backgroundImage: 'assets/background2.gif',
                title: 'Monitor Your Progress',
                description: 'Stay on top of your diet with detailed progress tracking.',
              ),
              buildPage(
                backgroundImage: 'assets/background3.gif',
                title: 'Achieve Your Goals',
                description: 'Get personalized recommendations tailored for your success.',
              ),
            ],
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    width: _currentPage == index ? 12.0 : 8.0,
                    height: _currentPage == index ? 12.0 : 8.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index ? Colors.blueAccent : Colors.grey,
                    ),
                  );
                }),
              ),
            ),
          ),
          if (_currentPage == 2)
            Positioned(
              right: 16,
              bottom: 16,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BMICalculater(), // Navigate to BMICalculater
                    ),
                  );
                },
                child: Text('Get Started'),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildPage({
    required String backgroundImage,
    required String title,
    required String description,
  }) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.lightGreenAccent,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(0, 2),
                  blurRadius: 6,
                  color: Colors.black.withOpacity(0.7),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 4,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
