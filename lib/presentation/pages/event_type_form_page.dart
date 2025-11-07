import 'package:bm_binus/data/models/event_type_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum FormMode { add, edit }

class EventTypeFormPage extends StatefulWidget {
  final FormMode mode;
  final EventTypeModel? eventType;

  const EventTypeFormPage({super.key, required this.mode, this.eventType})
    : assert(
        mode == FormMode.add || (mode == FormMode.edit && eventType != null),
        'EventType must be provided when mode is edit',
      );

  @override
  State<EventTypeFormPage> createState() => _EventTypeFormPageState();
}

class _EventTypeFormPageState extends State<EventTypeFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _jenisEventController;
  late TextEditingController _priorityController;

  bool get isAddMode => widget.mode == FormMode.add;
  bool get isEditMode => widget.mode == FormMode.edit;

  @override
  void initState() {
    super.initState();
    _jenisEventController = TextEditingController(
      text: widget.eventType?.jenisEvent ?? '',
    );
    _priorityController = TextEditingController(
      text: widget.eventType?.priority.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _jenisEventController.dispose();
    _priorityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isAddMode ? 'Tambah Event Type' : 'Edit Event Type'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header dengan Icon
                      Center(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isAddMode ? Icons.add_circle : Icons.edit,
                                size: 60,
                                color: Colors.blue[700],
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (isEditMode)
                              Text(
                                'ID: ${widget.eventType!.id}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Form Jenis Event
                      const Text(
                        'Jenis Event',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _jenisEventController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan jenis event',
                          prefixIcon: const Icon(Icons.category),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Jenis event tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Form Priority
                      const Text(
                        'Priority',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _priorityController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan priority (angka)',
                          prefixIcon: const Icon(Icons.priority_high),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          helperText:
                              'Priority harus unik dan tidak boleh sama dengan yang lain',
                          helperMaxLines: 2,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Priority tidak boleh kosong';
                          }
                          final priority = int.tryParse(value);
                          if (priority == null) {
                            return 'Priority harus berupa angka';
                          }
                          if (priority <= 0) {
                            return 'Priority harus lebih besar dari 0';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),

                      // Info Priority
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue[700],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Nilai priority yang lebih besar akan ditampilkan di urutan atas',
                                style: TextStyle(
                                  color: Colors.blue[900],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Tombol Aksi - Conditional berdasarkan mode
                      if (isAddMode)
                        // Tombol untuk Add Mode
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // TODO: Implementasi simpan event type baru
                              }
                            },
                            icon: const Icon(Icons.check),
                            label: const Text('Simpan'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        )
                      else
                        // Tombol untuk Edit Mode
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  // TODO: Implementasi hapus event type
                                },
                                icon: const Icon(Icons.delete),
                                label: const Text('Hapus'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // TODO: Implementasi update event type
                                  }
                                },
                                icon: const Icon(Icons.save),
                                label: const Text('Update'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
