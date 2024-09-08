import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutri_mob/feedback.dart';
import 'User.dart';
import 'AboutUs.dart';
import 'Rules.dart';
import 'BMIA.dart';
import 'DietPlan.dart';
import 'Notifications.dart';
import 'package:nutri_mob/LoginSignup/login.dart';
import 'WaterTracker.dart';
import 'Tips&Tricks.dart';
import 'HealthStatus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  String? _userName;
  String? _userEmail;

  final List<String> _quotes = [
    '“Health is wealth.”',
    '“Stay strong, stay healthy.”',
    '“Make today count.”',
    '“You are what you eat.”',
    '“Fitness is not about being better than someone else; it’s about being better than you used to be.”',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);

    // Timer to auto-advance the PageView
    _timer = Timer.periodic(Duration(seconds: 4), (Timer timer) {
      setState(() {
        _currentPage = (_currentPage + 1) % _quotes.length; // Cycle through pages
      });

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });

    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        _userName = userDoc.get('name');
        _userEmail = user.email;
      });
    }
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
        title: Row(
          children: [
            Icon(Icons.dashboard, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              'Dashboard',
              style: TextStyle(
                fontFamily: 'Lexend',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF00B2A9), // Sea light blue
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Color(0xFFE0F8F7), // Lighter sea blue background
          child: Column(
            children: [
              // Custom header
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color(0xFF00B2A9), // Sea light blue background
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                  ),
                ),
                child: UserAccountsDrawerHeader(
                  accountName: Text(
                    _userName ?? 'User Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text(
                    _userEmail ?? 'user@example.com',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontFamily: 'Lexend',
                    ),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/pro.gif'),
                    // Uncomment the following line if you want to use a network image instead
                    //backgroundImage: NetworkImage('https://example.com/profile_pic.png'),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF00B2A9),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerItem(Icons.person, 'User Profile', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserProfileScreen()),
                      );
                    }),
                    _buildDrawerItem(Icons.fitness_center, 'BMI Analysis', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BMIAnalysisPage()),
                      );
                    }),
                    _buildDrawerItem(Icons.restaurant_menu, 'Diet Plan', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DietPlanPage()),
                      );
                    }),
                    _buildDrawerItem(Icons.notifications, 'Notifications', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NotificationsPage()),
                      );
                    }),
                    _buildDrawerItem(Icons.rule, 'Rules & Regulations', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RulesAndRegulationsPage()),
                      );
                    }),
                    _buildDrawerItem(Icons.feedback, 'Feedback', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FeedbackPage()),
                      );
                    }),
                    _buildDrawerItem(Icons.info, 'About Us', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutUsPage()),
                      );
                    }),
                    const Divider(),
                    _buildDrawerItem(Icons.logout, 'Logout', () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      body: Container(
        color: Color(0xFFE0F8F7), // Lighter sea blue
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Message
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00B2A9), Color(0xFF80E2E0)], // Gradient from sea blue to lighter blue
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back, ${_userName ?? 'User'}!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Lexend',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Today is ${_getFormattedDate()}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                      fontFamily: 'Lexend',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Space between message and image panel

            // Enhanced Moving Picture Panel
            Container(
              height: MediaQuery.of(context).size.height * 0.30,
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 15,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _quotes.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        _buildImage('assets/slide${index + 1}.gif'),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _quotes[index],
                              style: TextStyle(
                                fontSize: 14, // Smaller font size
                                color: Colors.white,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20), // Space between image panel and grid

            // Grid at the Bottom
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1, // Make items a bit larger
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  children: [
                    _buildGridItem('Water Level Tracker', 'assets/waterlevel.gif', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WaterTrackingScreen()), // Link to WaterTracker
                      );
                    }),
                    _buildGridItem('Diet Plan', 'assets/diet.gif', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DietPlanPage()), // Link to DietPlan
                      );
                    }),
                    _buildGridItem('Health Status', 'assets/health status.gif', () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HealthStatusScreen()),
                      );
                    }),

                      _buildGridItem('Healthy Tips', 'assets/cal.gif', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HealthTipsScreen()),
                        );
                      }


                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        text,
        style: TextStyle(
          fontFamily: 'Lexend',
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildImage(String path) {
    return Image.asset(
      path,
      fit: BoxFit.cover,
      width: double.infinity,
    );
  }

  String _getFormattedDate() {
    DateTime now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
  }

  Widget _buildGridItem(String label, String gifPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(gifPath),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(20), // Slightly larger radius
          color: Colors.black.withOpacity(0.3), // Overlay to enhance text visibility
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // Darker shadow for better contrast
              spreadRadius: 4,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.3)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(20), // Slightly larger radius
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14, // Decreased font size
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lexend',
                        shadows: [
                          Shadow(
                            blurRadius: 6.0, // Increased shadow blur
                            color: Colors.black.withOpacity(0.6),
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
