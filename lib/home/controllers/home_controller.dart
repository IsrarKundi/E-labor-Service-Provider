import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../authentication/controller/authentication_controller.dart';

class HomeController extends GetxController {

  final String baseUrl = 'https://e-labour-app.vercel.app/api/v1';
  var userLocation = {}.obs;
  var clientLocation = {}.obs;
  var isLoading = false.obs;

  late int jobIndex = 0;


// List of jobs fetched from the server
  var jobs = [].obs;

  // Observable variable to store the selected job
  var selectedJob = {}.obs;

  // Method to set the selected job
  void setSelectedJob(Map<String, dynamic> job) {
    selectedJob.value = job;
  }

  RxInt applied = 0.obs;

  late Location location = Location(); // Declare a Location object

  @override
  void onInit() {
    super.onInit();
    location = Location();
    getLocation();

    getLocation().then((_) {
      print('LATITUDE: ${location.latitude}');
      print('LONGITUDE: ${location.longitude}');
    }).catchError((e) {
      print('Error getting location: $e');
    });
    fetchClientLocation();

    fetchJobs(); // Fetch jobs when controller is initialized

  }

  Future<void> getLocation() async {
    try {
      await location.getLocation(); // Call getLocation on the Location object
      // Update UI with retrieved coordinates (optional)
    } catch (e) {
      print(e);
      // Handle location retrieval errors (optional)
    }
  }

  Future<void> fetchJobs() async {
    isLoading.value = true;
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
        jobs.value = List.from(data['jobs']);  // Use List.from to ensure it's a list
        isLoading.value = false;

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
          isLoading.value = false;

          print('Error: No jobs found');
        }
      } else {
        isLoading.value = false;

        print('Error: Failed to load jobs with status code ${response.statusCode}');
      }
    } catch (e) {
      isLoading.value = false;

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
    isLoading.value = true;

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

        fetchJobs();
        fetchClientLocation();
        isLoading.value = false;

        print("Job request sent successfully");
        Get.snackbar("Success", "Job request sent successfully");
        Get.back();
      } else {
        print("Failed to send job request. Status Code: ${response.statusCode}");
        Get.snackbar("Error", "Failed to send job request");
        isLoading.value = false;

      }
    } catch (e) {
      print("Error sending job request: $e");
      isLoading.value = false;

      Get.snackbar("Error", "An error occurred while sending job request");
    }
  }


  ///...........................Fetch Client Details.........................

  var clientData = {}.obs;

// Method to fetch client details
  Future<void> fetchClientDetails(String clientId) async {
    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        print('Error: No token found. Please log in again.');
        Get.snackbar("Error", "No token found. Please log in again.");
        isLoading.value = false;
        return;
      }

      final String url = '$baseUrl/service-provider/client/$clientId';
      print("Fetching client details from: $url");

      // Make the API call with authorization header
      final response = await GetConnect().get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('fetch Client Profile: ${response.body}');
      print('fetch Client Profile: ${response.statusCode}');

      if (response.statusCode == 200) {
        clientData.value = response.body;
      } else {
        Get.snackbar("Error", "Failed to fetch client details");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print("Error fetching client details: $e");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> fetchClientLocation() async {
    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        Get.snackbar('Error', 'No token found. Please log in again.');
        return;
      }

      final url = Uri.parse('$baseUrl/service-provider/client-location');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      print('Client Location: ${response.body}');
      print('Client Location: ${response.statusCode}');


      if (response.statusCode == 200) {
        clientLocation.value = json.decode(response.body);
      } else {
        // Get.snackbar('Error', 'Failed to fetch client location.');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching client location.');
    } finally {
      isLoading.value = false;
    }
  }

}
