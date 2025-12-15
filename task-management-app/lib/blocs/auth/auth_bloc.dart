import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(AuthInitial()) {
    on<LoginEvent>(_login);
    on<SignupEvent>(_signup);
  }

  Future<void> _login(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final message = await authService.login(event.email, event.password);
      emit(AuthSuccess(message));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _signup(SignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final message =
      await authService.signup(event.name, event.email, event.password);
      emit(AuthSuccess(message));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
