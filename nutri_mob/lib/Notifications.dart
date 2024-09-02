import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: 'New Diet Plan Available!',
      date: '2024-09-01',
      description: 'Check out the latest updates to your diet plan.',
      icon: Icons.food_bank,
    ),
    NotificationItem(
      title: 'Reminder: Weekly Check-In',
      date: '2024-09-07',
      description: 'Don\'t forget to log your weekly health metrics.',
      icon: Icons.calendar_today,
    ),
    // Add more notifications as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.blueGrey.shade800,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return _buildNotificationCard(notification);
          },
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
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
          notification.date,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey.shade600),
        contentPadding: EdgeInsets.all(16),
        onTap: () {
          // Handle notification tap (e.g., navigate to a detailed view)
        },
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String date;
  final String description;
  final IconData icon;

  NotificationItem({
    required this.title,
    required this.date,
    required this.description,
    required this.icon,
  });
}
