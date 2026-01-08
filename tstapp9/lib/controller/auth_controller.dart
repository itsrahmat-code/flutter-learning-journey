// lib/controller/auth_controller.dart

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- Existing Properties ---
  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;

  // --- NEW Properties for Registration ---
  var name = ''.obs;
  var phone = ''.obs;
  var pickedImagePath = ''.obs; // To store the path of the picked image

  /// LOGIN (No changes needed here)
  Future<void> login() async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value.trim(),
      );
      Get.offAllNamed('/home'); // Or '/profile' if you want to go there first
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Login Failed', e.message ?? 'Error');
    } finally {
      isLoading.value = false;
    }
  }

  /// LOGOUT (No changes needed here)
  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed('/login');
  }

  /// UPDATED REGISTER METHOD
  Future<void> register(String confirmPassword) async {
    // --- Validation ---
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }
    if (password.value != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    try {
      isLoading.value = true;
      // 1. Create user with email and password
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value.trim(),
      );

      String uid = credential.user!.uid;
      String? photoUrl;

      // 2. Upload image if one was picked
      if (pickedImagePath.value.isNotEmpty) {
        photoUrl = await uploadImageToFirebase(File(pickedImagePath.value), uid);
      }

      // 3. Save user data to Firestore
      await saveUserDataToFirestore(uid, photoUrl);

      Get.snackbar('Success', 'Account created successfully!');
      // Navigate to the login page or directly to the home page
      Get.offAllNamed('/login');

    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      Get.snackbar('Registration Failed', e.message ?? 'An unknown error occurred.');
    } finally {
      isLoading.value = false;
    }
  }

  /// NEW: Image Picking Method
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImagePath.value = image.path;
    } else {
      Get.snackbar('No Image Selected', 'Please select an image to continue.');
    }
  }

  /// NEW: Method to Upload Image to Firebase Storage
  Future<String> uploadImageToFirebase(File imageFile, String uid) async {
    try {
      Reference ref = FirebaseStorage.instance.ref().child("profile_images/$uid.jpg");
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      Get.snackbar('Upload Error', 'Failed to upload image: $e');
      // Return a default or empty URL on failure
      return '';
    }
  }

  /// NEW: Method to Save User Data to Firestore
  Future<void> saveUserDataToFirestore(String uid, String? photoUrl) async {
    try {
      await _firestore.collection("users").doc(uid).set({
        "uid": uid,
        "name": name.value.trim(),
        "email": email.value.trim(),
        "phone": phone.value.trim(),
        "photoUrl": photoUrl ?? '', // Save empty string if no photo
        "createdAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      Get.snackbar('Firestore Error', 'Failed to save user data: $e');
    }
  }
}