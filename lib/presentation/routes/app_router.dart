import 'dart:async';

import 'package:bm_binus/presentation/layout/main_layout.dart';
import 'package:bm_binus/presentation/pages/ahp_page.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_bloc.dart';
import 'package:bm_binus/presentation/pages/change_pw_page.dart';
import 'package:bm_binus/presentation/pages/dashboard_page.dart';
import 'package:bm_binus/presentation/pages/event_data_page.dart';
import 'package:bm_binus/presentation/pages/login_page.dart';
import 'package:bm_binus/presentation/pages/pengajuan_page.dart';
import 'package:bm_binus/presentation/pages/settings_page.dart';
import 'package:bm_binus/presentation/pages/user_data_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

GoRouter createRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshBloc(authBloc),
    redirect: (context, state) {
      final loggedIn = authBloc.state.isAuthenticated;
      final loggingIn = state.fullPath == '/';
      if (!loggedIn && !loggingIn) return '/';
      if (loggedIn && loggingIn) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LoginPage()),
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/users',
            builder: (context, state) => const UserDataPage(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
          ),
          GoRoute(
            path: '/ubahpassword',
            builder: (context, state) => const ChangePwPage(),
          ),
          GoRoute(
            path: '/pengajuan',
            builder: (context, state) => const PengajuanPage(),
          ),
          GoRoute(
            path: '/event',
            builder: (context, state) => const EventDataPage(),
          ),
          GoRoute(path: '/ahp', builder: (context, state) => const AhpPage()),
        ],
      ),
    ],
  );
}

class GoRouterRefreshBloc extends ChangeNotifier {
  GoRouterRefreshBloc(Bloc bloc) {
    _subscription = bloc.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
