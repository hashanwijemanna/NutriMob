import 'package:flutter/material.dart';
import 'package:nutri_mob/BMI%20CAL.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
    // Initialize your resources here, but avoid context-dependent operations
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Safe to use context here
    // Preload images
    precacheImage(AssetImage('assets/welcome.gif'), context);
    precacheImage(AssetImage('assets/Track.gif'), context);
    precacheImage(AssetImage('assets/Achieve.gif'), context);
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
            },
            children: [
              buildPage(
                imagePath: 'assets/welcome.gif',
                gradientColors: [Colors.orange.shade200, Colors.deepOrange.shade400],
                text: 'Welcome to NutriMob',
              ),
              buildPage(
                imagePath: 'assets/Track.gif',
                gradientColors: [Colors.lightGreen.shade300, Colors.green.shade600],
                text: 'Track Your Nutrition',
              ),
              buildPage(
                imagePath: 'assets/Achieve.gif',
                gradientColors: [Colors.lightBlue.shade300, Colors.blue.shade600],
                text: 'Achieve Your Goals',
              ),
            ],
          ),
          buildNavigationButtons(context),
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

  Widget buildPage({
    required String imagePath,
    required List<Color> gradientColors,
    required String text,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black54,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavigationButtons(BuildContext context) {
    return Stack(
      children: [
        if (_currentPage > 0)
          Positioned(
            left: 16,
            bottom: 16,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
              ),
              onPressed: () {
                _pageController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Text('Previous'),
            ),
          ),
        if (_currentPage < 2)
          Positioned(
            right: 16,
            bottom: 16,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
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
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BMICalculater()),
                );
              },
              child: Text('Finish'),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
