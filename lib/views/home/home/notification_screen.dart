import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/constants/colors.dart';
import '../../../core/helpers/helper.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationItem> notifications = [
    NotificationItem(
      icon: FontAwesomeIcons.umbrella,
      title: "New Trip Alert",
      description: "Your upcoming trip to Bali starts tomorrow!",
      time: "2 hours ago",
      type: NotificationType.trip,
    ),
    NotificationItem(
      icon: FontAwesomeIcons.percent,
      title: "Special Offer",
      description: "Get 20% off on your next booking. Limited time offer!",
      time: "1 day ago",
      type: NotificationType.offer,
    ),
    NotificationItem(
      icon: FontAwesomeIcons.solidBell,
      title: "Reminder",
      description: "Don't forget to review your last trip to Paris.",
      time: "2 days ago",
      type: NotificationType.reminder,
    ),
    // Add more notifications as needed
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.dark : AppColors.light,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDarkMode),
            Expanded(child: _buildNotificationList(isDarkMode)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Notifications',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                notifications.clear();
              });
            },
            child: Text(
              'Clear All',
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(bool isDarkMode) {
    return notifications.isEmpty
        ? Center(
            child: Text(
              'No notifications',
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black54,
                fontSize: 18,
              ),
            ),
          )
        : ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return _buildNotificationItem(notifications[index], isDarkMode);
            },
          );
  }

  Widget _buildNotificationItem(NotificationItem notification, bool isDarkMode) {
    return Dismissible(
      key: Key(notification.title),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() {
          notifications.remove(notification);
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800]?.withOpacity(0.5) : Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: _getNotificationColor(notification.type, isDarkMode),
            child: FaIcon(notification.icon, color: Colors.white, size: 20),
          ),
          title: Text(
            notification.title,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.description,
                style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
              ),
              const SizedBox(height: 4),
              Text(
                notification.time,
                style: TextStyle(color: isDarkMode ? Colors.white54 : Colors.black54, fontSize: 12),
              ),
            ],
          ),
          isThreeLine: true,
        ),
      ),
    );
  }

  Color _getNotificationColor(NotificationType type, bool isDarkMode) {
    switch (type) {
      case NotificationType.trip:
        return Colors.green;
      case NotificationType.offer:
        return Colors.orange;
      case NotificationType.reminder:
        return Colors.blue;
      default:
        return Colors.grey; // Default color for unknown types
    }
  }
}

enum NotificationType { trip, offer, reminder }

class NotificationItem {
  final IconData icon;
  final String title;
  final String description;
  final String time;
  final NotificationType type;

  NotificationItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.time,
    required this.type,
  });
}
