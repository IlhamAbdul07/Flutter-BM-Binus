import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:bm_binus/core/constants/custom_colors.dart';
import 'package:bm_binus/core/notifiers/session_notifier.dart';
import 'package:bm_binus/core/services/socket_service.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_bloc.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_event.dart';
import 'package:bm_binus/presentation/bloc/notification/notification_bloc.dart';
import 'package:bm_binus/presentation/bloc/notification/notification_event.dart';
import 'package:bm_binus/presentation/bloc/notification/notification_state.dart';
import 'package:bm_binus/presentation/bloc/sidebar/sidebar_bloc.dart';
import 'package:bm_binus/presentation/layout/sidebar_menu.dart';
import 'package:bm_binus/presentation/widgets/custom_dialog.dart';
import 'package:bm_binus/presentation/widgets/notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  AudioPlayer _createPlayer() {
    final player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);
    return player;
  }

  Future<void> _initializeSocket(String userId, NotificationBloc bloc) async {
    final player = _createPlayer();

    await socketServiceManager.getOrCreateAndConnect(
      userId: userId,
      onDataReceive: (data) async {
        try {
          if (data['is_new'] == true) {
            try {
              await player.play(
                AssetSource('sounds/notif_sound.mp3'),
              );
            } catch (e) {
              log("⚠️ Error play sound: $e");
            }
            bloc.add(LoadNotificationsEvent());
          }
        } catch (e) {
          log("⚠️ Error saat handle socket data: $e");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;

    if (authState.id != null) {
      final notifBloc = context.read<NotificationBloc>();
      _initializeSocket(authState.id.toString(), notifBloc);
      log("🔌 Menghubungkan Socket untuk userId: ${authState.id}");
    }

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
  // context.read<NotificationBloc>().add(LoadNotificationsEvent());
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
            BlocConsumer<NotificationBloc, NotificationState>(
              listener: (context, state) {
                if (state.sessionExp) {
                  log("Session Expired: ${sessionExpiredNotifier.value}");
                  CustomDialog.show(
                    context,
                    icon: Icons.logout,
                    iconColor: Colors.red,
                    title: "Session Expired",
                    message: state.errorMessage!,
                    confirmText: "Ya, Saya akan login.",
                    confirmColor: Colors.red,
                    cancelText: "Batal",
                    cancelColor: Colors.black,
                    onConfirm: () {
                      context.read<AuthBloc>().add(LogoutRequested());
                      context.read<NotificationBloc>().add(ResetSessionEvent());
                    },
                    barrierDismissible: false,
                    notCancel: true
                  );
                }
              },
              builder: (context, state) {
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      NotificationDialog.show(context);
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        if (state.unreadCount > 0)
                          Positioned(
                            right: 2,
                            top: 0,
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
                    ),
                  ),
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
  // context.read<NotificationBloc>().add(LoadNotificationsEvent());
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
      BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state.sessionExp) {
            log("Session Expired: ${sessionExpiredNotifier.value}");
            CustomDialog.show(
              context,
              icon: Icons.logout,
              iconColor: Colors.red,
              title: "Session Expired",
              message: state.errorMessage!,
              confirmText: "Ya, Saya akan login.",
              confirmColor: Colors.red,
              cancelText: "Batal",
              cancelColor: Colors.black,
              onConfirm: () {
                context.read<AuthBloc>().add(LogoutRequested());
                context.read<NotificationBloc>().add(ResetSessionEvent());
              },
              barrierDismissible: false,
              notCancel: true
            );
          }
        },
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
