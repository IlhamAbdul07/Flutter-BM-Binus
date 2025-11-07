import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final bool isAuthenticated;
  final int? id;
  final String? name;
  final String? email;
  final int? roleId;
  final String? roleName;
  final String? error;
  final bool isSendForgot;
  final String? errorForgot;

  const AuthState({
    required this.isAuthenticated,
    this.id,
    this.name,
    this.email,
    this.roleId,
    this.roleName,
    this.error,
    required this.isSendForgot,
    this.errorForgot,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    final int? id,
    final String? name,
    final String? email,
    final int? roleId,
    final String? roleName,
    String? error,
    bool? isSendForgot,
    String? errorForgot,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      roleId: roleId ?? this.roleId,
      roleName: roleName ?? this.roleName,
      error: error,
      isSendForgot: isSendForgot ?? this.isSendForgot,
      errorForgot: errorForgot,
    );
  }

  @override
  List<Object?> get props => [isAuthenticated, isSendForgot, id, name, email, roleId, roleName, error, errorForgot];
}
