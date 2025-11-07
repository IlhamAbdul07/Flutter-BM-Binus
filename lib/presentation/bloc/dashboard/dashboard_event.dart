import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class FetchDashboardData extends DashboardEvent {
  final int roleId;

  const FetchDashboardData(this.roleId);

  @override
  List<Object?> get props => [roleId];
}
