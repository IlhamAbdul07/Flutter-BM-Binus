import 'package:bm_binus/data/models/users_model.dart';
import 'package:bm_binus/presentation/bloc/user/user_bloc.dart';
import 'package:bm_binus/presentation/bloc/user/user_event.dart';
import 'package:bm_binus/presentation/bloc/user/user_state.dart';
import 'package:bm_binus/presentation/widgets/custom_dialog.dart';
import 'package:bm_binus/presentation/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

enum UserRole {
  staff,
  bm,
  admin,
}

UserRole getRoleFromName(String name) {
  switch (name) {
    case 'Building Management':
      return UserRole.bm;
    case 'Admin ISS':
      return UserRole.admin;
    default:
      return UserRole.staff;
  }
}

String getRoleName(UserRole role) {
  switch (role) {
    case UserRole.bm:
      return 'Building Management';
    case UserRole.admin:
      return 'Admin ISS';
    default:
      return 'Staf Binus';
  }
}

int getRoleId(String roleName) {
  switch (roleName) {
    case 'Building Management':
      return 2;
    case 'Admin ISS':
      return 3;
    default:
      return 1;
  }
}

enum UserFormMode { add, edit }

class UserFormPage extends StatefulWidget {
  final UserFormMode mode;
  final Users? user;

  const UserFormPage({super.key, required this.mode, this.user})
    : assert(
        mode == UserFormMode.add || (mode == UserFormMode.edit && user != null),
        'User must be provided when mode is edit',
      );

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  late int _userId;
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late UserRole _selectedRole;

  bool get isAddMode => widget.mode == UserFormMode.add;
  bool get isEditMode => widget.mode == UserFormMode.edit;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.user?.name ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _selectedRole = widget.user != null ? getRoleFromName(widget.user!.roleName) : UserRole.staff;
    _userId = widget.user?.id ?? 0;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isAddMode ? 'Tambah User' : 'Edit User',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: BlocConsumer<UserBloc, UsersState>(
        listener: (context, state) async {
          if (state.isSuccessTrx){
            CustomSnackBar.show(
              context,
              icon: Icons.check_circle,
              title: (state.typeTrx != null ? (
                state.typeTrx == "create" ? "Success Create User" : 
                state.typeTrx == "update" ? "Success Update User" : 
                state.typeTrx == "delete" ? "Success Delete User" : "") 
                : ""),
              message: (state.typeTrx != null ? (
                state.typeTrx == "create" ? "User berhasil ditambahkan, cek email untuk mendapatkan informasi login." : 
                state.typeTrx == "update" ? "User berhasil diupdate" : 
                state.typeTrx == "delete" ? "User berhasil didelete" : "") 
                : ""),
              color: Colors.green,
            );
            state.copyWith(isSuccessTrx: false);
            state.copyWith(typeTrx: null);
            await Future.delayed(const Duration(seconds: 1));
            if (context.mounted) {
              context.pop(true);
            }
          } else if (state.errorTrx != null){
            CustomSnackBar.show(
              context,
              icon: Icons.error,
              title: (state.typeTrx != null ? (
                state.typeTrx == "create" ? "Failed Create User" : 
                state.typeTrx == "update" ? "Failed Update User" : 
                state.typeTrx == "delete" ? "Failed Delete User" : "") 
                : ""),
              message: state.errorTrx!,
              color: Colors.red,
            );
            state.copyWith(errorTrx: null);
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: Text(
                '⏳ Mohon tunggu, sedang memuat data...',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header dengan Icon
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isAddMode ? Icons.add_circle : Icons.edit,
                            size: 60,
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Form Nama
                      const Text(
                        'Nama Lengkap',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _namaController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan nama lengkap',
                          prefixIcon: const Icon(Icons.person),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Form Email
                      const Text(
                        'Email',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan email',
                          prefixIcon: const Icon(Icons.email),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          if (!emailRegex.hasMatch(value)) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Form Role
                      const Text(
                        'Role',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<UserRole>(
                        value: _selectedRole,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.work),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        items: UserRole.values.map((role) {
                          return DropdownMenuItem(
                            value: role,
                            child: Text(getRoleName(role)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedRole = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 20),

                      // Tombol Aksi - Conditional berdasarkan mode
                      if (isAddMode)
                        // Tombol untuk Add Mode
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<UserBloc>().add(CreateUserRequested(_namaController.text, _emailController.text, getRoleId(getRoleName(_selectedRole))));
                              }
                            },
                            icon: const Icon(Icons.check),
                            label: const Text('Simpan'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        )
                      else
                        // Tombol untuk Edit Mode
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  CustomDialog.show(
                                    context,
                                    icon: Icons.delete,
                                    iconColor: Colors.red,
                                    title: "Konfirmasi Hapus User",
                                    message: "Apakah anda yakin menghapus user ini?",
                                    confirmText: "Ya, hapus",
                                    confirmColor: Colors.red,
                                    cancelText: "Batal",
                                    cancelColor: Colors.black,
                                    onConfirm: () {
                                      context.read<UserBloc>().add(DeleteUserRequested(_userId));
                                    },
                                  );
                                },
                                icon: const Icon(Icons.delete),
                                label: const Text('Hapus'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    String? name;
                                    String? email;
                                    int? roleId;
                                    if (_namaController.text != widget.user?.name){
                                      name = _namaController.text;
                                    }
                                    if (_emailController.text != widget.user?.email){
                                      email = _emailController.text;
                                    }
                                    if (getRoleName(_selectedRole) != widget.user?.roleName){
                                      roleId = getRoleId(getRoleName(_selectedRole));
                                    }
                                    context.read<UserBloc>().add(UpdateUserRequested(_userId, name, email, roleId));
                                  }
                                },
                                icon: const Icon(Icons.save),
                                label: const Text('Update'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      )
    );
  }
}
