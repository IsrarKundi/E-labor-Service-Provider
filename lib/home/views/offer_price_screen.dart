import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class OfferPriceScreen extends StatelessWidget {
  final String jobId; // Pass job ID as a parameter

  OfferPriceScreen({required this.jobId});

  @override
  Widget build(BuildContext context) {

    final HomeController homeController = Get.put(HomeController());

    late String newTask;
    return Padding(
      padding: const EdgeInsets.only(top: 5, right: 30, left: 30, bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Offer Your Price',
            style: TextStyle(
              color: Color(0xfff67322),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 14,),
          TextField(
            autofocus: true,
            textAlign: TextAlign.center,
            cursorColor: Color(0xfff67322), // Set the cursor color
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xfff67322), width: 2.0), // Bottom border color and width when not focused
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xfff67322), width: 4.0), // Bottom border color and width when focused
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: (newValue) {
              newTask = newValue;
            },
          ),
          SizedBox(height: 36),
          ElevatedButton(
            onPressed: () {
              // Parse the input price to an integer
              int offeredPrice = int.tryParse(newTask) ?? 0;
              if (offeredPrice > 0) {
                Navigator.pop(context);
                // Call the requestJob method
                homeController.requestJob(jobId, offeredPrice).then((_) {
                   // Close the screen after the request
                });
              } else {
                Get.snackbar("Invalid Input", "Please enter a valid price");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xfff67322),
              minimumSize: Size(double.infinity, 50), // Set the height if needed
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Text(
              'Offer',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
