import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// You will need to import your login and signup pages if you use MaterialPageRoute
// import 'login_page.dart';
// import 'signup_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Smart Task Manager",
          style: TextStyle(fontSize: 20.sp),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(30.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Message
              Text(
                "Welcome to Smart Task Manager",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50.h),

              // 1. Login Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Navigate to the Login Page
                  // RECOMMENDED: Use named routes for scalable navigation:
                  // Navigator.pushNamed(context, '/login');

                  // ALTERNATIVE (using direct MaterialPageRoute, assuming you import login_page.dart):
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const LoginPage()),
                  // );
                },
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 18.sp, color: Colors.white),
                ),
              ),
              SizedBox(height: 20.h),

              // 2. Sign Up Button
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  foregroundColor: Colors.blueAccent,
                  side: const BorderSide(color: Colors.blueAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Navigate to the Sign-up Page
                  // RECOMMENDED: Use named routes for scalable navigation:
                  // Navigator.pushNamed(context, '/signup');

                  // ALTERNATIVE (using direct MaterialPageRoute, assuming you import signup_page.dart):
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const SignupPage()),
                  // );
                },
                child: Text(
                  "Create Account",
                  style: TextStyle(fontSize: 18.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}