import 'package:e_labors/authentication/views/forgot%20password2.dart';
import 'package:e_labors/authentication/views/forgot_password1.dart';
import 'package:e_labors/authentication/views/registration_screen.dart';
import 'package:e_labors/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/authentication_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the AuthenticationController
    final AuthenticationController authenticationController = Get.put(AuthenticationController());

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset('images/logo.png', height: 40),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() => !authenticationController.isTextFieldFocused.value
                ? Container(
              alignment: Alignment.center,
              child: Image.asset(
                'images/signin.png',
                height: 155,
              ),
            )
                : SizedBox.shrink()),
            SizedBox(height: 20),

            // TextFields for email and password using the controller
            buildTextField('Email', authenticationController.emailController, focusNode: authenticationController.emailFocusNode),
            SizedBox(height: 20),
            buildTextField('Password', authenticationController.passwordController, obscureText: true, focusNode: authenticationController.passwordFocusNode),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => ForgotPassword1());
                    print('navigation performed');
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                authenticationController.signIn();
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
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            Obx(() => !authenticationController.isTextFieldFocused.value
                ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff272727),
                  ),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Get.to(() => Registration());
                    print('navigation performed');
                  },
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            )
                : SizedBox.shrink()),
          ],
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
          controller: controller,
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
}
