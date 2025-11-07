import 'package:bm_binus/core/constants/custom_colors.dart';
import 'package:bm_binus/data/dummy/users_data.dart';
import 'package:bm_binus/data/models/users_model.dart';
import 'package:bm_binus/presentation/pages/user_form_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserDataPage extends StatelessWidget {
  const UserDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    final users = UserData.getAllUsers();

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
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  context.push('/user-form', extra: {'mode': UserFormMode.add});
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
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                              showCheckboxColumn: false,
                              headingRowColor: MaterialStateProperty.all(
                                Colors.grey[100],
                              ),
                              columns: const [
                                DataColumn(
                                  label: Text(
                                    'No',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Nama',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Email',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Role',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Status',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                              rows: users.asMap().entries.map((entry) {
                                int index = entry.key;
                                UserModel user = entry.value;

                                return DataRow(
                                  onSelectChanged: (selected) {
                                    if (selected == true) {
                                      context.push(
                                        '/user-form',
                                        extra: {
                                          'mode': UserFormMode.edit,
                                          'user': user,
                                        },
                                      );
                                    }
                                  },
                                  cells: [
                                    DataCell(Text('${index + 1}')),
                                    DataCell(
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                Colors.blueGrey[700],
                                            radius: 16,
                                            child: Text(
                                              user.nama[0].toUpperCase(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(user.nama),
                                        ],
                                      ),
                                    ),
                                    DataCell(Text(user.email)),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getRoleColor(user.role),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          user.roleText,
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
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: user.isAktif
                                              ? Colors.green[100]
                                              : Colors.red[100],
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          user.statusText,
                                          style: TextStyle(
                                            color: user.isAktif
                                                ? Colors.green[800]
                                                : Colors.red[800],
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
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.staff:
        return Colors.blue[700]!;
      case UserRole.bm:
        return Colors.purple[700]!;
      case UserRole.iss:
        return Colors.orange[700]!;
    }
  }
}