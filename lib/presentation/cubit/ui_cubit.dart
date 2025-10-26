import 'package:flutter_bloc/flutter_bloc.dart';

class UiState {
  final bool isPasswordObscured;
  final bool isLoading;
  final bool rememberMe;

  UiState({
    this.isPasswordObscured = true,
    this.isLoading = false,
    this.rememberMe = false,
  });

  UiState copyWith({
    bool? isPasswordObscured,
    bool? isLoading,
    bool? rememberMe,
  }) {
    return UiState(
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
      isLoading: isLoading ?? this.isLoading,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}

class UiCubit extends Cubit<UiState> {
  UiCubit() : super(UiState());

  void togglePasswordVisibility() =>
      emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));

  void setLoading(bool value) => emit(state.copyWith(isLoading: value));

  void toggleRememberMe() =>
      emit(state.copyWith(rememberMe: !state.rememberMe));
}
