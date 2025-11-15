import 'dart:async';

import 'package:bm_binus/data/models/event_type_model.dart';
import 'package:bm_binus/data/models/users_model.dart';
import 'package:bm_binus/presentation/bloc/event_type/event_type_bloc.dart';
import 'package:bm_binus/presentation/bloc/event_type/event_type_event.dart';
import 'package:bm_binus/presentation/bloc/pengajuan/event_bloc.dart';
import 'package:bm_binus/presentation/bloc/pengajuan/event_event.dart';
import 'package:bm_binus/presentation/bloc/status/status_bloc.dart';
import 'package:bm_binus/presentation/bloc/status/status_event.dart';
import 'package:bm_binus/presentation/bloc/user/user_bloc.dart';
import 'package:bm_binus/presentation/layout/main_layout.dart';
import 'package:bm_binus/presentation/pages/add_event_page.dart';
import 'package:bm_binus/presentation/pages/ahp_page.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_bloc.dart';
import 'package:bm_binus/presentation/pages/change_pw_page.dart';
import 'package:bm_binus/presentation/pages/dashboard_page.dart';
import 'package:bm_binus/presentation/pages/event_detail_page.dart';
import 'package:bm_binus/presentation/pages/event_type_form_page.dart';
import 'package:bm_binus/presentation/pages/event_type_data_page.dart';
import 'package:bm_binus/presentation/pages/forgot_password_page.dart';
import 'package:bm_binus/presentation/pages/login_page.dart';
import 'package:bm_binus/presentation/pages/pengajuan_page.dart';
import 'package:bm_binus/presentation/pages/user_data_page.dart';
import 'package:bm_binus/presentation/pages/user_form_page.dart';
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
      final forgotPassword = state.fullPath == '/lupapassword';

      if (forgotPassword) return null;

      if (!loggedIn && !loggingIn) return '/';
      if (loggedIn && loggingIn) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/lupapassword',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
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
            path: '/ubahpassword',
            builder: (context, state) => BlocProvider(
              create: (_) => UserBloc(),
              child: const ChangePwPage(),
            ),
          ),
          GoRoute(
            path: '/pengajuan',
            builder: (context, state) => const PengajuanPage(),
          ),
          GoRoute(
            path: '/eventtype',
            builder: (context, state) => const EventTypePage(),
          ),
          GoRoute(
            path: '/event-detail',
            pageBuilder: (context, state) {
              final requestId = state.extra as int;

              return MaterialPage(
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider<EventBloc>(
                      create: (_) => EventBloc()..add(LoadDetailEventRequested(requestId))
                    ),
                    BlocProvider<EventTypeBloc>(
                      create: (_) => EventTypeBloc()..add(LoadEventTypeEvent()),
                    ),
                    BlocProvider<StatusBloc>(
                      create: (_) => StatusBloc()..add(LoadStatusEvent()),
                    ),
                  ], 
                  child: EventDetailPage(requestId: requestId),
                )
              );
            },
          ),
          GoRoute(
            path: '/event-type-form',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>;
              final mode = extra['mode'] as FormMode;
              final eventType = extra['eventType'] as EventType?;

              return BlocProvider(
                create: (_) => EventTypeBloc(),
                child: EventTypeFormPage(mode: mode, eventType: eventType),
              );
            },
          ),
          GoRoute(
            path: '/user-form',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>;
              final mode = extra['mode'] as UserFormMode;
              final user = extra['user'] as Users?;

              return BlocProvider(
                create: (_) => UserBloc(),
                child: UserFormPage(mode: mode, user: user),
              );
            },
          ),
          GoRoute(
            path: '/addevent',
            pageBuilder: (context, state){
              return MaterialPage(
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider<EventTypeBloc>(
                      create: (_) => EventTypeBloc()..add(LoadEventTypeEvent()),
                    ),
                    BlocProvider<EventBloc>(
                      create: (_) => EventBloc(),
                    ),
                  ], 
                  child: const AddEventPage(),
                )
              );
            },
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
