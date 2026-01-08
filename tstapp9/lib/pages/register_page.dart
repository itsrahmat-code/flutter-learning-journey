// lib/pages/register_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tstapp9/controller/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  // Use Get.put() to initialize the controller
  final AuthController controller = Get.put(AuthController());
  final TextEditingController confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView( // Use SingleChildScrollView to prevent overflow
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // --- Profile Picture Picker ---
              Obx(() {
                return GestureDetector(
                  onTap: controller.pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: controller.pickedImagePath.value.isNotEmpty
                        ? FileImage(File(controller.pickedImagePath.value)) as ImageProvider
                        : null,
                    child: controller.pickedImagePath.value.isEmpty
                        ? const Icon(Icons.person_add_alt_1, size: 60, color: Colors.white)
                        : null,
                  ),
                );
              }),
              const SizedBox(height: 20),

              // --- Name Field ---
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                onChanged: (v) => controller.name.value = v,
              ),
              const SizedBox(height: 16),

              // --- Email Field ---
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                onChanged: (v) => controller.email.value = v,
              ),
              const SizedBox(height: 16),

              // --- Phone Number Field ---
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                onChanged: (v) => controller.phone.value = v,
              ),
              const SizedBox(height: 16),

              // --- Password Field ---
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                onChanged: (v) => controller.password.value = v,
              ),
              const SizedBox(height: 16),

              // --- Confirm Password Field ---
              TextField(
                controller: confirmController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30),

              // --- Register Button ---
              Obx(() => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.register(confirmController.text),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Register'),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}