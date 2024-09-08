import 'dart:async';
import 'package:flutter/material.dart';

class RulesAndRegulationsPage extends StatefulWidget {
  const RulesAndRegulationsPage({super.key});

  @override
  _RulesAndRegulationsPageState createState() => _RulesAndRegulationsPageState();
}

class _RulesAndRegulationsPageState extends State<RulesAndRegulationsPage> {
  late final PageController _pageController;
  late final Timer _timer;
  final int _autoSlideInterval = 6500; // 6.5 seconds

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(milliseconds: _autoSlideInterval), (Timer timer) {
      if (_pageController.hasClients) {
        final nextPage = (_pageController.page?.toInt() ?? 0) + 1;
        if (nextPage < 5) {
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Rules and Regulations',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Lexend',
          ),
        ),
        backgroundColor: Color(0xFF00B2A9), // Sea light blue
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Color(0xFFE0F8F7), // Light sea blue background
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: PageView(
                controller: _pageController,
                children: [
                  _buildCarouselItem('assets/rule1.gif', 'Rule 1: Respect Privacy'),
                  _buildCarouselItem('assets/rule2.gif', 'Rule 2: Use Proper Language'),
                  _buildCarouselItem('assets/rule3.gif', 'Rule 3: Follow Guidelines'),
                  _buildCarouselItem('assets/rule4.gif', 'Rule 4: Report Issues'),
                  _buildCarouselItem('assets/rule5.gif', 'Rule 5: Provide Feedback'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 3,
              child: ListView(
                children: [
                  _buildRuleSection(
                    imagePath: 'assets/rule1.gif',
                    title: 'Rule 1: Respect Privacy',
                    description: 'Ensure the privacy of all users by not sharing personal information without consent.',
                  ),
                  const SizedBox(height: 20),
                  _buildRuleSection(
                    imagePath: 'assets/rule2.gif',
                    title: 'Rule 2: Use Proper Language',
                    description: 'Always use appropriate language and avoid offensive or inappropriate comments.',
                  ),
                  const SizedBox(height: 20),
                  _buildRuleSection(
                    imagePath: 'assets/rule3.gif',
                    title: 'Rule 3: Follow Guidelines',
                    description: 'Adhere to the provided guidelines and protocols to ensure smooth operations.',
                  ),
                  const SizedBox(height: 20),
                  _buildRuleSection(
                    imagePath: 'assets/rule4.gif',
                    title: 'Rule 4: Report Issues',
                    description: 'Report any issues or bugs encountered during the use of the app to the support team.',
                  ),
                  const SizedBox(height: 20),
                  _buildRuleSection(
                    imagePath: 'assets/rule5.gif',
                    title: 'Rule 5: Provide Feedback',
                    description: 'Provide constructive feedback to help us improve the app and user experience.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselItem(String imagePath, String ruleTitle) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Text(
          ruleTitle,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            backgroundColor: Colors.black.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildRuleSection({
    required String imagePath,
    required String title,
    required String description,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rule icon/image
          Image.asset(
            imagePath,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 16),
          // Rule title and description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00B2A9), // Sea light blue
                    fontFamily: 'Lexend',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontFamily: 'Lexend',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
