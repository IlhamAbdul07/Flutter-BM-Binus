import 'package:bm_binus/core/constants/custom_colors.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_bloc.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_event.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_state.dart';
import 'package:bm_binus/presentation/cubit/ui_cubit.dart';
import 'package:bm_binus/presentation/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    return Scaffold(
      backgroundColor: CustomColors.primary,
      body: buildWidget(context, emailController, isDesktop),
    );
  }

  Widget buildWidget(
    BuildContext context,
    TextEditingController emailController,

    bool isDesktop,
  ) {
    if (isDesktop) {
      return _buildDesktop(context, emailController);
    } else {
      return _buildMobile(context, emailController);
    }
  }

  // =============================
  // 🖥️ DESKTOP UI
  // =============================
  Widget _buildDesktop(
    BuildContext context,
    TextEditingController emailController,
  ) {
    return Center(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state){
          if (state.isSendForgot) {
            context.read<UiCubit>().setLoadingForgot(false);
            CustomSnackBar.show(
              context,
              icon: Icons.check_circle,
              title: 'Send Email Forgot Password Success',
              message: 'Permintaan Reset Password Telah dikirim ke Email kamu, mohon cek folder spam jika tidak ada di kontak masuk.',
              color: Colors.green,
            );

            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<AuthBloc>().add(ResetForgotPasswordState());
              context.go('/');
            });
          } else if (state.errorForgot != null) {
            context.read<UiCubit>().setLoadingForgot(false);
            CustomSnackBar.show(
              context,
              icon: Icons.error,
              title: 'Send Email Forgot Password Failed',
              message: state.errorForgot!,
              color: Colors.red,
            );

            emailController.text = "";
          }
        },
        builder: (context, state){
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
                          'Lupa Password',
                          style: TextStyle(
                            fontSize: 35,
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
                            const Text(
                              'Masukan Email yang terdaftar untuk mengirimkan tautan pemulihan',
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),

                            TextField(
                              controller: emailController,
                              decoration: const InputDecoration(labelText: 'Email'),
                            ),

                            const SizedBox(height: 16),
                            const SizedBox(height: 8),

                            BlocBuilder<UiCubit, UiState>(
                              builder: (context, state){
                                return SizedBox(
                                  width: double.infinity,
                                  height: 45,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: CustomColors.oranges,
                                    ),
                                    onPressed: () {
                                      final email = emailController.text;
                                      context.read<UiCubit>().setLoadingForgot(true);
                                      context.read<AuthBloc>().add(ForgotPasswordRequested(email));
                                      // context.read<UiCubit>().setLoadingForgot(false);
                                    },
                                    child: state.isLoadingForgot
                                      ? const SizedBox(
                                          height: 18,
                                          width: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text('Kirim', style: TextStyle(color: Colors.white,fontSize: 20)),
                                  ),
                                );
                              }
                            ),
                            SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                                context.go('/');
                              },
                              child: const Text(
                                'Back to Login',
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
            ],
          );
        },
      )
    );
  }

  // =============================
  // 📱 MOBILE UI
  // =============================
  Widget _buildMobile(
    BuildContext context,
    TextEditingController emailController,
  ) {
    return SafeArea(
      child: BlocConsumer<AuthBloc,AuthState>(
        listener: (context, state) {
          if (state.isSendForgot) {
            context.read<UiCubit>().setLoadingForgot(false);

            CustomSnackBar.show(
              context,
              icon: Icons.check_circle,
              title: 'Send Email Forgot Password Success',
              message: 'Permintaan Reset Password Telah dikirim ke Email kamu, mohon cek folder spam jika tidak ada di kontak masuk.',
              color: Colors.green,
            );

            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<AuthBloc>().add(ResetForgotPasswordState());
              context.go('/');
            });
          } else if (state.errorForgot != null) {
            context.read<UiCubit>().setLoadingForgot(false);

            CustomSnackBar.show(
              context,
              icon: Icons.error,
              title: 'Send Email Forgot Password Failed',
              message: state.errorForgot!,
              color: Colors.red,
            );

            emailController.text = "";
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
                  'Lupa Password',
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
                        const Text(
                          'Masukan Email yang terdaftar untuk mengirimkan tautan pemulihan',
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 16),

                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                        ),

                        const SizedBox(height: 16),
                        const SizedBox(height: 8),

                        BlocBuilder<UiCubit,UiState>(
                          builder: (context, state){
                            return SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: CustomColors.oranges,
                                ),
                                onPressed: () {
                                  final email = emailController.text;
                                  context.read<UiCubit>().setLoadingForgot(true);
                                  context.read<AuthBloc>().add(ForgotPasswordRequested(email));
                                  // context.read<UiCubit>().setLoadingForgot(false);
                                },
                                child: state.isLoadingForgot
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Kirim', style: TextStyle(color: Colors.white,fontSize: 18)),
                              ),
                            );
                          }
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            context.go('/');
                          },
                          child: const Text(
                            'Back to Login',
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
      )
    );
  }
}
