import 'package:bm_binus/data/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState(isAuthenticated: false)) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) {
    final user = DetailUser.firstWhere(
      (u) => u.email == event.email && u.password == event.password,
      orElse: () => Users(email: '', password: '', role: ''),
    );

    if (user.email.isNotEmpty) {
      emit(
        AuthState(isAuthenticated: true, role: user.role, email: user.email),
      );
    } else {
      emit(
        const AuthState(
          isAuthenticated: false,
          error: 'Email atau password salah',
        ),
      );
    }
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) {
    emit(const AuthState(isAuthenticated: false));
  }
}
