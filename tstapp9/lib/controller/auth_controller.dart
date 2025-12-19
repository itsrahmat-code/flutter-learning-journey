import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;

  /// LOGIN
  Future<void> login() async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value.trim(),
      );
      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Login Failed', e.message ?? 'Error');
    } finally {
      isLoading.value = false;
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed('/login');
  }

  /// REGISTER
  Future<void> register(String confirmPassword) async {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    if (password.value != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    try {
      isLoading.value = true;
      await _auth.createUserWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value.trim(),
      );
      Get.snackbar('Success', 'Registration successful');
      Get.offAllNamed('/login');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Registration Failed', e.message ?? 'Error');
    } finally {
      isLoading.value = false;
    }
  }
}