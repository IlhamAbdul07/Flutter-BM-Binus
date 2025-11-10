import 'package:bm_binus/core/constants/custom_colors.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_bloc.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_event.dart';
import 'package:bm_binus/presentation/bloc/user/user_bloc.dart';
import 'package:bm_binus/presentation/bloc/user/user_event.dart';
import 'package:bm_binus/presentation/bloc/user/user_state.dart';
import 'package:bm_binus/presentation/cubit/ui_cubit.dart';
import 'package:bm_binus/presentation/widgets/custom_dialog.dart';
import 'package:bm_binus/presentation/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const labelOldPassword = "Password Lama";
const labelNewPassword = "Password Baru";
const labelConfirmPassword = "Konfirmasi Password Baru";

class ChangePwPage extends StatelessWidget {
  const ChangePwPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) async {
        if (state.isChangePw) {
          CustomSnackBar.show(
            context,
            icon: Icons.check_circle,
            title: 'Success Change Password',
            message: 'Password berhasil diubah, anda akan diarahkan ke halaman login.',
            color: Colors.green,
          );
          state.copyWith(isChangePw: false);
          await Future.delayed(const Duration(seconds: 1));
          context.read<UiCubit>().toggleOldPasswordReset();
          context.read<UiCubit>().toggleNewPasswordReset();
          context.read<UiCubit>().toggleConfirmPasswordReset();
          context.read<AuthBloc>().add(LogoutRequested());
        } else if (state.errorChangePw != null) {
          CustomSnackBar.show(
            context,
            icon: Icons.error,
            title: 'Failed Change Password',
            message: state.errorChangePw!,
            color: Colors.red,
          );
          state.copyWith(errorChangePw: null);
        }
      },
      child: size.width > 800
          ? _buildDesktopLayout(context, size)
          : _buildMobileLayout(context, size),
    );
  }

  // ======================================================
  // 🖥️ DESKTOP LAYOUT
  // ======================================================
  Widget _buildDesktopLayout(BuildContext context, Size size) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: ListView(
          shrinkWrap: true,
          children: [
            const Text(
              "Ubah Password",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Anda akan diminta untuk login kembali setelah mengubah password.",
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),

            _passwordRow(
              context,
              label: labelOldPassword,
              controller: oldPasswordController,
            ),

            const SizedBox(height: 16),

            _passwordRow(
              context,
              label: labelNewPassword,
              controller: newPasswordController,
            ),

            const SizedBox(height: 16),

            _passwordRow(
              context,
              label: labelConfirmPassword,
              controller: confirmPasswordController,
            ),

            const SizedBox(height: 24),

            // ✅ Tombol Simpan
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: size.width * 0.2,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    checkPasswordMatch(
                      oldPasswordController.text,
                      newPasswordController.text,
                      confirmPasswordController.text,
                      context,
                    );
                  },
                  child: const Text(
                    "Simpan Password",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // 📱 MOBILE LAYOUT
  // ======================================================
  Widget _buildMobileLayout(BuildContext context, Size size) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Ubah Password"), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            "Anda akan diminta untuk login kembali setelah mengubah password.",
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 24),

          _passwordColumn(
            context,
            label: labelOldPassword,
            controller: oldPasswordController,
          ),

          const SizedBox(height: 16),

          _passwordColumn(
            context,
            label: labelNewPassword,
            controller: newPasswordController,
          ),

          const SizedBox(height: 16),

          _passwordColumn(
            context,
            label: labelConfirmPassword,
            controller: confirmPasswordController,
          ),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                checkPasswordMatch(
                  oldPasswordController.text,
                  newPasswordController.text,
                  confirmPasswordController.text,
                  context,
                );
              },
              child: const Text(
                "Simpan Password",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // 🔹 Widget Reusable (Desktop)
  // ======================================================
  Widget _passwordRow(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
  }) {
    return BlocBuilder<UiCubit, UiState>(
      builder: (context, state) {
        bool obscurePw = true;
        VoidCallback funcVisibility =() {};
        switch (label) {
          case labelOldPassword:
            obscurePw = state.isOldPasswordObscured;
            funcVisibility = () => context.read<UiCubit>().toggleOldPasswordVisibility();
            break;
          case labelNewPassword:
            obscurePw = state.isNewPasswordObscured;
            funcVisibility = () => context.read<UiCubit>().toggleNewPasswordVisibility();
            break;
          case labelConfirmPassword:
            obscurePw = state.isConfirmPasswordObscured;
            funcVisibility = () => context.read<UiCubit>().toggleConfirmPasswordVisibility();
            break;
          default:
            obscurePw = state.isPasswordObscured;
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Masukkan $label',
                  border: const OutlineInputBorder(),
                  isDense: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePw
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: funcVisibility,
                  ),
                ),
                obscureText: obscurePw,
              ),
            ),
          ],
        );
      },
    );
  }

  // ======================================================
  // 🔹 Widget Reusable (Mobile)
  // ======================================================
  Widget _passwordColumn(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
  }) {
    return BlocBuilder<UiCubit, UiState>(
      builder: (context, state) {
        bool obscurePw;
        VoidCallback funcVisibility =() {};
        switch (label) {
          case labelOldPassword:
            obscurePw = state.isOldPasswordObscured;
            funcVisibility = () => context.read<UiCubit>().toggleOldPasswordVisibility();
            break;
          case labelNewPassword:
            obscurePw = state.isNewPasswordObscured;
            funcVisibility = () => context.read<UiCubit>().toggleNewPasswordVisibility();
            break;
          case labelConfirmPassword:
            obscurePw = state.isConfirmPasswordObscured;
            funcVisibility = () => context.read<UiCubit>().toggleConfirmPasswordVisibility();
            break;
          default:
            obscurePw = state.isPasswordObscured;
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Masukkan $label',
                border: const OutlineInputBorder(),
                isDense: true,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePw
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: funcVisibility,
                ),
              ),
              obscureText: obscurePw,
            ),
          ],
        );
      },
    );
  }
}

