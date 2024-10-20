import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/authentication_controller.dart';

class ForgotPassword2 extends StatelessWidget {
  ForgotPassword2({super.key});
  final AuthenticationController authController = Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Reset Password'
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 28),
              Text('Enter the OTP and New Password', textAlign: TextAlign.center, style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xfff67322),
              ),
              ),
              SizedBox(height: 8),
              Text('Please enter 4 digit OTP code and you new different password', textAlign: TextAlign.center, style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
              ),

              SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return _buildOtpField(index, context); // Each OTP input field
                }),
              ),
              SizedBox(height: 28),
              buildTextField('Password', authController.passwordController, obscureText: true, focusNode: authController.passwordFocusNode),
              SizedBox(height: 28),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        authController.resetPassword();  // Registration method
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xfff67322),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 24,
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
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {bool obscureText = false, FocusNode? focusNode}) {
    return Container(
      child: Material(
        color: Color(0xfff2f2f2),
        elevation: 3,
        borderRadius: BorderRadius.circular(10),
        child: TextFormField(
          controller: authController.passwordController,
          obscureText: obscureText,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 9),
          ),
        ),
      ),
    );
  }

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