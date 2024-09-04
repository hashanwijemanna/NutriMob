import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'User.dart';
import 'AboutUs.dart';
import 'Rules.dart';
import 'BMIAna.dart';
import 'DietPlan.dart';
import 'Notifications.dart';
import 'package:nutri_mob/LoginSignup/login.dart';
import 'WaterTracker.dart'; // Import the WaterTrackerGame screen

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
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_userName ?? 'User Name'),
              accountEmail: Text(_userEmail ?? 'user@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Color(0xFF00B2A9)),
              ),
              decoration: BoxDecoration(
                color: Color(0xFF00B2A9).withOpacity(0.8),
              ),
            ),
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
            _buildDrawerItem(Icons.info, 'About Us', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUsPage()),
              );
            }),
            _buildDrawerItem(Icons.rule, 'Rules & Regulations', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RulesAndRegulationsPage()),
              );
            }),
            const Divider(),
            _buildDrawerItem(Icons.logout, 'Logout', () async {
              await FirebaseAuth.instance.signOut(); // Sign out from Firebase
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            }),
          ],
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
              child: Text(
                'Welcome Back, ${_userName ?? 'User'}!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Lexend',
                ),
              ),
            ),
            const SizedBox(height: 10), // Space between message and image panel
            // Enhanced Moving Picture Panel
            Stack(
              alignment: Alignment.center,
              children: [
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
                              bottom: 20,
                              left: 20,
                              right: 20,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  _quotes[index],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.bold,
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
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white.withOpacity(0.8),
                    size: 30,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: Container(
                    width: 50,
                    height: 5,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10), // Space between image panel and grid
            // Grid at the Bottom
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    final items = [
                      ['Current Diet Plan', 'assets/diet.gif'],
                      ['Health Status', 'assets/health status.gif'],
                      ['Gained Calories (Daily)', 'assets/cal.gif'],
                      ['Water Level Tracker', 'assets/waterlevel.gif'], // Updated image asset name
                    ];

                    return GestureDetector(
                      onTap: () {
                        if (index == 3) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => WaterTrackingScreen()), // Navigate to WaterTrackerGame
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              items[index][1],
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              items[index][0],
                              style: TextStyle(
                                fontFamily: 'Lexend',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String assetName) {
    return Image.asset(
      assetName,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF00B2A9)),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Lexend',
          fontWeight: FontWeight.bold,
          color: Color(0xFF00B2A9),
        ),
      ),
      onTap: onTap,
    );
  }
}
