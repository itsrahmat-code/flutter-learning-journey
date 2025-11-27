import 'dart:async';

class AuthService {
  Future<String> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 2));

    if (email == "test@test.com" && password == "123456") {
      return "Login successful!";
    } else {
      throw "Invalid credentials!";
    }
  }

  Future<String> signup(String name, String email, String password) async {
    await Future.delayed(Duration(seconds: 2));

    if (email == "test@test.com") {
      throw "Email already exists!";
    }

    return "Signup successful!";
  }
}
