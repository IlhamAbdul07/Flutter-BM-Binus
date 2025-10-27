import 'package:bm_binus/presentation/bloc/auth/auth_bloc.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_event.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_state.dart';
import 'package:bm_binus/presentation/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/sidebar_bloc.dart';
import '../bloc/sidebar_event.dart';
import '../bloc/sidebar_state.dart';

class SidebarMenu extends StatelessWidget {
  final bool isCollapsed;
  const SidebarMenu({super.key, this.isCollapsed = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[900],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (!authState.isAuthenticated) {
            return const Center(
              child: Text(
                "Silakan login dulu",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return BlocBuilder<SidebarBloc, SidebarState>(
            builder: (context, state) {
              // Helper builder menu item
              Widget buildItem(String label, String route, IconData icon) {
                final selected = state.selectedRoute == route;

                return InkWell(
                  onTap: () {
                    context.read<SidebarBloc>().add(SelectPageEvent(route));
                    context.go(route);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.blueGrey[700]
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: isCollapsed
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      children: [
                        Icon(icon, color: Colors.white),
                        if (!isCollapsed) ...[
                          const SizedBox(width: 12),
                          Text(
                            label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }

              Widget buildLogout(BuildContext context) {
                return BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (!state.isAuthenticated) {
                      context.go('/login');
                    }
                  },
                  child: InkWell(
                    onTap: () {
                      CustomDialog.show(
                        context,
                        icon: Icons.logout,
                        iconColor: Colors.red,
                        title: "Konfirmasi Logout",
                        message: "Apakah kamu yakin ingin keluar?",
                        confirmText: "Ya, keluar",
                        confirmColor: Colors.red,
                        cancelText: "Batal",
                        cancelColor: Colors.black,
                        onConfirm: () {
                          context.read<AuthBloc>().add(LogoutRequested());
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: isCollapsed
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.logout, color: Colors.white),
                          if (!isCollapsed) ...[
                            const SizedBox(width: 12),
                            const Text(
                              "Logout",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              }

              // 🎯 Tentukan menu berdasarkan role
              List<Widget> menuItems = [];
              switch (authState.role) {
                case 'staff':
                  menuItems = [
                    buildItem("Dashboard", "/dashboard", Icons.dashboard),
                    buildItem("Pengajuan", "/pengajuan", Icons.edit_document),
                    buildItem(
                      "Ubah Password",
                      "/ubahpassword",
                      Icons.lock_person_rounded,
                    ),
                    buildItem("Settings", "/settings", Icons.settings),
                    buildLogout(context),
                  ];
                  break;
                case 'bm':
                  menuItems = [
                    buildItem("Dashboard", "/dashboard", Icons.dashboard),
                    buildItem("Data User", "/users", Icons.people),
                    buildItem("Data Event", "/event", Icons.event),
                    buildItem("AHP", "/ahp", Icons.add_chart_sharp),
                    buildItem(
                      "Ubah Password",
                      "/ubahpassword",
                      Icons.lock_person_rounded,
                    ),
                    buildItem("Settings", "/settings", Icons.settings),
                    buildLogout(context),
                  ];
                  break;
                case 'iss':
                  menuItems = [
                    buildItem("Dashboard", "/dashboard", Icons.dashboard),
                    buildItem("Pengajuan", "/pengajuan", Icons.edit_document),
                    buildItem(
                      "Ubah Password",
                      "/ubahpassword",
                      Icons.lock_person_rounded,
                    ),
                    buildItem("Settings", "/settings", Icons.settings),
                    buildLogout(context),
                  ];
                  break;
                default:
                  menuItems = [buildItem("Menu Default", "/", Icons.menu)];
              }

              return Column(
                crossAxisAlignment: isCollapsed
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [const SizedBox(height: 40), ...menuItems],
              );
            },
          );
        },
      ),
    );
  }
}
