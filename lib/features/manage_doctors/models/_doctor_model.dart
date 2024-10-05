import 'package:cloud_firestore/cloud_firestore.dart';

import '_degree.dart';

class DoctorModel {
  final String id;
  final String name;
  final String email;
  final String gender;
  final String phone;
  final String licenceId;
  final String speciality;
  final String district;
  final DateTime dob;
  final List<Degree> degrees;
  final String image;
  final DateTime createdAt;
  final List<String> timeSlots;
  final int visitFee;
  final String role;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.phone,
    required this.licenceId,
    required this.speciality,
    required this.district,
    required this.dob,
    required this.degrees,
    required this.image,
    required this.createdAt,
    required this.timeSlots,
    required this.visitFee,
    required this.role,
  });

  // Serialize to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'gender': gender,
      'phone': phone,
      'licenceId': licenceId,
      'speciality': speciality,
      'district': district,
      'dob': dob.toIso8601String(),
      'degrees': degrees.map((degree) => degree.toMap()).toList(),
      'image': image,
      'createdAt': createdAt.toIso8601String(),
      'timeSlots': timeSlots,
      'visitFee': visitFee,
      'role':role
    };
  }

  // Deserialize from Firestore Map
  factory DoctorModel.fromMap(Map<String, dynamic> map, String documentId) {
    return DoctorModel(
      id: documentId, // Using document ID as the id field
      name: map['name'],
      email: map['email'],
      gender: map['gender'],
      phone: map['phone'],
      licenceId: map['licenceId'],
      speciality: map['speciality'],
      district: map['district'],
      dob: (map['dob'] is Timestamp) ? map['dob'].toDate() : DateTime.now(), // Handle potential nulls
      degrees: (map['degrees'] as List<dynamic>?)?.map((degreeMap) => Degree.fromMap(degreeMap)).toList() ?? [], // Default to an empty list
      image: map['image'],
      createdAt: DateTime.parse(map['createdAt']),
      timeSlots: List<String>.from(map['timeSlots'] ?? []), // Default to an empty list
      visitFee: map['visitingFee'], // Handle potential null or invalid values
      role: map['role']
    );
  }


  // Override == operator for object comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DoctorModel &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.gender == gender &&
        other.phone == phone &&
        other.licenceId == licenceId &&
        other.speciality == speciality &&
        other.district == district &&
        other.dob == dob &&
        _compareDegrees(other.degrees, degrees) &&
        other.image == image &&
        other.createdAt == createdAt &&
        _compareLists(other.timeSlots, timeSlots) &&
        other.visitFee == visitFee &&
        other.role == role;
  }

  // Override hashCode for unique object identification
  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    email.hashCode ^
    gender.hashCode ^
    phone.hashCode ^
    licenceId.hashCode ^
    speciality.hashCode ^
    district.hashCode ^
    dob.hashCode ^
    degrees.hashCode ^
    image.hashCode ^
    createdAt.hashCode ^
    timeSlots.hashCode ^
    visitFee.hashCode ^
    role.hashCode;
  }

  // Helper function to compare two lists of Degrees
  bool _compareDegrees(List<Degree> list1, List<Degree> list2) {
    if (list1.length != list2.length) return false;

    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }

    return true;
  }

  // Helper function to compare two lists of strings
  bool _compareLists(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;

    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }

    return true;
  }
}
