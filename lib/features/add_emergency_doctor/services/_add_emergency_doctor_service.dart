import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyDoctorService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addEmergencyDoctor(Map<String,dynamic> data) async{
    await _firestore.collection('emergency_doctors').add(data);
  }
}