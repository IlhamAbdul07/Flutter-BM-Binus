import 'package:flutter/material.dart';
import 'package:bm_binus/data/models/event_model.dart';

class PriorityDialog extends StatefulWidget {
  final List<EventModel>? events;

  const PriorityDialog({super.key, this.events});

  static Future<List<Map<String, dynamic>>?> show(
    BuildContext context, {
    List<EventModel>? events,
  }) {
    return showDialog<List<Map<String, dynamic>>>(
      context: context,
      builder: (context) => PriorityDialog(events: events),
    );
  }

  @override
  State<PriorityDialog> createState() => _PriorityDialogState();
}

class _PriorityDialogState extends State<PriorityDialog> {
  late final List<EventModel> _events;
  final Map<int, double> _sliderValues = {}; // Simpan nilai tiap event (0–100)

  @override
  void initState() {
    super.initState();
    _events = (widget.events != null && widget.events!.isNotEmpty)
        ? widget.events!
        : [];

    for (var event in _events) {
      _sliderValues[event.id] = 1; // default value
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dialogWidth = size.width * 0.8;
    const maxDialogWidth = 400.0;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxDialogWidth,
            minWidth:
                dialogWidth < maxDialogWidth ? dialogWidth : maxDialogWidth,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Tentukan Kompleksitas Event",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),

              // 🔹 Info box biru
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,  // Atur agar ikon tetap di tengah
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Atur nilai kompleksitas setiap event dari 1 hingga 9.\n"
                        "Nilai lebih tinggi menunjukkan event lebih kompleks, artinya semakin tidak diprioritaskan. "
                        "Bisa diukur dari tingkat kesulitan pelaksanaan, koordinasi, serta kebutuhan sumber daya dan waktu.",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue.shade800,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                )
              ),

              const SizedBox(height: 16),

              // daftar event dengan slider
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: _events.map((event) {
                      final value = _sliderValues[event.id] ?? 0;
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.eventName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: Slider(
                                    value: value,
                                    min: 1,
                                    max: 9,
                                    divisions: 9,
                                    label: value.round().toString(),
                                    activeColor: Colors.blue,
                                    inactiveColor: Colors.blue.shade100,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _sliderValues[event.id] = newValue;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                  child: Text(
                                    value.round().toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  onPressed: () {
                    final List<Map<String, dynamic>> hasil = _events.map((event) {
                      return {
                        "id": event.id,
                        "event_name": event.eventName,
                        "complexity": _sliderValues[event.id]?.round() ?? 0,
                      };
                    }).toList();

                    Navigator.of(context).pop(hasil);
                  },
                  icon: const Icon(Icons.check),
                  label: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
