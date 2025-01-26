class AgentModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String dob;
  final String address;
  final String gender;
  final String imageUrl;

  AgentModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.dob,
    required this.address,
    required this.gender,
    required this.imageUrl,
  });

  factory AgentModel.fromJson(Map<String, dynamic> json) {
    return AgentModel(
      id: json['uid'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      dob: json['dob'],
      address: json['address'],
      gender: json['gender'],
      imageUrl: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'dob': dob,
      'address': address,
      'gender': gender,
      'imageUrl': imageUrl,
    };
  }
}
