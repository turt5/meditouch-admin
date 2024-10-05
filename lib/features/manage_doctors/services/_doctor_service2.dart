import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/_doctor_model.dart';

class DoctorService2 {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<DoctorModel>> getDoctors() {
    return _firestore.collection('doctors').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => DoctorModel.fromMap(doc.data(), doc.id))
            .toList());
  }
}
