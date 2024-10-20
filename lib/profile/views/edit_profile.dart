import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the AuthenticationController
    final ProfileController profileController = Get.put(ProfileController());

    return Scaffold(
      resizeToAvoidBottomInset: true, // Add this line
      appBar: AppBar(
        title: Center(
          child: Image.asset('images/logo.png', height: 40),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 20 : 120),
              // Adjust the height based on keyboard visibility
              Container(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    // Circle Avatar with the person icon
                    Positioned(
                      child: Obx(() {
                        return CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 50,
                          child: profileController.profileImage.value != null
                              ? ClipOval(
                            child: Image.file(
                              profileController.profileImage.value!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                              : FittedBox(
                            child: Icon(
                              Icons.person,
                              size: 100,
                              color: Colors.white,
                            ),
                            fit: BoxFit.cover,
                          ),
                        );
                      }),
                    ),
                    // Positioned edit icon at the bottom right of the CircleAvatar
                    Positioned(
                      bottom: 0,
                      left: 64,
                      child: GestureDetector(
                        onTap: () {
                          profileController.pickImage(context);
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.blue, // Background color for the edit icon container
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white, // Optional: white border around the icon
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.edit, // Icon for edit (pen)
                            color: Colors.white,
                            size: 18, // Adjust the icon size
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              // TextFields for email and password using the controller
              buildTextField('Enter Your Name', profileController.nameController),
              SizedBox(height: 20),
              buildTextField('Enter Your Phone Number', profileController.contactController),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  profileController.editProfile(context);
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
                  'Update',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Container(
      child: Material(
        color: Color(0xfff2f2f2),
        elevation: 3,
        borderRadius: BorderRadius.circular(10),
        child: TextFormField(
          controller: controller,
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
