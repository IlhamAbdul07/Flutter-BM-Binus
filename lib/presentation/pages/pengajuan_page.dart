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

  void _loadEventsByRole(String roleName, int? userId) {
    final eventBloc = context.read<EventBloc>();
    if (roleName == 'Staf Binus') {
      eventBloc.add(LoadsEventRequested(userId, null, null));
    } else if (roleName == 'Building Management') {
      eventBloc.add(LoadsEventRequested(null, null, null));
    } else if (roleName == 'Admin ISS') {
      eventBloc.add(LoadsEventRequested(null, null, null));
    }
  }

  String _fmt(DateTime date) => DateFormat('dd MMM yyyy hh:mm a').format(date);

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pengajuan':
        return Colors.orange;
      case 'Validasi':
        return Colors.blue;
      case 'Proses':
        return Colors.purple;
      case 'Finalisasi':
        return Colors.teal;
      default:
        return Colors.green;
    }
  }

  void _onRowTap(EventModel event) {
    context.read<EventBloc>().add(LoadDetailEventRequested(event.id));
    context.push('/event-detail', extra: event);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      _loadEventsByRole(authState.roleName!, authState.id);
    });
  }
 
 
  @override
  Widget build(BuildContext context) {
    const rowHeight = 56.0;
    final columns = <TableColumn>[
      TableColumn(width: 60.0),
      TableColumn(width: 170.0),
      TableColumn(width: 200.0),
      TableColumn(width: 200.0),
      TableColumn(width: 170.0),
      TableColumn(width: 170.0),
      TableColumn(width: 200.0),
      TableColumn(width: 170.0),
      TableColumn(width: 120.0),
    ];
  
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
                Row(
                  children: [
                    const Text(
                      "Pengajuan Event",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: 'Refresh Data',
                      icon: Icon(Icons.refresh, color: Colors.blue.shade700),
                      onPressed: () {
                        final authState = context.read<AuthBloc>().state;
                        _loadEventsByRole(authState.roleName!, authState.id);
                      },
                    ),
                  ],
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, authState) {
                    switch (authState.roleName) {
                      case 'Staf Binus':
                        return Row(
                          children: [
                            DownloadButton(userId: authState.id,),
                            const SizedBox(width: 10,),
                            const AddEventButton(),
                          ],
                        );
                        
                      case 'Building Management':
                        final eventState = context.watch<EventBloc>().state;
                        List<EventModel> data = [];
                        if (eventState.isLoading) {
                          data = eventState.events;
                        } else if (!eventState.isLoading) {
                          data = eventState.events;
                        }
                        return Row(
                          children: [
                            DownloadButton(),
                            const SizedBox(width: 10,),
                            PrioritySwitchButton(data: data)
                          ],
                        );
                      case 'Admin ISS':
                        return DownloadButton(forAdmin: true,);
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
                // if (state is EventOperationSuccess) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(
                //       content: Text(state.message),
                //       backgroundColor: Colors.green,
                //       duration: const Duration(seconds: 2),
                //     ),
                //   );
                // } else if (state is EventError) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(
                //       content: Text(state.message),
                //       backgroundColor: Colors.red,
                //       duration: const Duration(seconds: 2),
                //     ),
                //   );
                // }
              },
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
 
                if (state.errorFetch != null) {
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
                          state.errorFetch!,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            final authState = context.read<AuthBloc>().state;
                            _loadEventsByRole(authState.roleName!, authState.id);
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh Data'),
                        ),
                      ],
                    ),
                  );
                }
 
                List<EventModel> data = [];
                if (state.isLoading) {
                  data = state.events;
                } else if (!state.isLoading) {
                  data = state.events;
                }
                debugPrint(data.toString());

                // filter for admin
                final authState = context.read<AuthBloc>().state;
                if (authState.roleName == 'Admin ISS') {
                  data = data.where((e) => e.statusId == 3 || e.statusId == 4 || e.statusId == 5).toList();
                }
 
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
                                                        'Waktu Mulai',
                                                        'Waktu Selesai',
                                                        'Jenis Event',
                                                        'Tanggal Pengajuan',
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
                                                                  .shade300,
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
                                                                '${index + 1}',
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
                                                                item.userName,
                                                                softWrap: true,
                                                                overflow: TextOverflow.visible,
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
                                                                item.eventName,
                                                                softWrap: true,
                                                                overflow: TextOverflow.visible,
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
                                                                item.eventLocation,
                                                                softWrap: true,
                                                                overflow: TextOverflow.visible,
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
                                                                  item.eventDateStart,
                                                                ),
                                                                softWrap: true,
                                                                overflow: TextOverflow.visible,
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
                                                                  item.eventDateEnd,
                                                                ),
                                                                softWrap: true,
                                                                overflow: TextOverflow.visible,
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
                                                                item.eventTypeName,
                                                                softWrap: true,
                                                                overflow: TextOverflow.visible,
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
                                                                  item.createdAt,
                                                                ),
                                                                softWrap: true,
                                                                overflow: TextOverflow.visible,
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
                                                          item.statusName,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        item.statusName
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

class DownloadButton extends StatelessWidget {
  final int? userId;
  final bool? forAdmin;
  const DownloadButton({super.key, this.userId, this.forAdmin});
 
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(
      builder: (context, eventState) {
        final isDownloading = eventState.isLoadingTrx;
        return SizedBox(
          child: ElevatedButton.icon(
            onPressed: () {
              context.read<EventBloc>().add(DownloadEventRequested(userId, forAdmin));
            },
            icon: isDownloading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white,),
                  )
                : const Icon(Icons.download,color: Colors.white,),
            label: Text(
              "Download",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent[700],
            ),
          ),
        );
      },
    );
  }
}
 
class AddEventButton extends StatelessWidget {
  const AddEventButton({super.key});
 
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextButton.icon(
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
      ),
    );
  }
}
 
class PrioritySwitchButton extends StatelessWidget {
  final List<EventModel> data;
 
  const PrioritySwitchButton({super.key, required this.data});
 
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PriorityBloc, PriorityState>(
      builder: (context, priorityState) {
        return SizedBox(
          child: TextButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: priorityState.usePriority ? Colors.orange : Colors.grey,
            ),
            onPressed: priorityState.isLoading
                ? null
                : () async {
                    if (!priorityState.usePriority) {
                      final hasil = await PriorityDialog.show(context, events: data);
                      if (hasil != null) {
                        context.read<PriorityBloc>().add(TogglePriorityEvent(true));
                      }
                    } else {
                      context.read<PriorityBloc>().add(TogglePriorityEvent(false));
                    }
                  },
            label: Text(
              priorityState.usePriority ? "Priority: ON" : "Priority: OFF",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: Icon(priorityState.usePriority ? Icons.star : Icons.star_border, color: Colors.white,),
          ),
        );
      },
    );
  }
}
 