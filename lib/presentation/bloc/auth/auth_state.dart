import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final bool isAuthenticated;
  final String? email;
  final String? role;
  final String? error;

  const AuthState({
    required this.isAuthenticated,
    this.email,
    this.role,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? email,
    String? role,
    String? error,
    required bool isLoading,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      email: email ?? this.email,
      role: role ?? this.role,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isAuthenticated, email, role, error];
}
