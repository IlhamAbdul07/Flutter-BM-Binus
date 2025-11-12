import 'package:bm_binus/core/constants/custom_colors.dart';
import 'package:bm_binus/data/models/event_type_model.dart';
import 'package:bm_binus/presentation/bloc/event_type/event_type_bloc.dart';
import 'package:bm_binus/presentation/bloc/event_type/event_type_event.dart';
import 'package:bm_binus/presentation/bloc/event_type/event_type_state.dart';
import 'package:bm_binus/presentation/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'event_type_form_page.dart';

class EventTypePage extends StatelessWidget {
  const EventTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EventTypeBloc()..add(LoadEventTypeEvent()),
      child: BlocListener<EventTypeBloc, EventTypeState>(
        listener: (context, state){
          if (state.errorFetch != null) {
            CustomSnackBar.show(
              context,
              icon: Icons.error,
              title: 'Error Fetch Data Event Type',
              message: state.errorFetch!,
              color: Colors.red,
            );
          }
        },
        child: BlocBuilder<EventTypeBloc, EventTypeState>(
          builder: (context, state){
            if (state.isLoading) {
              return const Center(
                child: Text(
                  '⏳ Mohon tunggu, sedang memuat data...',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              );
            }

            final eventType = state.eventType;

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Data Event Type",
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 12),
                          if (state.infoFetch != null && state.infoFetch!.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                color: state.infoFetch!.toLowerCase().contains("duplikat")
                                    ? Colors.amber[600]
                                    : Colors.green[600],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                state.infoFetch!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<EventTypeBloc>().add(LoadEventTypeEvent());
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
                            onPressed: () async {
                              final result = await context.push(
                                '/event-type-form',
                                extra: {'mode': FormMode.add},
                              );
                              if (result == true && context.mounted) {
                                context.read<EventTypeBloc>().add(LoadEventTypeEvent());
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: const Text(
                              "Tambah Event Type",
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
                          child: Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
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
                                            'Jenis Event',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Priority',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          numeric: true,
                                        ),
                                      ],
                                      rows: eventType.asMap().entries.map((entry) {
                                        int index = entry.key;
                                        EventType eventType = entry.value;

                                        return DataRow(
                                          onSelectChanged: (selected) async {
                                            if (selected != null && selected) {
                                              final result = await context.push(
                                                '/event-type-form',
                                                extra: {
                                                  'mode': FormMode.edit,
                                                  'eventType': eventType,
                                                },
                                              );
                                              if (result == true && context.mounted) {
                                                context.read<EventTypeBloc>().add(LoadEventTypeEvent());
                                              }
                                            }
                                          },
                                          cells: [
                                            DataCell(Text('${index + 1}')),
                                            DataCell(
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue[50],
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  eventType.name,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: _getPriorityColor(
                                                    eventType.priority,
                                                  ),
                                                  borderRadius: BorderRadius.circular(
                                                    12,
                                                  ),
                                                ),
                                                child: Text(
                                                  eventType.priority.toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    if (priority < 3) {
      return Colors.red[700]!; // High priority
    } else if (priority < 5) {
      return Colors.orange[700]!; // Medium priority
    } else if (priority < 7) {
      return Colors.yellow[700]!; // Medium priority
    } else if (priority < 9) {
      return Colors.green[700]!; // Medium priority
    } else {
      return Colors.blue[700]!; // Low priority
    }
  }
}