import 'package:bm_binus/core/services/api_service.dart';
import 'package:bm_binus/core/services/storage_service.dart';
import 'package:bm_binus/data/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState(isAuthenticated: false, isSendForgot: false)) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthSession>(_onCheckAuthSession);
    on<ForgotPasswordRequested>(_onForgotPasswordRequest);
    on<ResetForgotPasswordState>((event, emit) {
      emit(state.copyWith(
        isSendForgot: false,
        errorForgot: null,
      ));
    });
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    try {
      final response = await ApiService.authLogin(event.email, event.password);

      if (response != null && response['success'] == true) {
        final token = response['data']['token'];
        final responseData = response['data'];
        final user = User.fromJson(responseData);
        StorageService.setToken(token);
        emit(
          AuthState(isAuthenticated: true, isSendForgot: false, id: user.id, name: user.name, email: user.email, roleId: user.roleId, roleName: user.roleName),
        );
      } else {
        if (response != null && response['data'] != null) {
          final message = response['data']?['message'] ?? 'Terjadi kesalahan yang tidak diketahui';
          final translatedMessage = message == 'email or password is incorrect'
              ? 'Email atau password salah!'
              : message.contains('too many login attempts')
                  ? (() {
                      final regex = RegExp(r'retry after (\d+) seconds');
                      final match = regex.firstMatch(message);
                      if (match != null) {
                        final seconds = match.group(1);
                        return 'Terlalu banyak percobaan login, \nCoba lagi setelah $seconds detik.';
                      }
                      return 'Terlalu banyak percobaan login, \nCoba lagi beberapa saat lagi.';
                    })()
                  : message == 'error validate payload'
                  ? 'Masukkan Email dan Password!'
                  : message;
          emit(
            AuthState(
              isAuthenticated: false,
              isSendForgot: false,
              error: translatedMessage,
            ),
          );
        } else {
          emit(
            AuthState(
              isAuthenticated: false,
              isSendForgot: false,
              error: response?['message'] ?? 'Terjadi kesalahan yang tidak diketahui',
            ),
          );
        }
      }
    } catch (e) {
      emit(
        AuthState(
          isSendForgot: false,
          isAuthenticated: false,
          error: '$e',
        ),
      );
    }
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) {
    ApiService.authLogout();
    emit(const AuthState(isAuthenticated: false, isSendForgot: false));
  }

  Future<void> _onCheckAuthSession(CheckAuthSession event, Emitter<AuthState> emit) async {
    final token = StorageService.getToken();
    if (token != null && token.isNotEmpty) {
      try {
        final response = await ApiService.userInfo(token);

        if (response != null && response['success'] == true) {
          final responseData = response['data'];
          final user = User.fromJson(responseData);
          emit(state.copyWith(isAuthenticated: true, isSendForgot: false, id: user.id, name: user.name, email: user.email, roleId: user.roleId, roleName: user.roleName));
        } else {
          if (response != null && response['data'] != null) {
            StorageService.clearToken();
            emit(
              state.copyWith(
                isSendForgot: false,
                isAuthenticated: false,
              ),
            );
          } else {
            StorageService.clearToken();
            emit(
              state.copyWith(
                isSendForgot: false,
                isAuthenticated: false,
              ),
            );
          }
        }
      } catch (e) {
        StorageService.clearToken();
        emit(
          state.copyWith(
            isSendForgot: false,
            isAuthenticated: false,
          ),
        );
      }
    } else {
      StorageService.clearToken();
      emit(state.copyWith(isAuthenticated: false, isSendForgot: false));
    }
  }

  Future<void> _onForgotPasswordRequest(ForgotPasswordRequested event, Emitter<AuthState> emit) async {
    try {
      final response = await ApiService.sendForgotPasswordEmail(event.email);
      if (response != null && response['success'] == true) {
        emit(AuthState(isAuthenticated: false, isSendForgot: true));
      } else {
        emit(
          AuthState(
            isAuthenticated: false,
            isSendForgot: false,
            errorForgot: "Email Tidak Terdaftar.",
          ),
        );
      }
    } catch (e) {
      emit(
        AuthState(
          isAuthenticated: false,
          isSendForgot: false,
          errorForgot: '$e',
        ),
      );
    }
  }
}
