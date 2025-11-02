import 'package:bm_binus/data/dummy/dashboar_data.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_bloc.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_state.dart';
import 'package:bm_binus/presentation/widgets/event_status_chart.dart';
import 'package:bm_binus/presentation/widgets/event_type_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get data
    final statusDashboard = DashboardData.getStatusData();
    final typeDashboard = DashboardData.getTypeData();

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const Text(
              "Dashboard Overview",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Hai, ${authState.email ?? 'User'} 👋',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Role: ${authState.role ?? '-'}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: _infoCard("Total Users", "100", Icons.people),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: _infoCard(
                    "Analytical Hierarchy Property",
                    "50",
                    Icons.add_chart_outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: _infoCard(
                    "Event Complete",
                    "430",
                    Icons.event_available_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Chart Section
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _chartCard(
                    title: "Event Status",
                    child: EventStatusChart(dashboard: statusDashboard),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: _chartCard(
                    title: "Event Type",
                    child: EventTypeChart(dashboard: typeDashboard),
                  ),
                ),
              ],
            ),
          ],
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
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
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
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(height: 300, child: child),
        ],
      ),
    );
  }
}
