import 'package:bm_binus/data/dummy/event_type_data.dart';
import 'package:bm_binus/data/models/event_type_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'event_type_form_page.dart';

class EventTypePage extends StatelessWidget {
  const EventTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    final eventTypes = EventTypeData.getAllEventTypes();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Data Event Type",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  context.push(
                    '/event-type-form',
                    extra: {'mode': FormMode.add},
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text("Tambah Event Type"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
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
                              rows: eventTypes.asMap().entries.map((entry) {
                                int index = entry.key;
                                EventTypeModel eventType = entry.value;

                                return DataRow(
                                  onSelectChanged: (selected) {
                                    if (selected != null && selected) {
                                      context.push(
                                        '/event-type-form',
                                        extra: {
                                          'mode': FormMode.edit,
                                          'eventType': eventType,
                                        },
                                      );
                                    }
                                  },
                                  cells: [
                                    DataCell(Text('${index + 1}')),
                                    DataCell(
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.blue[50],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              Icons.event,
                                              color: Colors.blue[700],
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            eventType.jenisEvent,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
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

  Color _getPriorityColor(int priority) {
    if (priority >= 80) {
      return Colors.red[700]!; // High priority
    } else if (priority >= 50) {
      return Colors.orange[700]!; // Medium priority
    } else {
      return Colors.green[700]!; // Low priority
    }
  }
}