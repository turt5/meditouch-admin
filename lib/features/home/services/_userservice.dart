import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/_usermodel.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<UserModel>> getAllUsers() {
    return _firestore.collection('db_client_user_userinfo').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserModel.fromDocument(doc)).toList();
    });
  }

  Stream<int> getUserCountWithRoleU() {
    return _firestore
        .collection('db_client_user_userinfo')
        .snapshots()
        .map((snapshot) {
      return snapshot.size; // Returns the count of documents that match the query
    });
  }

  Stream<int> getUserCountWithRoleD() {
    return _firestore
        .collection('db_client_doctor_accountinfo')
        .snapshots()
        .map((snapshot) {
      return snapshot.size; // Returns the count of documents that match the query
    });
  }
}