import 'package:bm_binus/core/constants.dart/custom_colors.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_bloc.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_event.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primary,
      body: Center(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.isAuthenticated) {
              context.go('/dashboard');
            }
          },
          builder: (context, state) {
            return SizedBox(
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    spacing: 16,
                    children: [
                      Image.asset('assets/images/logo.png', width: 75),
                      const Text(
                        'Building Management',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Login', style: TextStyle(fontSize: 26)),
                          const SizedBox(height: 24),
                          TextField(
                            controller: usernameController,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                            ),
                          ),
                          const SizedBox(height: 16),

                          // 🔒 Password field pakai state dari BLoC
                          TextField(
                            controller: passwordController,

                            decoration: InputDecoration(
                              labelText: 'Password',
                              // suffixIcon: IconButton(
                              //   icon: Icon(
                              //     state.isPasswordObscured
                              //         ? Icons.visibility_off
                              //         : Icons.visibility,
                              //   ),
                              //   onPressed: () {
                              //     context.read<AuthBloc>().add(
                              //       TogglePasswordVisibility(),
                              //     );
                              //   },
                              // ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          if (state.error != null)
                            Text(
                              state.error!,
                              style: const TextStyle(color: Colors.red),
                            ),

                          const SizedBox(height: 8),

                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.oranges,
                              ),
                              onPressed: () {
                                final user = usernameController.text;
                                final pass = passwordController.text;
                                context.read<AuthBloc>().add(
                                  LoginRequested(user, pass),
                                );
                              },
                              child: const Text(
                                'Masuk',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
