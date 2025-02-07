class UserModel {
  String uid;
  String name;
  String email;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
  });

  // Convert User object to JSON (for Firebase Firestore)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
    };
  }

  // Create User object from JSON (for Firebase Firestore)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
    );
  }
}
