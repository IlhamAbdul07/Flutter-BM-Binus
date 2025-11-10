import 'package:equatable/equatable.dart';

class UserState extends Equatable {
  final bool isChangePw;
  final String? errorChangePw;

  const UserState({
    required this.isChangePw,
    this.errorChangePw,
  });

  UserState copyWith({
    bool? isChangePw,
    String? errorChangePw,
  }) {
    return UserState(
      isChangePw: isChangePw ?? this.isChangePw,
      errorChangePw: errorChangePw,
    );
  }

  @override
  List<Object?> get props => [isChangePw, errorChangePw];
}
