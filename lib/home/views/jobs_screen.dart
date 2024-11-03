import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class JobsScreen extends StatelessWidget {
  JobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'images/logo.png',
            height: 33,
          ),
        ),
      ),
      body: Obx(() {
        if (homeController.jobs.isEmpty) {
          return Center(
            child: Text(
              "No jobs found",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: homeController.jobs.length,
          itemBuilder: (context, index) {
            final job = homeController.jobs[index];
            final client = job['clientId'];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Client info
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            client['image'] ?? 'https://via.placeholder.com/50',
                          ),
                          radius: 25,
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              client['name'],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Rating: ${client['averageRating']}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Job details
                    Text(
                      'Category: ${job['category']}',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      job['description'] ?? '',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Budget: \$${job['budget']}',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Estimated Time: ${job['estimatedTime']} hours',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 16),
                    // Job image
                    if (job['imageUrl'] != null)
                      Image.network(
                        job['imageUrl'],
                        fit: BoxFit.cover,
                        height: 150,
                        width: double.infinity,
                      ),
                    SizedBox(height: 16),
                    // Status
                    Text(
                      'Status: ${job['status']}',
                      style: TextStyle(
                        color: job['status'] == 'open' ? Colors.green : Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
