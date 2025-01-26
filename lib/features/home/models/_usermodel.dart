import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userId;
  String userName;
  String userEmail;
  String userPhone;
  String userImage;
  String userDob;
  String userGender;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.userImage,
    required this.userDob,
    required this.userGender,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      userId: doc.id,
      userName: data['name'] as String,
      userEmail: data['email'] as String,
      userPhone: data['phone'] as String,
      userImage: data['image'] as String,
      userDob: data['dob'] as String,
      userGender: data['gender'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'userImage': userImage,
      'userDob': userDob,
      'userGender': userGender,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.userId == userId &&
        other.userName == userName &&
        other.userEmail == userEmail &&
        other.userPhone == userPhone &&
        other.userImage == userImage &&
        other.userDob == userDob &&
        other.userGender == userGender;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
    userName.hashCode ^
    userEmail.hashCode ^
    userPhone.hashCode ^
    userImage.hashCode ^
    userDob.hashCode ^
    userGender.hashCode;
  }
}