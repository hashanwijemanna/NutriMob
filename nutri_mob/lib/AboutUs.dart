import 'dart:async';
import 'dart:ui'; // For the BackdropFilter
import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  late PageController _pageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Timer to auto-advance the PageView
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        final nextPage = (_pageController.page!.toInt() + 1) % 3; // Cycle through pages
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
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
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/AboutUsBack.gif', // Update with your background image path
              fit: BoxFit.cover,
            ),
          ),
          // Blur effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Meet the Team',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White color for better contrast
                    fontFamily: 'Lexend',
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  flex: 2, // Allocate more space to the PageView
                  child: Container(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: 3, // Number of team members
                      itemBuilder: (context, index) {
                        final images = [
                          'assets/person1.png', // Update with your image paths
                          'assets/person2.jpg',
                          'assets/person3.png',
                        ];

                        final names = [
                          'Hashan Wijemanna',
                          'Thamal Thathsara',
                          'Ravani Satheesha',
                        ];

                        return Center(
                          child: _buildTeamMember(
                            imageUrl: images[index],
                            name: names[index],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 37.8), // 1 cm gap (approximate)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 600), // Limit width for the description box
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        'We are a team of dedicated professionals with diverse skills and experiences, working together to create innovative solutions for your needs. Our collective expertise in software engineering, design, and project management drives us to deliver exceptional results and continuously improve our offerings.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontFamily: 'Lexend',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember({
    required String imageUrl,
    required String name,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipOval(
          child: Image.asset(
            imageUrl,
            width: 250, // Increased width for larger image
            height: 250, // Increased height for larger image
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00B2A9), // Sea light blue
            fontFamily: 'Lexend',
          ),
        ),
      ],
    );
  }
}
