import 'package:equatable/equatable.dart';

class PriorityState extends Equatable {
  final bool usePriority;
  final bool isLoading;
  final String? error;

  const PriorityState({
    this.usePriority = false,
    this.isLoading = false,
    this.error,
  });

  // need more optimization
  PriorityState copyWith({bool? usePriority, bool? isLoading, String? error}) {
    return PriorityState(
      usePriority: usePriority ?? this.usePriority,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [usePriority, isLoading, error];
}
