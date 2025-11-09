import 'package:bm_binus/core/constants/custom_colors.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_bloc.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_event.dart';
import 'package:bm_binus/presentation/cubit/ui_cubit.dart';
import 'package:bm_binus/presentation/widgets/custom_dialog.dart';
import 'package:bm_binus/presentation/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePwPage extends StatelessWidget {
  const ChangePwPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (size.width > 800) {
      // 🖥️ DESKTOP
      return _buildDesktopLayout(context, size);
    } else {
      // 📱 MOBILE
      return _buildMobileLayout(context, size);
    }
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

            // 🔒 Password Lama
            _passwordRow(
              context,
              label: "Password Lama",
              controller: oldPasswordController,
            ),

            const SizedBox(height: 16),

            // 🔒 Password Baru
            _passwordRow(
              context,
              label: "Password Baru",
              controller: newPasswordController,
            ),

            const SizedBox(height: 16),

            // 🔒 Konfirmasi Password
            _passwordRow(
              context,
              label: "Konfirmasi Password Baru",
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
            label: "Password Lama",
            controller: oldPasswordController,
          ),

          const SizedBox(height: 16),

          _passwordColumn(
            context,
            label: "Password Baru",
            controller: newPasswordController,
          ),

          const SizedBox(height: 16),

          _passwordColumn(
            context,
            label: "Konfirmasi Password Baru",
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
                      state.isPasswordObscured
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () =>
                        context.read<UiCubit>().togglePasswordVisibility(),
                  ),
                ),
                obscureText: state.isPasswordObscured,
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
                    state.isPasswordObscured
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () =>
                      context.read<UiCubit>().togglePasswordVisibility(),
                ),
              ),
              obscureText: state.isPasswordObscured,
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
        // bloc user for change password 
        context.read<AuthBloc>().add(LogoutRequested());
      },
    );
  }
}
