import 'package:bm_binus/data/models/status_model.dart';
import 'package:equatable/equatable.dart';

class StatusState extends Equatable {
  final List<Status> status;
  final bool isLoading;
  final String? errorFetch; 

  const StatusState({
    this.status = const [],
    this.isLoading = false,
    this.errorFetch,
  });

  factory StatusState.initial() {
    return const StatusState(
      status: [],
      isLoading: false,
      errorFetch: null,
    );
  }

  StatusState loading() {
    return copyWith(isLoading: true, errorFetch: null);
  }

  StatusState success(List<Status> status) {
    return copyWith(
      status: status,
      isLoading: false,
      errorFetch: null,
    );
  }

  StatusState error(String message) {
    return copyWith(isLoading: false, errorFetch: message);
  }

  StatusState copyWith({
    List<Status>? status,
    bool? isLoading,
    String? errorFetch,
  }) {
    return StatusState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      errorFetch: errorFetch,
    );
  }

  @override
  List<Object?> get props => [status, isLoading, errorFetch];
}