// 🧠 Dummy Validator (sementara)
void checkPasswordMatch(
  String oldPassword,
  String newPassword,
  String confirmPassword,
  BuildContext context,
) {
  // Check for null or empty passwords
  if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
    CustomSnackBar.show(
      context,
      icon: Icons.error,
      title: 'Input Error',
      message: 'Semua field wajib diisi.',
      color: Colors.red,
    );
    return;
  }

  if (oldPassword.length < 8 || newPassword.length < 8 || confirmPassword.length < 8) {
    CustomSnackBar.show(
      context,
      icon: Icons.error,
      title: 'Input Error',
      message: 'Semua field wajib minimal 8 karakter.',
      color: Colors.red,
    );
    return;
  }

  if (oldPassword == newPassword) {
    CustomSnackBar.show(
      context,
      icon: Icons.error,
      title: 'Password Mismatch',
      message: 'Password baru tidak boleh sama dengan password lama.',
      color: Colors.red,
    );
  } else if (newPassword != confirmPassword) {
    CustomSnackBar.show(
      context,
      icon: Icons.error,
      title: 'Password Mismatch',
      message: 'Password baru dan konfirmasi password tidak sesuai.',
      color: Colors.red,
    );
  } else {
    CustomDialog.show(
      context,
      icon: Icons.logout,
      iconColor: CustomColors.oranges,
      title: "Konfirmasi Ubah Password",
      message: "Apakah kamu yakin ingin mengubah Password?",
      confirmText: "Ya, Ubah",
      confirmColor: CustomColors.oranges,
      cancelText: "Batal",
      cancelColor: Colors.black,
      onConfirm: () {
        final authState = context.read<AuthBloc>().state;
        final userId = authState.id;
        context.read<UserBloc>().add(ChangePasswordRequested(userId!, oldPassword, newPassword));
      },
    );
  }
}
