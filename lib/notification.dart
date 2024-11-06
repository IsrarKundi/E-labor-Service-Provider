import 'package:intl/intl.dart';

class WorkerNotification {
  final String id;
  final String profileImage;
  final String name;
  final String message;
  final String category;
  final bool isRead;
  final DateTime createdAt;
  final String? jobId; // Add jobId to link notifications to specific jobs

  WorkerNotification({
    required this.id,
    required this.profileImage,
    required this.name,
    required this.message,
    required this.category,
    required this.isRead,
    required this.createdAt,
    this.jobId, // Optional to allow for notifications without a job link
  });

  // Computed property to format date as "YYYY-MM-DD hh:mm AM/PM"
  String get formattedCreatedAt {
    final dateFormatter = DateFormat('yyyy-MM-dd hh:mm a');
    return dateFormatter.format(createdAt);
  }

  factory WorkerNotification.fromJson(Map<String, dynamic> json) {
    final dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"); // ISO 8601 with milliseconds
    DateTime parsedDate;

    try {
      parsedDate = dateFormat.parse(json['createdAt'], true).toLocal();
    } catch (e) {
      print('Failed to parse date: $e');
      parsedDate = DateTime.now();
    }

    return WorkerNotification(
      id: json['_id'],
      profileImage: json['senderId']['image'] ?? 'https://via.placeholder.com/150',
      name: json['senderId']['name'] ?? 'Unknown',
      message: json['message'] ?? 'No message',
      category: json['type'] ?? 'Unknown',
      isRead: json['isRead'] ?? false,
      createdAt: parsedDate,
      jobId: json['jobId'], // Add jobId from JSON if it exists
    );
  }
}
