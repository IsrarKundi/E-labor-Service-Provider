import 'package:e_labors/profile/views/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset('images/logo.png', height: 33,),
        ),
      ),
      body:
      Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(

            children: [
              Text('My Profile',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24
                ),
              ),
              SizedBox(height: 16,),
              SizedBox(
                height: 100,
                width: 100,
                child: FittedBox(
                  child: Obx(() {
                    return CircleAvatar(
                      radius: 30.0,
                      backgroundImage: profileController.profileImageUrl.isNotEmpty
                          ? NetworkImage(profileController.profileImageUrl.value) // Load from network if URL is available
                          : profileController.profileImage.value != null
                          ? FileImage(profileController.profileImage.value!) // Load from file if picked image is available
                          : AssetImage('images/person.png') as ImageProvider, // Default asset image if both are null
                      backgroundColor: Colors.grey,
                    );
                  }),

                ),
              ),
              SizedBox(height: 8,),
              Obx((){
                return Text(
                  profileController.name.value,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }),
              SizedBox(height: 0,),
              Obx((){
                return Text(
                  profileController.email.value,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600]
                  ),
                );
              }),
              SizedBox(height: 12,),
              OutlinedButton(
                onPressed: () {
                  Get.to(() => EditProfile());

                },
                child: Text('Edit Profile', style: TextStyle(color: Color(0xfff67322))),
                style: ButtonStyle(
                  side: MaterialStateProperty.all(BorderSide(color: Color(0xfff67322), width: 2.0)),
                  backgroundColor: MaterialStateProperty.all(Color(0xfffef1e9)),
                  padding: MaterialStateProperty.all(EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 26,),
              ProfileScreenButton(buttonIcon: Icons.settings, buttonLabel: 'Setting'),
              SizedBox(height: 26,),
              ProfileScreenButton(buttonIcon: Icons.help, buttonLabel: 'Help'),
              SizedBox(height: 26,),
              ProfileScreenButton(buttonIcon: Icons.logout, buttonLabel: 'Logout')
            ],
          ),
        ),
      ),

    );
  }
}

class ProfileScreenButton extends StatelessWidget {
  ProfileScreenButton({super.key, required this.buttonIcon, required this.buttonLabel});

  final IconData buttonIcon;
  final String buttonLabel;

  @override
  Widget build(BuildContext context) {
    return Card(

      color: Color(0xfffef1e9),
      child: Padding(
        padding: EdgeInsets.all(14.0),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Color(0xfff67322),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                buttonIcon,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 32,),
            Expanded(
              child: Text(
                buttonLabel,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
