import 'package:bm_binus/presentation/bloc/auth/auth_event.dart';
import 'package:bm_binus/presentation/bloc/notification/notification_bloc.dart';
import 'package:bm_binus/presentation/bloc/pengajuan/event_bloc.dart';
import 'package:bm_binus/presentation/bloc/priority/priority_bloc.dart';
import 'package:bm_binus/presentation/bloc/priority/priority_event.dart';
import 'package:bm_binus/presentation/cubit/ui_cubit.dart';
import 'package:bm_binus/presentation/routes/app_router.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authBloc = AuthBloc();
  authBloc.add(CheckAuthSession());
  runApp(MyApp(authBloc: authBloc));
}

class MyApp extends StatelessWidget {
  final AuthBloc authBloc;
  const MyApp({super.key, required this.authBloc});

  @override
  Widget build(BuildContext context) {
    final router = createRouter(authBloc);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authBloc),
        BlocProvider(create: (_) => UiCubit()),
        BlocProvider(create: (context) => NotificationBloc()),
        BlocProvider<PriorityBloc>(
          create: (context) => PriorityBloc()..add(LoadPriorityEvent()),
        ),
        BlocProvider(create: (context) => EventBloc()),
      ],
      child: MaterialApp.router(
        title: 'Building Management',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        darkTheme: ThemeData.light(useMaterial3: true),
      ),
    );
  }
}
