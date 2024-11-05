import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {

  final String baseUrl = 'https://e-labour-app.vercel.app/api/v1';

  late int jobIndex = 0;


// List of jobs fetched from the server
  var jobs = [].obs;

  // Observable variable to store the selected job
  var selectedJob = {}.obs;

  // Method to set the selected job
  void setSelectedJob(Map<String, dynamic> job) {
    selectedJob.value = job;
  }

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

  // Send a request for a job by passing job ID and offered price
  Future<void> requestJob(String jobId, int offeredPrice) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      print('Error: No token found. Please log in again.');
      return;
    }

    final String url = '$baseUrl/service-provider/request-job/$jobId';
    print("Sending job request to: $url");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'offeredPrice': offeredPrice,
        }),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Job request sent successfully");
        Get.snackbar("Success", "Job request sent successfully");
      } else {
        print("Failed to send job request. Status Code: ${response.statusCode}");
        Get.snackbar("Error", "Failed to send job request");
      }
    } catch (e) {
      print("Error sending job request: $e");
      Get.snackbar("Error", "An error occurred while sending job request");
    }
  }

}
