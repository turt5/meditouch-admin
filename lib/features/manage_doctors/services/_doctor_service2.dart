import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/_doctor_model.dart';

class DoctorService2 {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DoctorModel>> getDoctors() async {
    final snapshot =
        await _firestore.collection('db_client_doctor_accountinfo').get();
    return snapshot.docs
        .map((doc) => DoctorModel.fromMap(doc.data(), doc.id))
        .toList();
  }
}
