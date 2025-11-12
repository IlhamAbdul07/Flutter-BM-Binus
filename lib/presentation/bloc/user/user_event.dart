import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUsersEvent extends UserEvent {}

class CreateUserRequested extends UserEvent {
  final String name;
  final String email;
  final int roleId;

  const CreateUserRequested(this.name, this.email, this.roleId);

  @override
  List<Object> get props => [name, email, roleId];
}

class UpdateUserRequested extends UserEvent {
  final int userId;
  final String? name;
  final String? email;
  final int? roleId;

  const UpdateUserRequested(this.userId, this.name, this.email, this.roleId);

  @override
  List<Object> get props => [userId, name!, email!, roleId!];
}

class DeleteUserRequested extends UserEvent {
  final int userId;

  const DeleteUserRequested(this.userId);

  @override
  List<Object> get props => [userId];
}

class DownloadUsersEvent extends UserEvent {}

class ChangePasswordUserRequested extends UserEvent {
  final int userId;
  final String oldPassword;
  final String newPassword;

  const ChangePasswordUserRequested(this.userId, this.oldPassword, this.newPassword);

  @override
  List<Object> get props => [userId, oldPassword, newPassword];
}
