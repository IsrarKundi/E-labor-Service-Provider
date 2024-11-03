import 'dart:convert';

import 'package:e_labors/authentication/views/verify_email_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/forgot password2.dart';


class AuthenticationController extends GetxController {

  final String baseUrl = 'https://e-labour-app.vercel.app/api/v1';

  // Text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Focus nodes
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  // Observable to track focus
  var isTextFieldFocused = false.obs;

  // Obscure text flags
  var isPasswordObscure = true.obs;
  var isConfirmPasswordObscure = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Add listeners to update focus state
    emailFocusNode.addListener(updateTextFieldFocus);
    passwordFocusNode.addListener(updateTextFieldFocus);
    fetchCategories();

    // Initialize the Location object
    location = Location();


    // Get user location on init
    getLocation();
  }
  late Location location = Location(); // Declare a Location object

  @override
  void onClose() {
    // Dispose controllers and focus nodes
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }

  // Function to update the focus state
  void updateTextFieldFocus() {
    isTextFieldFocused.value = emailFocusNode.hasFocus || passwordFocusNode.hasFocus;
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordObscure.value = !isPasswordObscure.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordObscure.value = !isConfirmPasswordObscure.value;
  }



  ///........................Sign-in logic.........................
  Future<void> signIn() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text;

    // Make the API request
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      // Authentication successful
      final responseBody = jsonDecode(response.body);
      final String token = responseBody['token'];
      print(token);
      // Store the token in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      Get.offNamed('/main_screen', arguments: token); // Navigate to home screen
    } else {
      // Authentication failed
      Get.snackbar(
        'Error',
        'Login failed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  ///.................Get Categories..................
  RxList<String> categories = <String>[].obs; // Add your categories here
  RxString selectedCategory = ''.obs;

  Future<void> fetchCategories() async {
    final url = Uri.parse('$baseUrl/service-provider/job-categories');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Successfully fetched data
        List<dynamic> responseData = json.decode(response.body);
        // Update the categories list with the fetched categories
        categories.assignAll(responseData.cast<String>());
      } else {
        // Handle error here
        print('Failed to fetch categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
    print(selectedCategory.value);
  }

  ///......................Registration logic......................

  Future<void> registerUser() async {
    await Firebase.initializeApp(); // Ensure Firebase is initialized

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    print("FCM Token: $token"); // You can send the token to your backend if needed

    final String username = nameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;
    print('before location fetch');

    // Check if location retrieval was successful (optional)
    if (location.latitude == 0.0 || location.longitude == 0.0) {
      // Handle location retrieval error (e.g., show a message to the user)
      return;
    }

    final double latitude = location.latitude;
    final double longitude = location.longitude;

    print('before api hit');
    // Make the API request
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      body: {
        'name': username,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'coordinates': '[${longitude},${latitude}]',
        'role': 'service_provider',
        'contact': '122332133',
        'jobCategory': selectedCategory.value,
        'fcmToken': token,
      },
    );
    print(response.body);

    print("API is hit");
    print(response.statusCode);
    if (response.statusCode == 201) {
      print('STATUS CODE IS: ');
      print(response.statusCode);
      // Registration successful
      Get.snackbar(
        'Success',
        'Registration successful',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.to(() => VerifyEmailScreen());
    } else {
      // Registration failed
      Get.snackbar(
        'Error',
        'Registration failed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
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


  ///..........Verify Email Logic..............

// List to store OTP digits (6 positions)
  List<String> otpDigits = List.generate(6, (index) => '');

  // Method to update OTP based on user input
  void updateOtpAtPosition(int index, String value) {
    otpDigits[index] = value;
  }

  // Function to verify the OTP
  Future<void> verifyOtp() async {
    final String email = emailController.text.trim();
    // Combine the 6 OTP digits into a single string
    String otp = otpDigits.join();

    // Ensure the OTP is 6 digits
    if (otp.length != 6) {
      Get.snackbar('Error', 'Please enter a valid 6-digit OTP');
      return;
    }

    // API request to verify the OTP
    final response = await http.post(
      Uri.parse('https://e-labour-app.vercel.app/api/v1/auth/verify-email'), // Replace with your API URL
      body: {
        'email': email, // Use the registered email stored in this controller
        'verificationOtp': otp, // Send the combined OTP
      },
    );
    print(response.body);

    // Handle the response
    if (response.statusCode == 200) {
      Get.snackbar('Success', 'OTP verified successfully');
      print(response.body);
      // Navigate to the next screen or home screen
      Get.offNamed('/main_screen');
    } else {
      Get.snackbar('Error', 'Invalid OTP, please try again');
    }
  }

  ///........................Reset Password Logic......................


  //Forgot password

  Future<void> forgotPassword() async{
    String email = emailController.text.trim(); // Email from the first screen

    try {
      final response = await http.post(
        Uri.parse('https://e-labour-app.vercel.app/api/v1/auth/forgot-password'),
        body: {
          'email': email, // Use the registered email stored in this controller
        },
      );
      print(response.body);

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Password reset successful');
        print(response.body);
        // Navigate back to login or home screen
        Get.to(() => ForgotPassword2());
      } else {
        Get.snackbar('Error', 'Failed to reset password');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }


  List<String> otpList = List.filled(6, '');

  Future<void> resetPassword() async {
    String email = emailController.text.trim(); // Email from the first screen
    String password = passwordController.text.trim();
    String otp = otpDigits.join(); // Combine all digits into a single OTP
    print('OTP: $otp');
    print('Password $password');
    print('Email: $email');
    if (otp.length != 6 || password.isEmpty) {
      Get.snackbar('Error', 'OTP or Password cannot be empty');
      return;
    }

    // API request to reset the password
    try {
      final response = await http.post(
        Uri.parse('https://e-labour-app.vercel.app/api/v1/auth/reset-password'),
        body: {
          'email': email, // Use the registered email stored in this controller
          'otp': otp, // Send the combined OTP
          'password': password
        },
      );
      print(response.body);
      print('OTP: $otp');
      print('Password $password');
      print('Email: $email');
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Password reset successful');
        // Navigate back to login or home screen
        Get.offAllNamed('/main_screen'); // Change route accordingly
      } else {
        Get.snackbar('Error', 'Failed to reset password');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  // // Method to update OTP digit in the list
  // void updateOtpAtPosition(int index, String value) {
  //   if (value.isNotEmpty && value.length == 1) {
  //     otpList[index] = value;
  //   } else {
  //     otpList[index] = ''; // Clear the digit if empty
  //   }
  // }

}



class Location {

  double latitude = 0;
  double longitude = 0;

  Future<void> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      longitude = position.longitude;
      latitude = position.latitude;

    } catch (e) {
      print(e);
      print('exception happened');
    }
  }
}