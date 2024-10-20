import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/authentication_controller.dart'; // Import the controller

class VerifyEmailScreen extends StatelessWidget {
  final AuthenticationController authController = Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please enter the 6-digit OTP sent to your email',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),

            // OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return _buildOtpField(index, context); // Each OTP input field
              }),
            ),
            SizedBox(height: 30),

            // Verify Button
            ElevatedButton(
              onPressed: () {
                authController.verifyOtp(); // Trigger the OTP verification
              },
              child: Text('Verify OTP'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // OTP Input Field Builder
  Widget _buildOtpField(int index, BuildContext context) {
    return Container(
      width: 40,
      height: 75,
      child: TextField(
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            FocusScope.of(context).nextFocus(); // Move to the next field when the user enters a digit
          }
          if (value.length == 0 && index > 0) {
            FocusScope.of(context).previousFocus(); // Move to the previous field when backspace is pressed
          }

          // Update the OTP in the controller
          authController.updateOtpAtPosition(index, value);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
