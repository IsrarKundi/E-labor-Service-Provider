import 'package:e_labors/authentication/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/authentication_controller.dart';

class Registration extends StatelessWidget {
  final AuthenticationController authController = Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset('images/logo.png', height: 40,),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'images/registration.png',
                  height: 160,
                ),
              ),
              SizedBox(height: 20),
              // Adjusted variable name: nameController
              buildTextField('Name', authController.nameController),
              SizedBox(height: 20),
              // Adjusted variable name: emailController
              buildTextField('Email', authController.emailController),
              SizedBox(height: 20),
              // Category Dropdown
              Obx(() => Material(
                color: Color(0xfff2f2f2),
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Choose Category',
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 9),
                    filled: true,
                    fillColor: Color(0xfff2f2f2),
                    border: InputBorder.none,
                  ),
                  value: authController.selectedCategory.value.isEmpty ? null : authController.selectedCategory.value,
                  items: authController.categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    authController.setSelectedCategory(newValue!);
                  },
                ),
              )
              ),
              SizedBox(height: 20),
              // Adjusted for password visibility
              Obx(() => buildTextField(
                'Password',
                authController.passwordController, // Adjusted variable name: confirmPasswordController
                obscureText: authController.isPasswordObscure.value,
                onPressed: () {
                  authController.isPasswordObscure.value = !authController.isPasswordObscure.value;
                },
              )),

              SizedBox(height: 20),
              // Adjusted for confirm password visibility
              Obx(() => buildTextField(
                'Confirm Password',
                authController.confirmPasswordController, // Adjusted variable name: confirmPasswordController
                obscureText: authController.isConfirmPasswordObscure.value,
                onPressed: () {
                  authController.isConfirmPasswordObscure.value = !authController.isConfirmPasswordObscure.value;
                },
              )),
              SizedBox(height: 28),
              ElevatedButton(
                onPressed: () {
                  authController.registerUser();  // Registration method
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
                  'Register',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff272727),
                    ),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => LoginScreen());
                    },
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {bool obscureText = false, Function()? onPressed}) {
    return Container(
      child: Material(
        color: Color(0xfff2f2f2),
        elevation: 3,
        borderRadius: BorderRadius.circular(10),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 9),
            suffixIcon: obscureText
                ? IconButton(
              onPressed: onPressed,
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
            )
                : null,
          ),
        ),
      ),
    );
  }
}
