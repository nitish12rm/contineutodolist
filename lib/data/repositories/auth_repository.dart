import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Check if the user is already logged in (Firebase + SharedPreferences)
  Future<UserModel?> getCurrentUser() async {
    User? firebaseUser = _firebaseAuth.currentUser;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedin = prefs.getBool('isLoggedin') ?? false;

    if (firebaseUser != null && isLoggedin) {
      return UserModel(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? '',
        email: firebaseUser.email ?? '',
      );
    }
    return null;
  }

  /// Sign Up - Registers user on Firebase
  Future<UserModel?> signUp(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update the user's display name in Firebase
      await userCredential.user!.updateDisplayName(name);

      UserModel user = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
      );

      // Save user credentials in SharedPreferences
      await _saveUserCredentials(user, password);

      return user;
    } catch (e) {
      print("Error during signup: $e");
      return null;
    }
  }

  /// Login - Authenticates user with Firebase
  Future<UserModel?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel user = UserModel(
        id: userCredential.user!.uid,
        name: userCredential.user!.displayName ?? '',
        email: email,
      );

      // Save user credentials in SharedPreferences
      await _saveUserCredentials(user, password);

      return user;
    } catch (e) {
      print("Firebase login failed: $e");
      return null;
    }
  }

  /// Logout - Signs out the user from Firebase
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    // Clear user credentials from SharedPreferences
    await _clearUserCredentials();
  }

  /// Reset Password via Firebase
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Error sending reset email: $e");
    }
  }

  /// Save user credentials in SharedPreferences
  Future<void> _saveUserCredentials(UserModel user, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', user.email);
    await prefs.setString('password', password);
    await prefs.setBool('isLoggedin', true);
    await prefs.setString('userid', user.id);
    await prefs.setString('name', user.name); // Save the user's name
  }

  /// Retrieve user credentials from SharedPreferences
  Future<Map<String, String>?> _getUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    String? name = prefs.getString('name');
    String? userid = prefs.getString('userid');

    if (email != null && password != null) {
      return {
        'email': email,
        'password': password,
        'name': name ?? '',
        'userid': userid ?? '',
      };
    }
    return null;
  }

  /// Clear user credentials from SharedPreferences
  Future<void> _clearUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('userid');
    await prefs.remove('name'); // Clear the user's name
    await prefs.setBool('isLoggedin', false);
  }

  /// Auto-login using saved credentials
  Future<UserModel?> autoLogin() async {
    Map<String, String>? credentials = await _getUserCredentials();
    if (credentials != null) {
      try {
        return await login(credentials['email']!, credentials['password']!);
      } catch (e) {
        print("Auto-login failed: $e");
        await _clearUserCredentials(); // Clear invalid credentials
      }
    }
    return null;
  }
}