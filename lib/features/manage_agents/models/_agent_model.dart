class AgentModel{
  final String id;
  final String name;
  final String email;
  final String phone;
  final String dob;
  final String address;
  final String gender;
  final String imageUrl;
  final String role;


  AgentModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.dob,
    required this.address,
    required this.gender,
    required this.imageUrl,
    required this.role,
  });


  factory AgentModel.fromJson(Map<String, dynamic> json, String id){
    return AgentModel(
      id: id,
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      dob: json['dob'],
      address: json['address'],
        gender: json['gender'],
        imageUrl: json['imageUrl'],
        role: json['role']
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
      'role': role
    };
  }

}