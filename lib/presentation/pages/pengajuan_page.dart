import 'package:bm_binus/core/constants/custom_colors.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_bloc.dart';
import 'package:bm_binus/presentation/bloc/auth/auth_state.dart';
import 'package:bm_binus/presentation/bloc/pengajuan/event_bloc.dart';
import 'package:bm_binus/presentation/bloc/pengajuan/event_event.dart';
import 'package:bm_binus/presentation/bloc/pengajuan/event_state.dart';
import 'package:bm_binus/presentation/bloc/pengajuan/priority_bloc.dart';
import 'package:bm_binus/presentation/bloc/pengajuan/priority_event.dart';
import 'package:bm_binus/presentation/bloc/pengajuan/priority_state.dart';
import 'package:bm_binus/presentation/widgets/priority_dialog.dart';
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
    const rowHeight = 56.0;
 
    // ✅ MODIFIKASI 1: Tetap pakai TableColumn
    final columns = <TableColumn>[
      TableColumn(width: 56.0), // No
      TableColumn(width: 160.0), // Nama Staf
      TableColumn(width: 220.0), // Nama Event
      TableColumn(width: 160.0), // Lokasi Event
      TableColumn(width: 140.0), // Tgl Mulai
      TableColumn(width: 140.0), // Tgl Selesai
      TableColumn(width: 140.0), // Event Tipe
      TableColumn(width: 140.0), // Tgl Dibuat
      TableColumn(width: 120.0), // Status (akan di-freeze)
    ];
 
    // Hitung total width untuk scrollable columns
 
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // 📌 HEADER SECTION (tidak ada perubahan)
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
                    switch (authState.roleName) {
                      case 'Staf Binus':
                        return const AddEventButton();
                      case 'Building Management':
                        final eventState = context.watch<EventBloc>().state;
                        List<EventModel> data = [];
 
                        if (eventState is EventLoaded) {
                          data = eventState.events;
                        } else if (eventState is EventOperationSuccess) {
                          data = eventState.events;
                        }
 
                        return PrioritySwitchButton(data: data);
                      case 'Admin ISS':
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
                // Loading State (tidak ada perubahan)
                if (state is EventLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
 
                // Error State (tidak ada perubahan)
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
 
                // Get data dari state (tidak ada perubahan)
                List<EventModel> data = [];
                if (state is EventLoaded) {
                  data = state.events;
                } else if (state is EventOperationSuccess) {
                  data = state.events;
                }
 
                // Empty State (tidak ada perubahan)
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
 
                // ✅ MODIFIKASI 2: TABLE dengan Frozen Column dan Scrollbar
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 2,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              // Hitung lebar scrollable columns
                              final scrollableWidth = columns
                                  .sublist(0, 8)
                                  .fold<double>(
                                    0,
                                    (sum, col) => sum + col.width,
                                  );
 
                              // Controller untuk sinkronisasi scroll
                              final ScrollController horizontalController =
                                  ScrollController();
                              final ScrollController verticalController =
                                  ScrollController();
                              final ScrollController frozenVerticalController =
                                  ScrollController();
 
                              // Listener untuk sinkronisasi scroll vertikal
                              verticalController.addListener(() {
                                if (frozenVerticalController.hasClients) {
                                  frozenVerticalController.jumpTo(
                                    verticalController.offset,
                                  );
                                }
                              });
 
                              frozenVerticalController.addListener(() {
                                if (verticalController.hasClients) {
                                  verticalController.jumpTo(
                                    frozenVerticalController.offset,
                                  );
                                }
                              });
 
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ✅ Scrollable Columns (8 kolom pertama)
                                  Expanded(
                                    child: Scrollbar(
                                      controller: horizontalController,
                                      thumbVisibility: true,
                                      interactive: true,
                                      thickness: 12,
                                      radius: const Radius.circular(6),
                                      child: SingleChildScrollView(
                                        controller: horizontalController,
                                        scrollDirection: Axis.horizontal,
                                        child: SizedBox(
                                          width: scrollableWidth,
                                          child: Column(
                                            children: [
                                              // Header untuk scrollable columns
                                              Container(
                                                height: rowHeight,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade100,
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color:
                                                          Colors.grey.shade300,
                                                      width: 2,
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  children:
                                                      [
                                                        'No',
                                                        'Nama Staf',
                                                        'Nama Event',
                                                        'Lokasi Event',
                                                        'Tgl Mulai',
                                                        'Tgl Selesai',
                                                        'Event Tipe',
                                                        'Tgl Dibuat',
                                                      ].asMap().entries.map((
                                                        entry,
                                                      ) {
                                                        return Container(
                                                          width:
                                                              columns[entry.key]
                                                                  .width,
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 8.0,
                                                              ),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              entry.value,
                                                              style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                ),
                                              ),
                                              // Body untuk scrollable columns
                                              Expanded(
                                                child: ListView.builder(
                                                  controller:
                                                      verticalController,
                                                  physics:
                                                      const ClampingScrollPhysics(),
                                                  itemCount: data.length,
                                                  itemBuilder: (context, index) {
                                                    final item = data[index];
                                                    return InkWell(
                                                      onTap: () =>
                                                          _onRowTap(item),
                                                      hoverColor:
                                                          Colors.orange.shade50,
                                                      child: Container(
                                                        height: rowHeight,
                                                        decoration: BoxDecoration(
                                                          border: Border(
                                                            bottom: BorderSide(
                                                              color: Colors
                                                                  .grey
                                                                  .shade200,
                                                              width: 1,
                                                            ),
                                                          ),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            // Kolom 0: No
                                                            Container(
                                                              width: columns[0]
                                                                  .width,
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        8.0,
                                                                    vertical:
                                                                        12.0,
                                                                  ),
                                                              child: Text(
                                                                '${item.no}',
                                                                style:
                                                                    const TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                    ),
                                                              ),
                                                            ),
                                                            // Kolom 1: Nama Staf
                                                            Container(
                                                              width: columns[1]
                                                                  .width,
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        8.0,
                                                                    vertical:
                                                                        12.0,
                                                                  ),
                                                              child: Text(
                                                                item.staff,
                                                                style:
                                                                    const TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                    ),
                                                              ),
                                                            ),
                                                            // Kolom 2: Nama Event
                                                            Container(
                                                              width: columns[2]
                                                                  .width,
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        8.0,
                                                                    vertical:
                                                                        12.0,
                                                                  ),
                                                              child: Text(
                                                                item.event,
                                                                style: const TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                            // Kolom 3: Lokasi Event
                                                            Container(
                                                              width: columns[3]
                                                                  .width,
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        8.0,
                                                                    vertical:
                                                                        12.0,
                                                                  ),
                                                              child: Text(
                                                                item.lokasi,
                                                                style:
                                                                    const TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                    ),
                                                              ),
                                                            ),
                                                            // Kolom 4: Tgl Mulai
                                                            Container(
                                                              width: columns[4]
                                                                  .width,
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        8.0,
                                                                    vertical:
                                                                        12.0,
                                                                  ),
                                                              child: Text(
                                                                _fmt(
                                                                  item.tglMulai,
                                                                ),
                                                                style:
                                                                    const TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                    ),
                                                              ),
                                                            ),
                                                            // Kolom 5: Tgl Selesai
                                                            Container(
                                                              width: columns[5]
                                                                  .width,
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        8.0,
                                                                    vertical:
                                                                        12.0,
                                                                  ),
                                                              child: Text(
                                                                _fmt(
                                                                  item.tglSelesai,
                                                                ),
                                                                style:
                                                                    const TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                    ),
                                                              ),
                                                            ),
                                                            // Kolom 6: Event Tipe
                                                            Container(
                                                              width: columns[6]
                                                                  .width,
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        8.0,
                                                                    vertical:
                                                                        12.0,
                                                                  ),
                                                              child: Text(
                                                                item.eventTipe,
                                                                style:
                                                                    const TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                    ),
                                                              ),
                                                            ),
                                                            // Kolom 7: Tgl Dibuat
                                                            Container(
                                                              width: columns[7]
                                                                  .width,
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        8.0,
                                                                    vertical:
                                                                        12.0,
                                                                  ),
                                                              child: Text(
                                                                _fmt(
                                                                  item.tglDibuat,
                                                                ),
                                                                style:
                                                                    const TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
 
                                  // ✅ Frozen "Status" Column (tetap di kanan)
                                  Container(
                                    width: columns[8].width,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 2,
                                        ),
                                      ),
                                      color: Colors.grey.shade50,
                                    ),
                                    child: Column(
                                      children: [
                                        // Header Status
                                        Container(
                                          height: rowHeight,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          child: const Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Status',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Status Cells
                                        Expanded(
                                          child: ListView.builder(
                                            controller:
                                                frozenVerticalController,
                                            physics:
                                                const ClampingScrollPhysics(),
                                            itemCount: data.length,
                                            itemBuilder: (context, index) {
                                              final item = data[index];
                                              return InkWell(
                                                onTap: () => _onRowTap(item),
                                                hoverColor:
                                                    Colors.orange.shade50,
                                                child: Container(
                                                  height: rowHeight,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 12.0,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        color: Colors
                                                            .grey
                                                            .shade200,
                                                        width: 1,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 6,
                                                            horizontal: 12,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: _getStatusColor(
                                                          item.status,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        item.status
                                                            .toUpperCase(),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 11,
                                                        ),
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
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
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
  final List<EventModel> data;
 
  const PrioritySwitchButton({super.key, required this.data});
 
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
 
    return BlocBuilder<PriorityBloc, PriorityState>(
      builder: (context, state) {
        return SizedBox(
          height: size.height * 0.075,
          child: TextButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: state.usePriority ? Colors.orange : Colors.grey,
              iconColor: Colors.white,
              iconSize: 20.0,
            ),
            onPressed: state.isLoading
                ? null
                : () async {
                    if (!state.usePriority) {
                      // 🟢 Kalau sedang OFF dan mau dinyalakan → buka dialog
                      final hasil = await PriorityDialog.show(
                        context,
                        events: data,
                      );
 
                      if (hasil != null) {
                        hasil.forEach((eventName, value) {
                          print('Event: $eventName | Nilai: $value');
                        });
 
                        // Kirim event ke bloc setelah selesai dialog
                        context.read<PriorityBloc>().add(
                          TogglePriorityEvent(true),
                        );
                      }
                    } else {
                      // 🔴 Kalau sedang ON dan mau dimatikan → langsung toggle tanpa dialog
                      context.read<PriorityBloc>().add(
                        TogglePriorityEvent(false),
                      );
                    }
                  },
 
            label: Text(
              state.usePriority ? "Priority: ON" : "Priority: OFF",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: Icon(state.usePriority ? Icons.star : Icons.star_border),
          ),
        );
      },
    );
  }
}
 