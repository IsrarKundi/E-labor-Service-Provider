import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/job_detail_screen.dart';
import '../../notification.dart';
import '../controllers/notfication_controller.dart';

class NotificationScreen extends StatelessWidget {
  final NotificationController notificationController = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset('images/logo.png', height: 33),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Notifications',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Text(
              'Recent Notifications',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (notificationController.notifications.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: notificationController.notifications.length,
                itemBuilder: (context, index) {
                  return NotificationCard(notification: notificationController.notifications[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final WorkerNotification notification;
  final NotificationController notificationController = Get.find<NotificationController>();

  NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (notification.jobId != null) {
          // Set the selected job in NotificationController
          notificationController.setSelectedJob(notification.jobId!);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobDetailsScreen(jobId: notification.jobId!),
            ),
          );
        } else {
          Get.snackbar(
            'No Job Linked',
            'This notification is not linked to a job.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      child: Card(
        color: notification.isRead ? Colors.white : Color(0xfffef1e9),
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Padding(
          padding: EdgeInsets.all(6.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(notification.profileImage),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.name,
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: notification.message.contains('accepted') ? Colors.black54 : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      '${notification.formattedCreatedAt}',
                      style: TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
