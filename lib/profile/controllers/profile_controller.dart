import 'dart:convert'; // For jsonDecode
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:e_labors/profile/views/profile_screen.dart';
import 'package:e_labors/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import '../../helper/customcard.dart';
import '../../main.dart';

class ProfileController extends GetxController {
  final String baseUrl = 'https://e-labour-app.vercel.app/api/v1';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  // Observable variables for the user data
  RxString userId = ''.obs;
  RxString name = 'Loading...'.obs;
  RxString contact = ''.obs;
  RxString email = 'Loading...'.obs;
  RxString role = ''.obs;
  RxString lastActive = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadStoredProfileImage();
    fetchUserProfile();  // Fetch user profile when the controller initializes
  }

  Future<void> loadStoredProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? base64Image = prefs.getString('profile_image');

    if (base64Image != null) {
      // Convert base64 string back to bytes and create a File
      List<int> imageBytes = base64Decode(base64Image);
      final Directory directory = await getTemporaryDirectory();
      final File imageFile = File('${directory.path}/profile_image.jpg');
      await imageFile.writeAsBytes(imageBytes);
      profileImage.value = imageFile;
      print('Profile image loaded from SharedPreferences');
    }
  }

  ///........................Fetch User Profile............................
  Future<void> fetchUserProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');  // Get the token from SharedPreferences
      if (token != null) {
        // Make the API request to get user details
        final response = await http.get(
          Uri.parse('$baseUrl/user/show-me'),
          headers: {
            'Authorization': 'Bearer $token',  // Attach the Bearer token in the header
          },
        );
        if (response.statusCode == 200) {
          // Parse the response body to get user details
          final responseBody = jsonDecode(response.body);
          userId.value = responseBody['_id'];
          name.value = responseBody['name'];
          contact.value = responseBody['contact'];
          email.value = responseBody['email'];
          role.value = responseBody['role'];
          lastActive.value = responseBody['lastActive'];
        } else {
          Get.snackbar(
            'Error',
            'Failed to fetch user profile',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Authentication token not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error fetching user profile: $e');

    }

  }

  ///...........................Edit Profile Logic............................



  Future<void> pickImage(BuildContext context) async {
    try {
      ImagePicker imagePicker = ImagePicker();
      XFile? photoTaken = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (photoTaken == null) return; // Exit early if no image is picked

      // Convert XFile to File
      File image = File(photoTaken.path);

      // Show a loading toast
      final cancelToast = BotToast.showLoading();

      // Assign the picked image to the reactive variable
      profileImage.value = image;

      cancelToast(); // Cancel the loading toast

    } on PlatformException {
      print('Failed to pick image');
    } finally {
      BotToast.cleanAll(); // Clean up any remaining toast notifications
    }
    print(profileImage.value);
  }



  var profileImage = Rxn<File>();
  var profileImageUrl = RxString('');

  Future<void> editProfile(BuildContext context) async {
    try {
      showCustomLoadingDialog(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');  // Get the token from SharedPreferences

      if (token != null) {
        print('token not null');
        // API URL
        String url = '$baseUrl/user/edit-profile';

        // Prepare the multipart request
        var request = http.MultipartRequest('PATCH', Uri.parse(url))
          ..headers['Authorization'] = 'Bearer $token' // Attach the Bearer token
          ..fields['name'] = nameController.text
          ..fields['contact'] = contactController.text;
        print('request made');

        // If the profile image is selected, add it to the request
        if (profileImage.value != null) {
          print('profile image not null');
          var imageFile = profileImage.value!;
          var imageStream = http.ByteStream(imageFile.openRead());
          var imageLength = await imageFile.length();

          request.files.add(http.MultipartFile(
            'image', // field name for image
            imageStream,
            imageLength,
            filename: imageFile.path.split('/').last,
            contentType: MediaType('image', 'jpeg'), // Set correct MIME type
          ));
        }

        print('before response');

        // Send the request and get the response
        var response = await request.send();
        print(response.statusCode);
        // Check the response status
        if (response.statusCode == 200) {
          List<int> imageBytes = await profileImage.value!.readAsBytes();
          String base64Image = base64Encode(imageBytes);
          await prefs.setString('profile_image', base64Image);
          print('Profile image saved to SharedPreferences');

          var responseBody = await http.Response.fromStream(response);
          final data = jsonDecode(responseBody.body);
          print('Data: $data');
          // Update observable variables
          name.value = data['name'] ?? nameController.text;
          profileImageUrl.value = data['image'];
          Get.snackbar(
            'Success',
            'Profile updated successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          print('Response body: ${await response.stream.bytesToString()}'); // Log the response body for debugging
          Get.snackbar(
            'Error',
            'Failed to update profile. Status code: ${response.statusCode}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Authentication token not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error occurred while updating profile: $e');
      // Get.snackbar(
      //   'Error',
      //   'Something went wrong',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
    }
    nameController.clear();
    contactController.clear();
    Get.offAll(MainScreen(selectedIndex: 3));
  }
}
