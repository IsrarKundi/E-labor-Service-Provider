import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class JobDetailsScreen extends StatefulWidget {
  final String jobId; // Add jobId parameter

  const JobDetailsScreen({required this.jobId}); // Update constructor to require jobId

  @override
  _JobDetailsScreenState createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  final HomeController _homeController = Get.put(HomeController());

  Map<String, dynamic>? jobDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJobDetails();
  }

  Future<void> fetchJobDetails() async {
    // Pass the jobId from widget to fetchJobDetails
    final data = await _homeController.fetchJobDetails(widget.jobId);
    setState(() {
      jobDetails = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'images/logo.png',
            height: 33,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : jobDetails != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${jobDetails!['clientId']['name']}',
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Category: ${jobDetails!['category']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Description: ${jobDetails!['description']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Budget: \$${jobDetails!['budget']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Estimated Time: ${jobDetails!['estimatedTime']} hours',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${jobDetails!['status']}',
              style: TextStyle(
                  fontSize: 16,
                  color: jobDetails!['status'] == 'open'
                      ? Colors.green
                      : Colors.red),
            ),
            const SizedBox(height: 16),
            if (jobDetails!['imageUrl'] != null)
              Center(
                child: Image.network(
                  jobDetails!['imageUrl'],
                  height: 200,
                ),
              ),
            const SizedBox(height: 29),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xfff67322),
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      'Apply',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
          : const Center(child: Text('No job details available')),
    );
  }
}
