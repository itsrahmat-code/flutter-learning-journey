import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:tstapp9/pages/home_page.dart';
import 'package:tstapp9/pages/login_page.dart';
import 'package:tstapp9/pages/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SayaraHub',
      home: const LandingPage(),
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/home', page: () => HomePage()),
      ],
    );
  }
}

/// ================= LANDING PAGE =================
class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ===== HEADER SECTION =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 70, bottom: 20, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ✅ 1. PHOTO/LOGO (Now at the top)
                Image.asset(
                  'asset/img/logo.png',
                  height: 80, // Adjusted height for better proportion
                ),
                const SizedBox(height: 10),

                // ✅ 2. TEXT (Under the photo)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Garage",
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Stack(
                      children: [
                        Text(
                          "Hub",
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2
                              ..color = Colors.blueAccent,
                          ),
                        ),
                        const Text(
                          "Hub",
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Description Text
                const Text(
                  "Your All-in-One Auto Service Partner",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),

          const SizedBox(height: 60),

          // ===== CENTER TEXT (UNCHANGED) =====
          Expanded(
            child: Center(
              child: Stack(
                children: [
                  Text(
                    "Find",
                    style: TextStyle(
                      fontSize: 56,
                      fontStyle: FontStyle.italic,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 1.9
                        ..color = Colors.lightBlue,
                    ),
                  ),
                  const Text(
                    "Find",
                    style: TextStyle(
                      fontSize: 56,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ===== BUTTON SECTION (UPDATED 3D DESIGN) =====
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 40.0, top: 20.0),
            child: GestureDetector(
              onTap: () {
                Get.off(() => const AuthWrapper());
              },
              child: Container(
                height: 65,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(22),
                  // This shadow creates the "Coming out of screen" 3D effect
                  boxShadow: [
                    // Bottom-right shadow (darker) - creates depth
                    BoxShadow(
                      color: Colors.blue.shade900.withOpacity(0.4),
                      offset: const Offset(6, 6),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                    // Top-left highlight (lighter) - creates the "pressed/raised" feel
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.8),
                      offset: const Offset(-2, -2),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Let's Go",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= AUTH WRAPPER =================
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return HomePage();
        }
        return LoginPage();
      },
    );
  }
}