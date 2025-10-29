import 'package:bm_binus/core/constants.dart/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_table_view/material_table_view.dart';
import 'package:intl/intl.dart';

class PengajuanPage extends StatefulWidget {
  const PengajuanPage({super.key});

  @override
  State<PengajuanPage> createState() => _PengajuanPageState();
}

class _PengajuanPageState extends State<PengajuanPage> {
  final data = [
    {
      'no': 1,
      'staff': 'Andi Saputra',
      'event': 'Pembersihan Gedung A',
      'lokasi': 'Kampus Anggrek',
      'tglMulai': DateTime(2025, 10, 1),
      'tglSelesai': DateTime(2025, 10, 3),
      'eventTipe': 'Maintenance',
      'tglDibuat': DateTime(2025, 9, 29),
    },
    {
      'no': 2,
      'staff': 'Budi Santoso',
      'event': 'Audit Kebersihan',
      'lokasi': 'Kampus Syahdan',
      'tglMulai': DateTime(2025, 10, 5),
      'tglSelesai': DateTime(2025, 10, 6),
      'eventTipe': 'Inspection',
      'tglDibuat': DateTime(2025, 9, 30),
    },
  ];

  String _fmt(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Pengajuan Event",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: size.height * 0.075,
                  child: TextButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        CustomColors.oranges,
                      ),
                      iconColor: MaterialStateProperty.all(Colors.white),
                      iconSize: MaterialStateProperty.all(20.0),
                    ),
                    onPressed: () {
                      context.go('/addevent');
                    },
                    label: const Text(
                      "Tambah Event",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),

          // 🔹 TABLE SECTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SizedBox(
              height: size.height * 0.75,
              child: Scrollbar(
                thumbVisibility: true,
                interactive: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 1300, // total approximate width
                    child: TableView.builder(
                      columns: columns,
                      rowCount: data.length,
                      rowHeight: rowHeight,
                      headerHeight: rowHeight,
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
                                ),
                              ),
                            ),
                          );
                        });
                      },
                      rowBuilder: (context, row, contentBuilder) {
                        final item = data[row];
                        return contentBuilder(context, (ctx, col) {
                          switch (col) {
                            case 0:
                              return Text('${item['no']}');
                            case 1:
                              return Text('${item['staff']}');
                            case 2:
                              return Text('${item['event']}');
                            case 3:
                              return Text('${item['lokasi']}');
                            case 4:
                              return Text(_fmt(item['tglMulai'] as DateTime));
                            case 5:
                              return Text(_fmt(item['tglSelesai'] as DateTime));
                            case 6:
                              return Text('${item['eventTipe']}');
                            case 7:
                              return Text(_fmt(item['tglDibuat'] as DateTime));
                            case 8:
                              return Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade600,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'FREEZE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            default:
                              return const SizedBox.shrink();
                          }
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
