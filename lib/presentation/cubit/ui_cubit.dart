import 'package:flutter_bloc/flutter_bloc.dart';

class UiState {
  final bool isPasswordObscured;
  final bool isLoading;
  final bool isLoadingForgot;
  final bool rememberMe;
  final bool isSidebarCollapsed;

  UiState({
    this.isPasswordObscured = true,
    this.isLoading = false,
    this.isLoadingForgot = false,
    this.rememberMe = false,
    this.isSidebarCollapsed = false,
  });

  UiState copyWith({
    bool? isPasswordObscured,
    bool? isLoading,
    bool? isLoadingForgot,
    bool? rememberMe,
    bool? isSidebarCollapsed,
  }) {
    return UiState(
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
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
