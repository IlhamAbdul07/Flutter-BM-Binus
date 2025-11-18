import 'package:bm_binus/data/models/users_model.dart';
import 'package:equatable/equatable.dart';

class UsersState extends Equatable {
  final List<Users> users;
  final bool isLoading;
  final String? errorFetch; 
  final bool isChangePw;
  final String? errorChangePw;
  final bool isSuccessTrx;
  final String? errorTrx;
  final String? typeTrx;
  final Map<String, bool> loadingType;

  const UsersState({
    this.users = const [],
    this.isLoading = false,
    this.errorFetch,
    required this.isChangePw,
    this.errorChangePw,
    required this.isSuccessTrx,
    this.errorTrx,
    this.typeTrx,
    this.loadingType = const {},
  });

  factory UsersState.initial() {
    return const UsersState(
      users: [],
      isLoading: false,
      errorFetch: null,
      isChangePw: false,
      errorChangePw: null,
      isSuccessTrx: false,
      errorTrx: null,
      typeTrx: null,
      loadingType: {},
    );
  }

  UsersState loading() {
    return copyWith(isLoading: true, errorFetch: null);
  }

  UsersState success(List<Users> users) {
    return copyWith(
      users: users,
      isLoading: false,
      errorFetch: null,
    );
  }

  UsersState error(String message) {
    return copyWith(isLoading: false, errorFetch: message);
  }

  UsersState setLoading(bool loading) {
    return copyWith(isLoading: loading);
  }

  UsersState setLoadingType(String key, bool value) {
    final newMap = Map<String, bool>.from(loadingType);
    newMap[key] = value;
    return copyWith(loadingType: newMap);
  }

  // need more optimization
  UsersState copyWith({
    List<Users>? users,
    bool? isLoading,
    String? errorFetch,
    bool? isChangePw,
    String? errorChangePw,
    bool? isSuccessTrx,
    String? errorTrx,
    String? typeTrx,
    Map<String, bool>? loadingType,
  }) {
    return UsersState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      errorFetch: errorFetch,
      isChangePw: isChangePw ?? this.isChangePw,
      errorChangePw: errorChangePw,
      isSuccessTrx: isSuccessTrx ?? this.isSuccessTrx,
      errorTrx: errorTrx,
      typeTrx: typeTrx,
      loadingType: loadingType ?? this.loadingType,
    );
  }

  @override
  List<Object?> get props => [users, isLoading, errorFetch, isChangePw, errorChangePw, isSuccessTrx, errorTrx, typeTrx, loadingType];
}
