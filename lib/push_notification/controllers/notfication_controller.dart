import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../notification.dart';

class NotificationController extends GetxController {
  final String baseUrl = 'https://e-labour-app.vercel.app/api/v1';

  // Observable list to hold notifications
  var selectedJobId = ''.obs;

  // Method to set the selected job ID
  void setSelectedJob(String jobId) {
    selectedJobId.value = jobId;
  }

  // You may have a list of notifications here too
  var notifications = <WorkerNotification>[].obs;

  // Method to fetch notifications from API
  Future<void> fetchNotifications() async {
    print('fetchNotifications called');
    final url = '$baseUrl/service-provider/notifications';
    print('Fetching notifications from: $url');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');  // Get the token from SharedPreferences

      if (token != null) {
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $token',  // Attach the Bearer token in the header
          },
        );

        // Log the status code to understand the response
        print('Response status code: ${response.statusCode}');
        if (response.statusCode == 200) {
          print('Response body: ${response.body}');

          final data = json.decode(response.body);
          print('Parsed JSON data: $data');

          notifications.value = List<WorkerNotification>.from(
            data['notifications'].map((notification) => WorkerNotification.fromJson(notification)),
          );

          // Log the number of notifications loaded
          print('Loaded ${notifications.length} notifications');
        } else {
          print('Failed to load notifications - Status code: ${response.statusCode}');
          Get.snackbar(
            'Error',
            'Failed to load notifications',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        print('Authentication token not found');
        Get.snackbar(
          'Error',
          'Authentication token not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      Get.snackbar(
        'Error',
        'An error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }  @override
  void onInit() {
    super.onInit();
    fetchNotifications(); // Fetch notifications when the controller is initialized
  }
}
