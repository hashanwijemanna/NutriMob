import 'package:flutter/material.dart';
import 'package:nutri_mob/BMIA.dart';
import 'DietPlan.dart';

class NotificationsPage extends StatelessWidget {
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: 'New Diet Plan Available!',
      date: DateTime.now(), // Current date
      description: 'Check out the latest updates to your diet plan.',
      icon: Icons.food_bank,
      destinationPage: DietPlanPage(), // Add the destination page
    ),
    NotificationItem(
      title: 'Reminder: Weekly Check-In',
      date: DateTime.now(), // Current date
      description: 'Don\'t forget to log your weekly health metrics.',
      icon: Icons.calendar_today,
      destinationPage: BMIAnalysisPage(), // Add the destination page
    ),
    // Add more notifications with their respective destination pages
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Lexend',
          ),
        ),
        backgroundColor: Color(0xFF00B2A9),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return _buildNotificationCard(notification, context);
          },
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification, BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(notification.icon, color: Colors.blueGrey.shade800),
        title: Text(
          notification.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          '${notification.date.day}/${notification.date.month}/${notification.date.year}', // Format date as day/month/year
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey.shade600),
        contentPadding: EdgeInsets.all(16),
        onTap: () {
          // Navigate to the destination page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => notification.destinationPage,
            ),
          );
        },
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final DateTime date; // Changed from String to DateTime
  final String description;
  final IconData icon;
  final Widget destinationPage; // New property to hold the destination page

  NotificationItem({
    required this.title,
    required this.date,
    required this.description,
    required this.icon,
    required this.destinationPage,
  });
}
