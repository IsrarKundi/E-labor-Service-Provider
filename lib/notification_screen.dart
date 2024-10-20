import 'package:flutter/material.dart';

import 'notification.dart';

class NotificationScreen extends StatelessWidget {
  final List<WorkerNotification> notifications = [
    WorkerNotification(
      profileImage: 'images/labor.jpeg',
      name: 'John Doe',
      rating: 4.5,
      category: 'Carpenter',
      status: 'Your request accepted',
    ),
    WorkerNotification(
      profileImage: 'images/plumber.webp',
      name: 'Jane Smith',
      rating: 4.0,
      category: 'Plumber',
      status: 'Your request rejected',
    ),
    WorkerNotification(
      profileImage: 'images/carpenter.jpg',
      name: 'Jane Smith',
      rating: 4.0,
      category: 'Plumber',
      status: 'Your request rejected',
    ),
    // Add more notifications here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset('images/logo.png', height: 33,),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Notifications',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Text(
              'Recent Notifications',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600]
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return NotificationCard(notification: notifications[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

}

class NotificationCard extends StatelessWidget {
  final WorkerNotification notification;

  NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xfffef1e9),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: AssetImage(notification.profileImage),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        notification.name,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 70.0),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16.0),
                          Icon(Icons.star, color: Colors.amber, size: 16.0),
                          Icon(Icons.star, color: Colors.amber, size: 16.0),
                          Icon(Icons.star, color: Colors.amber, size: 16.0),

                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 4.0),
                  Text(
                    notification.category,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    notification.status,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: notification.status.contains('accepted')
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
