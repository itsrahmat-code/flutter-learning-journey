import 'package:equatable/equatable.dart';

// The base class for all authentication events
abstract class AuthEvent extends Equatable {
  // The base class's props list is kept empty,
  // relying on concrete classes to add their fields.
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Event to trigger a login operation
class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  // FIX: Include all fields (email, password) in props
  // so that two LoginEvents with different data are considered unequal.
  @override
  List<Object?> get props => [email, password];
}

// Event to trigger a sign-up operation
class SignupEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const SignupEvent({
    required this.name,
    required this.email,
    required this.password,
  });

  // FIX: Include all fields (name, email, password) in props
  // so that two SignupEvents with different data are considered unequal.
  @override
  List<Object?> get props => [name, email, password];
}