import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class ChangePasswordRequested extends UserEvent {
  final int userId;
  final String oldPassword;
  final String newPassword;

  const ChangePasswordRequested(this.userId, this.oldPassword, this.newPassword);

  @override
  List<Object> get props => [userId, oldPassword, newPassword];
}
