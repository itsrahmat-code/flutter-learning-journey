import 'package:equatable/equatable.dart';

// The base abstract class for all authentication states.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// 1. Initial State: The app is starting up, or authentication status is unknown.
class AuthInitial extends AuthState {}

// 2. Loading State: An operation (login, sign-up) is currently in progress.
class AuthLoading extends AuthState {}

// 3. Success State (General): An operation completed successfully (e.g., password reset email sent).
class AuthSuccess extends AuthState {
  final String message;

  const AuthSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// 4. Failure State: An authentication operation failed.
class AuthFailure extends AuthState {
  final String error;

  const AuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// 5. 🌟 FIX for BLoC Emit Error: State indicating the user is logged in.
// This state carries the user ID or token to prove authentication.
class AuthAuthenticated extends AuthState {
  final String userId;
  // You might also include a User model here: final UserModel user;

  const AuthAuthenticated(this.userId);

  @override
  List<Object?> get props => [userId];
}

// 6. Optional: State indicating the user is explicitly logged out.
class AuthUnauthenticated extends AuthState {}