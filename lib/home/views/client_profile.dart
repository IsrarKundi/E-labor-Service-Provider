import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class ClientDetailsScreen extends StatelessWidget {
  final String clientId;

  ClientDetailsScreen({required this.clientId});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    // Fetch client details when screen loads
    homeController.fetchClientDetails(clientId);

    return Scaffold(
      appBar: AppBar(
        title: Text("Client Details"),
      ),
      body: Obx(() {
        if (homeController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final client = homeController.clientData['client'];
        final reviews = homeController.clientData['reviews'] ?? [];

        if (client == null) {
          return Center(child: Text("Client details not available."));
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the profile image at the top in a large size
                Center(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      client['image'] ?? 'https://via.placeholder.com/150',
                    ),
                    radius: 70, // Large radius for a bigger profile image
                  ),
                ),
                SizedBox(height: 20),

                // Display client details
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(client['name'] ?? 'Unknown',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text("Contact: ${client['contact'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
                      Text("Rating: ${client['averageRating'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Display reviews
                Text("Reviews:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          review['reviewerId']['image'] ?? 'https://via.placeholder.com/50',
                        ),
                      ),
                      title: Text(review['reviewerId']['name'] ?? 'Anonymous'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Rating: ${review['rating']}"),
                          Text(review['review'] ?? 'No review text'),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
