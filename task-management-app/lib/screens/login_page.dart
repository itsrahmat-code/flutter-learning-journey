import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import 'signup_page.dart';
import 'home_screen.dart'; // <<< MUST IMPORT HOME SCREEN

// --- Utility Function for Modern Input Decoration ---
InputDecoration modernInput(String label) {
  return InputDecoration(
    labelText: label,
    filled: true,
    fillColor: Colors.grey.shade100,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.blueAccent, width: 2),
    ),
  );
}
// ----------------------------------------------------

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // FIX: Navigate to the Home Screen and remove all previous routes
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (Route<dynamic> route) => false, // Remove all previous routes
            );
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 50),

                  TextField(
                    controller: emailController,
                    decoration: modernInput("Email"),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),

                  TextField(
                    controller: passController,
                    decoration: modernInput("Password"),
                    obscureText: true,
                  ),
                  const SizedBox(height: 40),

                  if (state is AuthLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                        context.read<AuthBloc>().add(
                          LoginEvent(
                            email: emailController.text.trim(),
                            password: passController.text,
                          ),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignupPage()),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Sign up",
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}