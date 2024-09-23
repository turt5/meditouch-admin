import 'package:hive/hive.dart';

part 'person.g.dart';  // The generated adapter file

@HiveType(typeId: 0)
class Person {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phone;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String gender;

  @HiveField(5)
  final String dob;

  @HiveField(6)
  final String imageUrl;

  @HiveField(7)
  final String role;

  Person({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.gender,
    required this.dob,
    required this.imageUrl,
    required this.role,
  });

}
