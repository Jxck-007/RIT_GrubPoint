import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<AppNotification> _notifications = [
    AppNotification(
      title: 'Order Complete',
      message: 'Your order #12345 has been completed.',
      time: DateTime.now().subtract(const Duration(minutes: 15)),
      isRead: false,
    ),
    AppNotification(
      title: 'Special Offer',
      message: 'Get 20% off on your next order with code GRUB20.',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
    ),
    AppNotification(
      title: 'New Restaurant',
      message: 'Crossroads Cafe is now available on GrubPoint!',
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    AppNotification(
      title: 'Delivery Update',
      message: 'Your order will arrive in 10 minutes.',
      time: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
    AppNotification(
      title: 'Account Update',
      message: 'Your profile was updated successfully.',
      time: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              setState(() {
                for (var notification in _notifications) {
                  notification.isRead = true;
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All notifications marked as read'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: _notifications.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return Dismissible(
                  key: Key(notification.title + index.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      _notifications.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notification removed'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: notification.isRead
                          ? Colors.grey[300]
                          : Theme.of(context).primaryColor,
                      child: Icon(
                        Icons.notifications,
                        color: notification.isRead
                            ? Colors.grey[700]
                            : Colors.white,
                      ),
                    ),
                    title: Text(
                      notification.title,
                      style: TextStyle(
                        fontWeight:
                            notification.isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notification.message),
                        const SizedBox(height: 4),
                        Text(
                          _getTimeAgo(notification.time),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    trailing: !notification.isRead
                        ? Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        notification.isRead = true;
                      });
                      // Show notification details
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(notification.title),
                          content: Text(notification.message),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  String _getTimeAgo(DateTime time) {
    final difference = DateTime.now().difference(time);
    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}

class AppNotification {
  String title;
  String message;
  DateTime time;
  bool isRead;

  AppNotification({
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
  });
} 