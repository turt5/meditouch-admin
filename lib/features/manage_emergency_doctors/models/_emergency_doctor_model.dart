import 'package:meditouch_admin/features/manage_doctors/models/_degree.dart';

class EmergencyDoctorModel {
  final String id;
  final int charge;
  // final DateTime createdAt;
  final List<EmergencyDegree> degrees;
  final String district;
  final DateTime dob;
  final String email;
  final String gender;
  final String image;
  final String name;
  final String phone;
  final String role;
  final String speciality;

  EmergencyDoctorModel({
    required this.id,
    required this.charge,
    // required this.createdAt,
    required this.degrees,
    required this.district,
    required this.dob,
    required this.email,
    required this.gender,
    required this.image,
    required this.name,
    required this.phone,
    required this.role,
    required this.speciality
  });

  factory EmergencyDoctorModel.fromMap(Map<String, dynamic> data, String documentId) {
    final int charge = data['charge'];
    // final DateTime createdAt = DateTime.parse(data['createdAt']);
    final List<EmergencyDegree> degrees = (data['degrees'] as List<dynamic>?)?.map((degreeMap) => EmergencyDegree.fromMap(degreeMap)).toList() ?? [];
    final String district = data['district'];
    final DateTime dob = data['dob'].toDate();
    final String email = data['email'];
    final String gender = data['gender'];
    final String image = data['image'];
    final String name = data['name'];
    final String phone = data['phone'];
    final String role = data['role'];
    final String speciality = data['speciality'];

    return EmergencyDoctorModel(
        id: documentId,
        charge: charge,
        // createdAt: createdAt,
        degrees: degrees,
        district: district,
        dob: dob,
        email: email,
        gender: gender,
        image: image,
        name: name,
        phone: phone,
        role: role,
        speciality: speciality
    );
  }


}


class EmergencyDegree{
  final String degree;
  final String institution;
  final String year;

  EmergencyDegree({required this.degree, required this.institution, required this.year}); 

  factory EmergencyDegree.fromMap(Map<String, dynamic> data){
    final degree = data['degree'];
    final institution = data['institution'];
    final year = data['year'];
    return EmergencyDegree(degree: degree, institution: institution, year: year);
  }

  Map<String, dynamic> toMap(){
    return {'degree': degree, 'institution': institution, 'year': year};
  }
}