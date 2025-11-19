import 'package:bm_binus/core/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';
import 'package:bm_binus/data/models/event_dashboard_model.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardState()) {
    on<FetchDashboardData>(_onFetchDashboardData);
  }

  Future<void> _onFetchDashboardData(
      FetchDashboardData event, Emitter<DashboardState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final response = await ApiService.handleNotifDashboard(
        method: "GET",
        getDashboard: true,
        roleId: event.roleId,
      );

      if (response["success"] == true && response["data"] != null){
        final data = response["data"]["data"];

        final chartByStatus = (data["chart_by_status"] as List?)
                ?.map((item) => StatusData(
                      status: item["status"],
                      count: item["total"],
                      color: _getColorByStatus(item["status"]),
                    ))
                .toList() ??
            [];

        final chartByType = (data["chart_by_event_type"] as List?)
                ?.map((item) => TypeData(
                      type: item["event_type"],
                      count: item["total"],
                    ))
                .toList() ??
            [];

        final statusDashboard = EventStatusDashboard.calculate(chartByStatus);
        final typeDashboard = EventTypeDashboard.calculate(chartByType);

        final totalUsers = event.roleId == 2 ? (data["count_user"] ?? 0) : 0;
        final totalPriority =
            event.roleId == 2 ? (data["count_use_priority"] ?? 0) : 0;
        final totalRequest =
            event.roleId == 2 ? (data["count_request"] ?? 0) : 0;

        emit(state.copyWith(
          isLoading: false,
          statusDashboard: statusDashboard,
          typeDashboard: typeDashboard,
          totalUsers: totalUsers,
          totalPriority: totalPriority,
          totalRequest: totalRequest,
        ));
      } else{
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Gagal memuat data dashboard',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Color _getColorByStatus(String status) {
    switch (status.toLowerCase()) {
      case "pengajuan":
        return Colors.orange;
      case "validasi":
        return Colors.blue;
      case "proses":
        return Colors.purple;
      case "finalisasi":
        return Colors.teal;
      case "selesai":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
