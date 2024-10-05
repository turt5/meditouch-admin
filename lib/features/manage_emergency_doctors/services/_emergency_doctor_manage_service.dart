import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meditouch_admin/features/manage_emergency_doctors/models/_emergency_doctor_model.dart';

class EmergencyDoctorManageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<EmergencyDoctorModel>> getEmergencyDoctors() {
    return _firestore.collection('emergency_doctors').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => EmergencyDoctorModel.fromMap(doc.data(), doc.id))
            .toList());
  }
}
