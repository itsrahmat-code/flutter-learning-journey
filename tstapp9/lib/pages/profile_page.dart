// lib/pages/profile_page.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tstapp9/controller/auth_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Handle case where user is not logged in
      return const Scaffold(
        body: Center(child: Text("User not logged in.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        // Fetch the user document from Firestore
        future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("User data not found"));
          }

          // Get the user data
          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // --- Profile Picture ---
                CircleAvatar(
                  radius: 70,
                  backgroundImage: userData['photoUrl'] != null && userData['photoUrl'].isNotEmpty
                      ? NetworkImage(userData['photoUrl'])
                      : const AssetImage('assets/default_avatar.png') as ImageProvider, // Add a default avatar asset
                  child: userData['photoUrl'] == null || userData['photoUrl'].isEmpty
                      ? const Icon(Icons.person, size: 70, color: Colors.white)
                      : null,
                ),
                const SizedBox(height: 20),

                // --- User Details ---
                buildDetailCard(Icons.person, 'Name', userData['name'] ?? 'N/A'),
                buildDetailCard(Icons.email, 'Email', userData['email'] ?? 'N/A'),
                buildDetailCard(Icons.phone, 'Phone', userData['phone'] ?? 'N/A'),

                const Spacer(),

                // --- Logout Button ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Use GetX to find the controller and logout
                      Get.find<AuthController>().logout();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Logout', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper widget to build detail cards
  Widget buildDetailCard(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade700),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}