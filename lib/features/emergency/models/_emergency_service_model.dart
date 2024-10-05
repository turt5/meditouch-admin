import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyServiceModel {
  final String emergencyId;
  final String userId;
  final String service;
  final String status;
  final String image;
  final String name;
  final String phone;
  final String email;
  final Timestamp requestTime;
  final double latitude; // Add latitude field
  final double longitude; // Add longitude field

  EmergencyServiceModel({
    required this.emergencyId,
    required this.userId,
    required this.service,
    required this.status,
    required this.image,
    required this.name,
    required this.phone,
    required this.email,
    required this.requestTime,
    required this.latitude, // Initialize latitude
    required this.longitude, // Initialize longitude
  });

  factory EmergencyServiceModel.fromMap(Map<String, dynamic> data, String emergencyId) {
    return EmergencyServiceModel(
      emergencyId: emergencyId,
      userId: data['userId'],
      service: data['service'],
      status: data['status'],
      image: data['image'],
      name: data['name'],
      phone: data['phone'],
      email: data['email'],
      requestTime: data['requestTime'],
      latitude: data['location']['latitude'] ?? 0.0, // Get latitude from the nested map, with a default value
      longitude: data['location']['longitude'] ?? 0.0, // Get longitude from the nested map, with a default value
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'service': service,
      'status': status,
      'image': image,
      'name': name,
      'phone': phone,
      'email': email,
      'requestTime': requestTime,
      'location': { // Include the location map
        'latitude': latitude,
        'longitude': longitude,
      },
    };
  }
}
