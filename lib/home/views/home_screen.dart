import 'package:e_labors/authentication/controller/authentication_controller.dart';
import 'package:e_labors/profile/controllers/profile_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:latlong2/latlong.dart';

import '../../helper/customcard.dart';
import '../controllers/home_controller.dart';
import 'jobs_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    final ProfileController profileController = Get.put(ProfileController());

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xffffa45b)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 22, right: 22),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Center(
                      child: Image.asset('images/logo.png', height: 33),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location',
                            style: TextStyle(color: Colors.grey[800], fontSize: 16),
                          ),
                          Text(
                            'Saddar, Peshawar',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                        CircleAvatar(
                        radius: 30.0,
                        backgroundImage: profileController.imageUrl.isNotEmpty
                            ? NetworkImage(profileController.imageUrl.value) // Load from network if URL is available
                        // : profileController.profileImage.value != null
                        // ? FileImage(profileController.profileImage.value!) // Load from file if picked image is available
                            : AssetImage('images/person.png') as ImageProvider, // Default asset image if both are null
                        backgroundColor: Colors.grey,
                      ),
                        ],
                      ),
                    ],
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(top: 22, bottom: 22),
                  //   child: Material(
                  //     color: Color(0xfff2f2f2),
                  //     elevation: 0,
                  //     borderRadius: BorderRadius.circular(10),
                  //     child: TextField(
                  //       textAlignVertical: TextAlignVertical.center,
                  //       decoration: InputDecoration(
                  //         prefixIcon: const Icon(Icons.search),
                  //         hintText: 'Search here...',
                  //         border: InputBorder.none,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(height: 12,),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 0.7377,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 26, 0, 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Explore Jobs',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Explore jobs in your area',
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      Get.to(() => JobsScreen());
                                      homeController.fetchJobs();
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    label: Text('View All', style: TextStyle(color: Colors.black)),
                                    style: ButtonStyle(
                                      side: MaterialStateProperty.all(BorderSide(color: Colors.black, width: 2.0)),
                                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                      padding: MaterialStateProperty.all(EdgeInsets.only(left: 4, right: 8, top: 0, bottom: 0)),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        // Use FutureBuilder to wait for location data
                        FutureBuilder<void>(
                          future: Future.wait([
                            homeController.getLocation(), // Fetch user's location
                            homeController.fetchClientLocation(), // Fetch client's location
                          ]), // Ensure both locations are fetched
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Column(
                                children: [
                                  SizedBox(height: 170,),
                                  Center(child: CircularProgressIndicator(
                                    strokeWidth: 5,
                                    color: Color(0xffffa45b),
                                  ))
                                ],
                              ); // Show loading indicator while fetching data
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error fetching locations'));
                            } else {
                              // Extract client location data
                              final clientLat = homeController.clientLocation['lat'] as double?;
                              final clientLng = homeController.clientLocation['lng'] as double?;
                              // final clientName = homeController.clientLocation['name'] as String?;
                              // final clientImage = homeController.clientLocation['image'] as String?;

                              return Expanded(
                                child: FlutterMap(
                                  options: MapOptions(
                                    initialCenter: LatLng(
                                      homeController.location.latitude,
                                      homeController.location.longitude,
                                    ),
                                    initialZoom: 14.0, // Set a reasonable zoom level
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      subdomains: ['a', 'b', 'c'],
                                    ),
                                    MarkerLayer(
                                      markers: [
                                        // User Location Marker
                                        Marker(
                                          point: LatLng(
                                            homeController.location.latitude,
                                            homeController.location.longitude,
                                          ),
                                          child: Icon(
                                            Icons.person_pin_circle,
                                            color: Colors.blue,
                                            size: 35,
                                          ),
                                        ),
                                        // Client Location Marker
                                        if (clientLat != null && clientLng != null)
                                          Marker(
                                            point: LatLng(clientLat, clientLng),
                                            child:  Icon(
                                              Icons.home_work,
                                              color: Colors.red,
                                              size: 30,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
