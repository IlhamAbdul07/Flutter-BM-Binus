import 'package:bm_binus/presentation/bloc/auth/auth_bloc.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_event.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_state.dart';
import 'package:bm_binus/presentation/cubit/ui_cubit.dart';
import 'package:bm_binus/presentation/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/sidebar/sidebar_bloc.dart';
import '../bloc/sidebar/sidebar_event.dart';
import '../bloc/sidebar/sidebar_state.dart';

class SidebarMenu extends StatelessWidget {
  final bool isCollapsed;
  final VoidCallback? onItemSelected;
  const SidebarMenu({super.key, this.isCollapsed = false, this.onItemSelected});

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
              final uiState = context.watch<UiCubit>().state;
              final isCollapsed = uiState.isSidebarCollapsed;
              // Helper builder menu item
              Widget buildItem(String label, String route, IconData icon) {
                final selected = state.selectedRoute == route;

                return InkWell(
                  onTap: () {
                    if (!isCollapsed && Scaffold.of(context).isDrawerOpen) {
                      Navigator.of(context).pop();
                    }
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
                      vertical: 5,
                      horizontal: 16,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selected
                            ? Colors.blueGrey[700]
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 2,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: isCollapsed
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.start,
                        children: [
                          Icon(icon, color: Colors.white),
                          SizedBox(width: 5),

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
                  ),
                );
              }

              Widget buildExpandableItem(
                BuildContext context, // ✨ Perlu context untuk akses BLoC
                SidebarState state, // ✨ State dari BLoC
                bool isCollapsed, // ✨ Apakah sidebar collapsed
                String menuId, // ✨ ID unik (misal: "event_management")
                String label, // ✨ Label menu (misal: "Event Management")
                IconData icon, // ✨ Icon menu
                List<Map<String, dynamic>> subItems, // ✨ List submenu
              ) {
                // Cek apakah menu ini lagi dibuka
                final isExpanded = state.expandedMenus.contains(menuId);

                return Column(
                  children: [
                    // === PARENT MENU (Yang diklik untuk buka/tutup) ===
                    InkWell(
                      onTap: () {
                        // Toggle expand/collapse
                        context.read<SidebarBloc>().add(
                          ToggleMenuExpansionEvent(menuId),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 5,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 30,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Icon + Label
                            Row(
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
                            // Arrow icon (expand_more/expand_less)
                            if (!isCollapsed)
                              Icon(
                                isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: Colors.white,
                              ),
                          ],
                        ),
                      ),
                    ),

                    // === SUBMENU ITEMS (Muncul kalau isExpanded = true) ===
                    if (isExpanded && !isCollapsed)
                      ...subItems.map((item) {
                        // Cek apakah submenu ini yang aktif
                        final selected = state.selectedRoute == item['route'];

                        return InkWell(
                          onTap: () {
                            // Tutup drawer kalau di mobile
                            if (Scaffold.of(context).isDrawerOpen) {
                              Navigator.of(context).pop();
                            }
                            // Update selected route
                            context.read<SidebarBloc>().add(
                              SelectPageEvent(item['route']),
                            );
                            // Navigate
                            context.go(item['route']);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selected
                                  ? Colors.blueGrey[600]
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            // Indent ke kanan (biar keliatan submenu)
                            margin: const EdgeInsets.only(
                              left: 32,
                              right: 8,
                              top: 2,
                              bottom: 2,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 16,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  item['icon'],
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  item['label'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                  ],
                );
              }

              Widget buildLogout(BuildContext context) {
                return BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (!state.isAuthenticated) {
                      context.go('/');
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
                        vertical: 5,
                        horizontal: 16,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 2,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: isCollapsed
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.logout, color: Colors.white),
                            SizedBox(width: 5),
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
                    buildLogout(context),
                  ];
                  break;
                case 'bm':
                  menuItems = [
                    buildItem("Dashboard", "/dashboard", Icons.dashboard),
                    buildItem("Pengajuan", "/pengajuan", Icons.edit_document),
                    buildExpandableItem(
                      context,
                      state, // State dari BLoC
                      isCollapsed, // Apakah sidebar collapsed
                      "master_data", // ID unik menu ini
                      "Master Data", // Label
                      Icons.storage_rounded, // Icon
                      [
                        // List submenu
                        {
                          'label': 'User Data',
                          'route': '/users',
                          'icon': Icons.people,
                        },
                        {
                          'label': 'Event Type',
                          'route': '/eventtype',
                          'icon': Icons.list,
                        },
                      ],
                    ),
                    buildItem("AHP", "/ahp", Icons.add_chart_sharp),
                    buildItem(
                      "Ubah Password",
                      "/ubahpassword",
                      Icons.lock_person_rounded,
                    ),
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
                    buildLogout(context),
                  ];
                  break;
                default:
                  menuItems = [buildItem("Menu Default", "/", Icons.menu)];
              }

              return Column(
                crossAxisAlignment: isCollapsed
                    ? CrossAxisAlignment.start
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
