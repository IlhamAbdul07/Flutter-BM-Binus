import 'package:equatable/equatable.dart';
import 'package:bm_binus/data/models/event_dashboard_model.dart';

class DashboardState extends Equatable {
  final bool isLoading;
  final EventStatusDashboard? statusDashboard;
  final EventTypeDashboard? typeDashboard;
  final String? errorMessage;
  final int totalUsers;
  final int totalPriority;
  final int totalRequest;

  const DashboardState({
    this.isLoading = false,
    this.statusDashboard,
    this.typeDashboard,
    this.errorMessage,
    this.totalUsers = 0,
    this.totalPriority = 0,
    this.totalRequest = 0,
  });

  DashboardState copyWith({
    bool? isLoading,
    EventStatusDashboard? statusDashboard,
    EventTypeDashboard? typeDashboard,
    String? errorMessage,
    int? totalUsers,
    int? totalPriority,
    int? totalRequest,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      statusDashboard: statusDashboard ?? this.statusDashboard,
      typeDashboard: typeDashboard ?? this.typeDashboard,
      errorMessage: errorMessage ?? this.errorMessage,
      totalUsers: totalUsers ?? this.totalUsers,
      totalPriority: totalPriority ?? this.totalPriority,
      totalRequest: totalRequest ?? this.totalRequest,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    statusDashboard,
    typeDashboard,
    errorMessage,
    totalUsers,
    totalPriority,
    totalRequest,
  ];
}
