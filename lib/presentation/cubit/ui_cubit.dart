import 'package:flutter_bloc/flutter_bloc.dart';

class UiState {
  final bool isPasswordObscured;
  final bool isOldPasswordObscured;
  final bool isNewPasswordObscured;
  final bool isConfirmPasswordObscured;
  final bool isLoading;
  final bool isLoadingForgot;
  final bool rememberMe;
  final bool isSidebarCollapsed;

  UiState({
    this.isPasswordObscured = true,
    this.isOldPasswordObscured = true,
    this.isNewPasswordObscured = true,
    this.isConfirmPasswordObscured = true,
    this.isLoading = false,
    this.isLoadingForgot = false,
    this.rememberMe = false,
    this.isSidebarCollapsed = false,
  });

  UiState copyWith({
    bool? isPasswordObscured,
    bool? isOldPasswordObscured,
    bool? isNewPasswordObscured,
    bool? isConfirmPasswordObscured,
    bool? isLoading,
    bool? isLoadingForgot,
    bool? rememberMe,
    bool? isSidebarCollapsed,
  }) {
    return UiState(
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
      isOldPasswordObscured: isOldPasswordObscured ?? this.isOldPasswordObscured,
      isNewPasswordObscured: isNewPasswordObscured ?? this.isNewPasswordObscured,
      isConfirmPasswordObscured: isConfirmPasswordObscured ?? this.isConfirmPasswordObscured,
      isLoading: isLoading ?? this.isLoading,
      isLoadingForgot: isLoadingForgot ?? this.isLoadingForgot,
      rememberMe: rememberMe ?? this.rememberMe,
      isSidebarCollapsed: isSidebarCollapsed ?? this.isSidebarCollapsed,
    );
  }
}

class UiCubit extends Cubit<UiState> {
  UiCubit() : super(UiState());

  void togglePasswordVisibility() =>
      emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));

  void toggleOldPasswordVisibility() =>
      emit(state.copyWith(isOldPasswordObscured: !state.isOldPasswordObscured));

  void toggleNewPasswordVisibility() =>
      emit(state.copyWith(isNewPasswordObscured: !state.isNewPasswordObscured));

  void toggleConfirmPasswordVisibility() =>
      emit(state.copyWith(isConfirmPasswordObscured: !state.isConfirmPasswordObscured));

  void toggleOldPasswordReset() =>
      emit(state.copyWith(isOldPasswordObscured: true));

  void toggleNewPasswordReset() =>
      emit(state.copyWith(isNewPasswordObscured: true));

  void toggleConfirmPasswordReset() =>
      emit(state.copyWith(isConfirmPasswordObscured: true));

  void setLoading(bool value) => emit(state.copyWith(isLoading: value));

  void setLoadingForgot(bool value) => emit(state.copyWith(isLoadingForgot: value));

  void toggleRememberMe() =>
      emit(state.copyWith(rememberMe: !state.rememberMe));

  void toggleSidebar([bool? value]) {
    emit(
      state.copyWith(isSidebarCollapsed: value ?? !state.isSidebarCollapsed),
    );
  }
}
