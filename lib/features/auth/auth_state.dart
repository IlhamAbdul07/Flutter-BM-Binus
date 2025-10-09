import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final bool isAuthenticated;
  final String? role;
  final String? error;

  const AuthState({required this.isAuthenticated, this.role, this.error});

  AuthState copyWith({bool? isAuthenticated, String? role, String? error}) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      role: role ?? this.role,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isAuthenticated, role, error];
}
