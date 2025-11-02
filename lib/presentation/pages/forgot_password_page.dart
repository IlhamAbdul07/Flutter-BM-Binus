import 'package:bm_binus/core/constants.dart/custom_colors.dart';
import 'package:bm_binus/presentation/cubit/ui_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      child: Stack(
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

                        // if (state.error != null)
                        //   Text(
                        //     state.error!,
                        //     style: const TextStyle(color: Colors.red),
                        //   ),
                        const SizedBox(height: 8),

                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColors.oranges,
                            ),
                            onPressed: () {
                              context.go('/');
                              // final email = emailController.text;
                              // context.read<UiCubit>().setLoading(true);
                              // context.read<AuthBloc>().add(
                              //   LoginRequested(e,),
                              // );
                            },
                            child: const Text(
                              'Kirim',
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
      ),
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
      child: SingleChildScrollView(
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

                    const SizedBox(height: 24),

                    // if (state.error != null)
                    //   Text(
                    //     state.error!,
                    //     style: const TextStyle(color: Colors.red),
                    //   ),
                    const SizedBox(height: 8),

                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.oranges,
                        ),
                        onPressed: () {
                          context.go('/');
                          // final user = usernameController.text;
                          // final pass = passwordController.text;
                          // context.read<AuthBloc>().add(
                          //   LoginRequested(user, pass),
                          // );
                        },
                        child: const Text(
                          'Kirim',
                          style: TextStyle(color: Colors.white, fontSize: 18),
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
    );
  }
}
