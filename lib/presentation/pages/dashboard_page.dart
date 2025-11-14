import 'package:bm_binus/presentation/bloc/auth/auth_bloc.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_state.dart';
import 'package:bm_binus/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:bm_binus/presentation/bloc/dashboard/dashboard_event.dart';
import 'package:bm_binus/presentation/bloc/dashboard/dashboard_state.dart';
import 'package:bm_binus/presentation/widgets/event_status_chart.dart';
import 'package:bm_binus/presentation/widgets/event_type_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _hasFetched = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return BlocProvider(
          create: (_) => DashboardBloc()..add(FetchDashboardData(authState.roleId ?? 0)),
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state){
              if (!_hasFetched && authState.roleId != null) {
                context.read<DashboardBloc>().add(FetchDashboardData(authState.roleId!));
                _hasFetched = true;
              }

              if (state.isLoading) {
                return const Center(
                  child: Text(
                    '⏳ Mohon tunggu, sedang memuat data...',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                );
              }

              if (state.errorMessage != null) {
                return Center(child: Text(state.errorMessage!));
              }

              if (state.statusDashboard == null || state.typeDashboard == null) {
                return const Center(
                  child: Text(
                    '⏳ Mohon tunggu, sedang memuat data...',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  const Text(
                    "Dashboard Overview",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Hai ${authState.name ?? 'User'}, semoga harimu menyenangkan 👋',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Peran kamu: ${authState.roleName ?? '-'}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  if (authState.roleId == 2) ...[
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: _infoCard("Total Users", "${state.totalUsers}", Icons.people),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: _infoCard(
                            "Using Priority Feature with AHP",
                            "${state.totalPriority}",
                            Icons.add_chart_outlined,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: _infoCard(
                            "Total Events",
                            "${state.totalRequest}",
                            Icons.event_available_outlined,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: _chartCard(
                          title: "Request Event by Status",
                          child: EventStatusChart(dashboard: state.statusDashboard!),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: _chartCard(
                          title: "Request Event by Type",
                          child: EventTypeChart(dashboard: state.typeDashboard!),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          )
        );
      },
    );
  }

  Widget _infoCard(String title, String value, IconData icon) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blueGrey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 30, color: Colors.amber),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 16, color: Colors.white70)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chartCard({required String title, required Widget child}) {
    return Container(
      width: 500,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          SizedBox(height: 300, child: child),
        ],
      ),
    );
  }
}
