import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Guardar el UID en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userUID', userCredential.user!.uid);

      return userCredential.user;
    } catch (e) {
      print('Error during sign-in: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();

    // Eliminar el UID de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userUID');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('userUID');
  }
}
