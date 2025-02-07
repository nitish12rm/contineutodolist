import 'package:hive/hive.dart';

part 'user_model.g.dart'; // Required for code generation

@HiveType(typeId: 0) // Unique type ID for Hive
class UserModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String password; // Store hashed password in real applications

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
