import 'package:bm_binus/core/constants/custom_colors.dart';
import 'package:bm_binus/data/models/users_model.dart';
import 'package:bm_binus/presentation/bloc/user/user_bloc.dart';
import 'package:bm_binus/presentation/bloc/user/user_event.dart';
import 'package:bm_binus/presentation/bloc/user/user_state.dart';
import 'package:bm_binus/presentation/pages/user_form_page.dart';
import 'package:bm_binus/presentation/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserDataPage extends StatelessWidget {
  const UserDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserBloc()..add(LoadUsersEvent()),
      child: BlocListener<UserBloc, UsersState>(
        listener: (context, state) {
          if (state.errorFetch != null) {
            CustomSnackBar.show(
              context,
              icon: Icons.error,
              title: 'Error Fetch Data User',
              message: state.errorFetch!,
              color: Colors.red,
            );
          }
        },
        child: BlocBuilder<UserBloc, UsersState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: Text(
                  '⏳ Mohon tunggu, sedang memuat data...',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              );
            }

            final users = state.users;

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Data User",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<UserBloc>().add(LoadUsersEvent());
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text(
                              "Refresh",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey[700],
                              iconColor: Colors.white,
                              iconSize: 20.0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<UserBloc>().add(DownloadUsersEvent());
                            },
                            icon: const Icon(Icons.download),
                            label: const Text(
                              "Download",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent[700],
                              iconColor: Colors.white,
                              iconSize: 20.0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          ElevatedButton.icon(
                            onPressed: () async {
                              final result = await context.push(
                                '/user-form',
                                extra: {'mode': UserFormMode.add},
                              );

                              if (result == true && context.mounted) {
                                context.read<UserBloc>().add(LoadUsersEvent());
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: const Text(
                              "Tambah User",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColors.oranges,
                              iconColor: Colors.white,
                              iconSize: 20.0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.95,
                        ),
                        child: Card(
                          elevation: 2,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Column(
                                children: [
                                  // 🔹 HEADER (Tetap diam)
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(minWidth: constraints.maxWidth),
                                      child: DataTable(
                                        headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
                                        showCheckboxColumn: false,
                                        columns: const [
                                          DataColumn(
                                            label: Text('No', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                                          ),
                                          DataColumn(
                                            label: Text('Nama', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                                          ),
                                          DataColumn(
                                            label: Text('Email', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                                          ),
                                          DataColumn(
                                            label: Text('Role', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                                          ),
                                          DataColumn(
                                            label: Text('Tanggal Dibuat', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                                          ),
                                        ],
                                        rows: const [], // header only, tanpa baris kosong
                                      ),
                                    ),
                                  ),

                                  // 🔹 BODY (Scrollable)
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(minWidth: constraints.maxWidth),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: DataTable(
                                            // biar tidak ada padding heading yang bikin baris kosong
                                            headingRowHeight: 0,
                                            showCheckboxColumn: false,
                                            columns: const [
                                              DataColumn(label: Text('')),
                                              DataColumn(label: Text('')),
                                              DataColumn(label: Text('')),
                                              DataColumn(label: Text('')),
                                              DataColumn(label: Text('')),
                                            ],
                                            rows: users.asMap().entries.map((entry) {
                                              int index = entry.key;
                                              Users user = entry.value;

                                              return DataRow(
                                                onSelectChanged: (selected) async {
                                                  if (selected == true) {
                                                    final result = await context.push(
                                                      '/user-form',
                                                      extra: {
                                                        'mode': UserFormMode.edit,
                                                        'user': user,
                                                      },
                                                    );
                                                    if (result == true && context.mounted) {
                                                      context.read<UserBloc>().add(LoadUsersEvent());
                                                    }
                                                  }
                                                },
                                                cells: [
                                                  DataCell(Text('${index + 1}')),
                                                  DataCell(Text(user.name)),
                                                  DataCell(Text(user.email)),
                                                  DataCell(
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                      decoration: BoxDecoration(
                                                        color: _getRoleColor(user.roleId),
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      child: Text(
                                                        user.roleName,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                      decoration: BoxDecoration(
                                                        color: const Color.fromARGB(255, 207, 205, 205),
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      child: Text(
                                                        _formatTime(user.createdAt),
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
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

  Color _getRoleColor(int roleId) {
    switch (roleId) {
      case 1:
        return Colors.blue[700]!;
      case 2:
        return Colors.purple[700]!;
      case 3:
        return Colors.orange[700]!;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime timestamp) {
    final List<String> monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];

    final day = timestamp.day.toString().padLeft(2, '0');
    final month = monthNames[timestamp.month - 1];
    final year = timestamp.year;
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');

    return '$day $month $year, $hour:$minute';
  }
}