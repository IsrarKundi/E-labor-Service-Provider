import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  var jobs = [].obs; // Observable list to store jobs data
  final String baseUrl = 'https://e-labour-app.vercel.app/api/v1';

  @override
  void onInit() {
    super.onInit();
    fetchJobs(); // Fetch jobs when controller is initialized
  }

  Future<void> fetchJobs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      print('Error: No token found. Please log in again.');
      return;
    }

    final url = Uri.parse('$baseUrl/service-provider/all-jobs');
    print('Fetching jobs from: $url');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        jobs.value = data['jobs']; // Store the list of jobs in the observable

        // Optional: Log job IDs
        for (var job in data['jobs']) {
          print("Job ID: ${job['_id']}");
        }
      } else if (response.statusCode == 404) {
        final data = json.decode(response.body);
        if (data.containsKey('message')) {
          print('Message: ${data['message']}');
          jobs.clear();  // Clear jobs if no jobs found
        } else {
          print('Error: No jobs found');
        }
      } else {
        print('Error: Failed to load jobs with status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error: An error occurred while fetching jobs - $e');
    }
  }

  // Fetch job details by passing a job ID
  Future<Map<String, dynamic>?> fetchJobDetails(String jobId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      print('Error: No token found. Please log in again.');
      return null;
    }

    final String url = '$baseUrl/service-provider/job/$jobId';
    print("Fetching job details from: $url");

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        print("Failed to load job details. Status Code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching job details: $e");
      return null;
    }
  }

}
