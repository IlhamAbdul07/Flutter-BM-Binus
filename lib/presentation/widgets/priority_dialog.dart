import 'package:flutter/material.dart';
import 'package:bm_binus/data/models/event_model.dart';

class PriorityDialog extends StatefulWidget {
  final List<EventModel>? events;

  const PriorityDialog({super.key, this.events});

  static Future<Map<String, int>?> show(
    BuildContext context, {
    List<EventModel>? events,
  }) {
    return showDialog<Map<String, int>>(
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
    // Ambil data dari parameter, fallback ke dummy kalau kosong
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
    final maxDialogWidth = 400.0;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxDialogWidth,
            minWidth: dialogWidth < maxDialogWidth
                ? dialogWidth
                : maxDialogWidth,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Tentukan Kompleksitas Event",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              // daftar event dengan slider
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: _events.map((event) {
                      final value = _sliderValues[event.id] ?? 0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.eventName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Slider(
                                    value: value,
                                    min: 1,
                                    max: 9,
                                    divisions: 9,
                                    label: value.round().toString(),
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

              // tombol OK
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    final Map<String, int> hasil = {};
                    for (var event in _events) {
                      final value = _sliderValues[event.id]?.round() ?? 0;
                      hasil[event.eventName] = value;
                    }
                    Navigator.of(context).pop(hasil);
                  },
                  child: const Text("OK"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
