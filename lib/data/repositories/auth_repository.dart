import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Box<UserModel> _userBox = Hive.box<UserModel>('user');

  // Sign Up User
  Future<UserModel?> signUp(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel user = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
      );

      // Store in Firestore & Hive
      await _firestore.collection('users').doc(user.uid).set(user.toJson());
      _userBox.put('current_user', user); // Store offline

      return user;
    } catch (e) {
      print("Sign Up Error: $e");
      return null;
    }
  }

  // Login User
  Future<UserModel?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(userCredential.user!.uid).get();

      if (userDoc.exists) {
        UserModel user = UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
        _userBox.put('current_user', user); // Store offline
        return user;
      }
      return null;
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  // Get Current User (Offline First)
  UserModel? getCurrentUser() {
    return _userBox.get('current_user'); // Get from Hive
  }

  // Logout User
  Future<void> logout() async {
    await _auth.signOut();
    _userBox.delete('current_user'); // Remove from Hive
  }
}
