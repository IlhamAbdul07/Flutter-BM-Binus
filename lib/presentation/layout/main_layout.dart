import 'package:bm_binus/core/constants.dart/custom_colors.dart';
import 'package:bm_binus/presentation/bloc/notification/notification_bloc.dart';
import 'package:bm_binus/presentation/bloc/notification/notification_state.dart';
import 'package:bm_binus/presentation/bloc/sidebar/sidebar_bloc.dart';
import 'package:bm_binus/presentation/layout/sidebar_menu.dart';
import 'package:bm_binus/presentation/widgets/notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                ? buildAppBarMobile(context)
                : buildAppBarDesktop(context),
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

PreferredSizeWidget buildAppBarDesktop(BuildContext context) {
  return AppBar(
    title: Row(
      spacing: 10,
      children: [
        Image.asset('assets/images/logo.png', height: 40),
        const Text(
          'Building Management',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    ),
    backgroundColor: CustomColors.primary,
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Row(
          children: [
            // ✨ WRAP DENGAN BlocBuilder
            BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        NotificationDialog.show(context);
                      },
                    ),
                    // Sekarang bisa akses state.unreadCount
                    if (state.unreadCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            '${state.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            SizedBox(width: 14),
            IconButton(
              icon: const Icon(Icons.sunny, color: Colors.white, size: 30),
              onPressed: () {},
            ),
          ],
        ),
      ),
    ],
  );
}

PreferredSizeWidget buildAppBarMobile(BuildContext context) {
  return AppBar(
    backgroundColor: CustomColors.primary,
    title: Row(
      spacing: 10,
      children: [
        Image.asset('assets/images/logo.png', height: 40),
        const Text(
          'Building Management',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    ),
    actions: [
      // ✨ Icon Notifikasi dengan Badge
      BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          return Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  NotificationDialog.show(context);
                },
              ),
              // Badge (bulatan merah) kalau ada notif belum dibaca
              if (state.unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '${state.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      IconButton(
        icon: const Icon(Icons.sunny, color: Colors.white, size: 30),
        onPressed: () {},
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
  );
}
