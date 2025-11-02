import 'package:bm_binus/core/constants.dart/custom_colors.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_bloc.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_state.dart';
import 'package:bm_binus/presentation/bloc/pengajuan/event_bloc.dart';
import 'package:bm_binus/presentation/bloc/pengajuan/event_event.dart';
import 'package:bm_binus/presentation/bloc/pengajuan/event_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_table_view/material_table_view.dart';
import 'package:intl/intl.dart';
import 'package:bm_binus/data/models/event_model.dart';

class PengajuanPage extends StatefulWidget {
  const PengajuanPage({super.key});

  @override
  State<PengajuanPage> createState() => _PengajuanPageState();
}

class _PengajuanPageState extends State<PengajuanPage> {
  @override
  void initState() {
    super.initState();
    // Load events saat page dibuka
    context.read<EventBloc>().add(LoadEvents());
  }

  String _fmt(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  // 🎨 Fungsi untuk warna status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'diajukan':
        return Colors.orange;
      case 'validasi':
        return Colors.blue;
      case 'disetujui':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // 🎯 Fungsi untuk handle klik row
  void _onRowTap(EventModel event) {
    // Set selected event di BLoC
    context.read<EventBloc>().add(SelectEvent(event));

    // Navigate ke detail page dengan data
    context.push('/event-detail', extra: event);
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    const rowHeight = 56.0;

    final columns = <TableColumn>[
      TableColumn(width: 56.0), // No
      TableColumn(width: 160.0), // Nama Staf
      TableColumn(width: 220.0), // Nama Event
      TableColumn(width: 160.0), // Lokasi Event
      TableColumn(width: 140.0), // Tgl Mulai
      TableColumn(width: 140.0), // Tgl Selesai
      TableColumn(width: 140.0), // Event Tipe
      TableColumn(width: 140.0), // Tgl Dibuat
      TableColumn(
        width: 120.0,
        sticky: true,
        freezePriority: 100,
      ), // Status (freeze)
    ];

    return Scaffold(
      body: Column(
        children: [
          // 📌 HEADER SECTION
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Pengajuan Event",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, authState) {
                    // Switch case berdasarkan role
                    switch (authState.role) {
                      case 'staff':
                        return const AddEventButton();
                      case 'bm':
                        return const PrioritySwitchButton();
                      case 'iss':
                        return const SizedBox.shrink();
                      default:
                        return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ),

          // 🔹 TABLE SECTION dengan BLoC
          Expanded(
            child: BlocConsumer<EventBloc, EventState>(
              listener: (context, state) {
                if (state is EventOperationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } else if (state is EventError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              builder: (context, state) {
                // Loading State
                if (state is EventLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Error State
                if (state is EventError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<EventBloc>().add(LoadEvents());
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                // Get data dari state
                List<EventModel> data = [];
                if (state is EventLoaded) {
                  data = state.events;
                } else if (state is EventOperationSuccess) {
                  data = state.events;
                }

                // Empty State
                if (data.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada data event',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // ✅ TABLE dengan Data
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Scrollbar(
                    thumbVisibility: true,
                    interactive: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: 1300,
                        child: TableView.builder(
                          columns: columns,
                          rowCount: data.length,
                          rowHeight: rowHeight,
                          headerHeight: rowHeight,

                          // 📋 HEADER
                          headerBuilder: (context, contentBuilder) {
                            final titles = [
                              'No',
                              'Nama Staf',
                              'Nama Event',
                              'Lokasi Event',
                              'Tgl Mulai',
                              'Tgl Selesai',
                              'Event Tipe',
                              'Tgl Dibuat',
                              'Status',
                            ];
                            return contentBuilder(context, (ctx, col) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    titles[col],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              );
                            });
                          },

                          // 📊 ROW dengan KLIK
                          rowBuilder: (context, row, contentBuilder) {
                            final item = data[row];

                            return InkWell(
                              onTap: () => _onRowTap(item), // 👈 KLIK ROW
                              hoverColor: Colors.orange.shade50, // Hover effect
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade200,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: contentBuilder(context, (ctx, col) {
                                  Widget cellContent;

                                  switch (col) {
                                    case 0:
                                      cellContent = Text(
                                        '${item.no}',
                                        style: const TextStyle(fontSize: 13),
                                      );
                                      break;
                                    case 1:
                                      cellContent = Text(
                                        item.staff,
                                        style: const TextStyle(fontSize: 13),
                                      );
                                      break;
                                    case 2:
                                      cellContent = Text(
                                        item.event,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      );
                                      break;
                                    case 3:
                                      cellContent = Text(
                                        item.lokasi,
                                        style: const TextStyle(fontSize: 13),
                                      );
                                      break;
                                    case 4:
                                      cellContent = Text(
                                        _fmt(item.tglMulai),
                                        style: const TextStyle(fontSize: 13),
                                      );
                                      break;
                                    case 5:
                                      cellContent = Text(
                                        _fmt(item.tglSelesai),
                                        style: const TextStyle(fontSize: 13),
                                      );
                                      break;
                                    case 6:
                                      cellContent = Text(
                                        item.eventTipe,
                                        style: const TextStyle(fontSize: 13),
                                      );
                                      break;
                                    case 7:
                                      cellContent = Text(
                                        _fmt(item.tglDibuat),
                                        style: const TextStyle(fontSize: 13),
                                      );
                                      break;
                                    case 8:
                                      // 🎨 STATUS BADGE dengan WARNA
                                      cellContent = Center(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 6,
                                            horizontal: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(item.status),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            item.status.toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      );
                                      break;
                                    default:
                                      cellContent = const SizedBox.shrink();
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 12.0,
                                    ),
                                    child: Align(
                                      alignment: col == 8
                                          ? Alignment.center
                                          : Alignment.centerLeft,
                                      child: cellContent,
                                    ),
                                  );
                                }),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 CUSTOM WIDGETS (sesuaikan dengan komponen Anda)
class AddEventButton extends StatelessWidget {
  const AddEventButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.oranges,
        iconColor: Colors.white,
        iconSize: 20.0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: () {
        context.go('/addevent');
      },
      label: const Text(
        "Tambah Event",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      icon: const Icon(Icons.add),
    );
  }
}

class PrioritySwitchButton extends StatelessWidget {
  const PrioritySwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.swap_vert, color: Colors.blue.shade700),
          const SizedBox(width: 8),
          Text(
            'Priority Mode',
            style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
