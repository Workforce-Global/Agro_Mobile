import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Password visibility
  final RxBool obscurePassword = true.obs;
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // Login form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // ✅ Getter for current Firebase user
  User? get firebaseUser => _auth.currentUser;

  // ✅ Firebase auth state listener
  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen(_handleAuthStateChanged);
  }

  void _handleAuthStateChanged(User? user) {
    if (user == null) {
      // Not logged in
      Get.offAllNamed('/login');
    } else {
      final displayName = user.displayName ?? '';
      final parts = displayName.split(' ');
      final firstName = parts.isNotEmpty ? parts[0] : '';
      final lastName = parts.length > 1 ? parts[1] : '';

      Get.offAllNamed('/welcome', arguments: {
        'firstName': firstName,
        'lastName': lastName,
      });
    }
  }

  // ✅ Email login
  Future<void> loginWithEmail() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } catch (e) {
      Get.snackbar('Login Failed', e.toString());
    }
  }

  // ✅ Sign up
  Future<void> signUp({
  required String email,
  required String password,
  required String firstName,
  required String lastName,
}) async {
  try {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Save display name for future use
    await userCredential.user?.updateDisplayName('$firstName $lastName');

    // Redirect to welcome screen with name args
    Get.offAllNamed('/welcome', arguments: {
      'firstName': firstName,
      'lastName': lastName,
    });
  } catch (e) {
    Get.snackbar('Signup Failed', e.toString());
  }
}


  // ✅ Google sign in
  Future<void> signInWithGoogle() async {
  try {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in with Firebase
    final userCredential = await _auth.signInWithCredential(credential);

    // Optionally save user info to Firestore or SharedPreferences
    final displayName = userCredential.user?.displayName ?? '';
    final nameParts = displayName.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
    final lastName = nameParts.length > 1 ? nameParts[1] : '';

    // Example: Store in SharedPreferences if needed
    // await SharedPrefsService.saveName(firstName, lastName);

    // Navigate to WelcomeScreen
    Get.offAllNamed('/welcome');
  } catch (e) {
    Get.snackbar('Google Sign-In Failed', e.toString());
  }
}

}
