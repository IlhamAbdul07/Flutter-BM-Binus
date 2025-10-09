import 'package:bm_binus/features/auth/auth_bloc.dart';
import 'package:bm_binus/features/auth/auth_event.dart';
import 'package:bm_binus/layout/bloc/sidebar_bloc.dart';
import 'package:bm_binus/layout/sidebar_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SidebarBloc(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;
          final sidebar = SidebarMenu(isCollapsed: isMobile);

          return Scaffold(
            appBar: isMobile
                ? AppBar(
                    title: const Text('Building Management'),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () {
                          context.read<AuthBloc>().add(LogoutRequested());
                          context.go('/login');
                        },
                      ),
                    ],
                    leading: Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                  )
                : AppBar(
                    title: const Text('Flutter Dashboard'),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () {
                          context.read<AuthBloc>().add(LogoutRequested());
                          context.go('/login');
                        },
                      ),
                    ],
                  ),
            drawer: isMobile ? Drawer(child: sidebar) : null,
            body: Row(
              children: [
                if (!isMobile) SizedBox(width: 240, child: sidebar),
                Expanded(child: child),
              ],
            ),
          );
        },
      ),
    );
  }
}
