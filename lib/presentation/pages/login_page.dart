import 'package:bm_binus/core/constants.dart/custom_colors.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_bloc.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_event.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_state.dart';
import 'package:bm_binus/presentation/cubit/ui_cubit.dart';
import 'package:bm_binus/presentation/widgets/custom_snackbar.dart';
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
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final isDesktop = MediaQuery.of(context).size.width > 800; // breakpoint

    return Scaffold(
      backgroundColor: CustomColors.primary,
      body: buildWidget(
        context,
        usernameController,
        passwordController,
        isDesktop,
      ),
    );
  }

  Widget buildWidget(
    BuildContext context,
    TextEditingController usernameController,
    TextEditingController passwordController,
    bool isDesktop,
  ) {
    if (isDesktop) {
      return _buildDesktop(context, usernameController, passwordController);
    } else {
      return _buildMobile(context, usernameController, passwordController);
    }
  }

  // =============================
  // 🖥️ DESKTOP UI
  // =============================
  Widget _buildDesktop(
    BuildContext context,
    TextEditingController usernameController,
    TextEditingController passwordController,
  ) {
    return Center(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isAuthenticated) {
            context.read<UiCubit>().setLoading(false);

            CustomSnackBar.show(
              context,
              icon: Icons.check_circle,
              title: 'Login Success',
              message: 'Welcome back!',
              color: Colors.green,
            );

            // delay sebentar biar snackbar sempat muncul
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go('/dashboard');
            });
          } else if (state.error != null) {
            context.read<UiCubit>().setLoading(false);

            CustomSnackBar.show(
              context,
              icon: Icons.error,
              title: 'Login Failed',
              message: state.error!,
              color: Colors.red,
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SizedBox(
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

                            // 🔒 Password pakai UiCubit
                            BlocBuilder<UiCubit, UiState>(
                              builder: (context, uiState) {
                                return TextField(
                                  controller: passwordController,
                                  obscureText: uiState.isPasswordObscured,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        uiState.isPasswordObscured
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        context
                                            .read<UiCubit>()
                                            .togglePasswordVisibility();
                                      },
                                    ),
                                  ),
                                  onSubmitted: (_) {
                                    final user = usernameController.text;
                                    final pass = passwordController.text;
                                    context.read<UiCubit>().setLoading(true);
                                    context.read<AuthBloc>().add(
                                      LoginRequested(user, pass),
                                    );
                                  },
                                );
                              },
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
                                  context.read<UiCubit>().setLoading(true);
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
                            SizedBox(height: 8),
                            InkWell(
                              onTap: () {
                                context.go('/lupapassword');
                              },
                              child: const Text(
                                'Lupa Password ?',
                                style: TextStyle(
                                  color: CustomColors.primary,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<UiCubit, UiState>(
                builder: (context, uiState) {
                  if (!uiState.isLoading) return const SizedBox.shrink();
                  return Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // =============================
  // 📱 MOBILE UI
  // =============================
  Widget _buildMobile(
    BuildContext context,
    TextEditingController usernameController,
    TextEditingController passwordController,
  ) {
    return SafeArea(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isAuthenticated) {
            context.read<UiCubit>().setLoading(false);

            CustomSnackBar.show(
              context,
              icon: Icons.check_circle,
              title: 'Login Success',
              message: 'Welcome back!',
              color: Colors.green,
            );

            // delay sebentar biar snackbar sempat muncul
            Future.delayed(const Duration(milliseconds: 800), () {
              context.go('/dashboard');
            });
          } else if (state.error != null) {
            context.read<UiCubit>().setLoading(false);

            CustomSnackBar.show(
              context,
              icon: Icons.error,
              title: 'Login Failed',
              message: state.error!,
              color: Colors.red,
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 48),
                Image.asset('assets/images/logo.png', width: 100),
                const SizedBox(height: 16),
                const Text(
                  'Building Management',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),

                // 🧾 Form Card
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text('Login', style: TextStyle(fontSize: 22)),
                        const SizedBox(height: 16),

                        TextField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                          ),
                        ),
                        const SizedBox(height: 16),

                        BlocBuilder<UiCubit, UiState>(
                          builder: (context, uiState) {
                            return TextField(
                              controller: passwordController,
                              obscureText: uiState.isPasswordObscured,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    uiState.isPasswordObscured
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<UiCubit>()
                                        .togglePasswordVisibility();
                                  },
                                ),
                              ),
                            );
                          },
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
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            context.go('/lupapassword');
                          },
                          child: const Text(
                            'Lupa Password ?',
                            style: TextStyle(
                              color: CustomColors.primary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
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
    );
  }
}
