import 'package:bm_binus/app_router.dart';
import 'package:bm_binus/features/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  final authBloc = AuthBloc();
  runApp(MyApp(authBloc: authBloc));
}

class MyApp extends StatelessWidget {
  final AuthBloc authBloc;
  const MyApp({super.key, required this.authBloc});

  @override
  Widget build(BuildContext context) {
    final router = createRouter(authBloc);

    return BlocProvider.value(
      value: authBloc,
      child: MaterialApp.router(
        title: 'Building Management',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: ThemeData.dark(useMaterial3: true), // cuma pakai dark theme
      ),
    );
  }
}
