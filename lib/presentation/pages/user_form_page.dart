import 'package:bm_binus/data/models/users_model.dart';
import 'package:flutter/material.dart';

enum UserFormMode { add, edit }

class UserFormPage extends StatefulWidget {
  final UserFormMode mode;
  final UserModel? user;

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
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late UserRole _selectedRole;
  late bool _isAktif;

  bool get isAddMode => widget.mode == UserFormMode.add;
  bool get isEditMode => widget.mode == UserFormMode.edit;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.user?.nama ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _selectedRole = widget.user?.role ?? UserRole.staff;
    _isAktif = widget.user?.isAktif ?? true;
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header dengan Avatar
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blueGrey[700],
                          radius: 50,
                          child: Icon(
                            isAddMode ? Icons.person_add : Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (isEditMode)
                          Text(
                            'ID: ${widget.user!.id}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                      ],
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
                      if (value == null || value.isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      if (!value.contains('@')) {
                        return 'Email tidak valid';
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
                        child: Text(_getRoleText(role)),
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

                  // Form Status
                  const Text(
                    'Status',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      color: Colors.grey[50],
                    ),
                    child: SwitchListTile(
                      title: Text(
                        _isAktif ? 'Aktif' : 'Tidak Aktif',
                        style: TextStyle(
                          color: _isAktif ? Colors.green[700] : Colors.red[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: _isAktif,
                      onChanged: (value) {
                        setState(() {
                          _isAktif = value;
                        });
                      },
                      secondary: Icon(
                        _isAktif ? Icons.check_circle : Icons.cancel,
                        color: _isAktif ? Colors.green[700] : Colors.red[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Tombol Aksi - Conditional berdasarkan mode
                  if (isAddMode)
                    // Tombol untuk Add Mode
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // TODO: Implementasi simpan user baru
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
                              // TODO: Implementasi hapus user
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
                                // TODO: Implementasi update user
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
      ),
    );
  }

  String _getRoleText(UserRole role) {
    switch (role) {
      case UserRole.staff:
        return 'Staff';
      case UserRole.bm:
        return 'BM';
      case UserRole.iss:
        return 'ISS';
    }
  }
}
