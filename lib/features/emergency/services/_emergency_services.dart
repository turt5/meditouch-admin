import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/_emergency_service_model.dart';

class EmergencyServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<int> getPendingEmergencyRequests() {
    return _firestore
        .collection('emergencies')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }


  Stream<List<EmergencyServiceModel>> getEmergencyRequests() {
    return _firestore.collection('emergencies').snapshots().asyncMap((snapshot) async {
      List<EmergencyServiceModel> emergencyRequests = [];

      for (var emergency in snapshot.docs) {
        final userId = emergency.data()['userId'];

        // Fetch user info for each emergency
        final userDoc = await _firestore.collection('db_client_user_userinfo').doc(userId).get();

        if (userDoc.exists) {
          final userData = userDoc.data()!;
          final emergencyModel = EmergencyServiceModel.fromMap(
            {
              'userId': userId,
              'service': emergency.data()['service'],
              'status': emergency.data()['status'],
              'image': userData['image'],
              'name': userData['name'],
              'requestTime': emergency.data()['requestTime'],
              'email': userData['email'],
              'phone': userData['phone'],
              'location': emergency.data()['location'] ?? {},
            },
            emergency.id,
          );
          emergencyRequests.add(emergencyModel);
        }
      }

      return emergencyRequests;
    });
  }

  Future<void> updateEmergencyRequestStatus(String requestId, String status) {
    return _firestore.collection('emergencies').doc(requestId).update({'status': status});
  }
}
