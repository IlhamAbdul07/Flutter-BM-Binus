import 'package:bm_binus/data/models/event_type_model.dart';
import 'package:bm_binus/presentation/bloc/event_type/event_type_bloc.dart';
import 'package:bm_binus/presentation/bloc/event_type/event_type_event.dart';
import 'package:bm_binus/presentation/bloc/event_type/event_type_state.dart';
import 'package:bm_binus/presentation/widgets/custom_dialog.dart';
import 'package:bm_binus/presentation/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

enum FormMode { add, edit }

class EventTypeFormPage extends StatefulWidget {
  final FormMode mode;
  final EventType? eventType;

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
  late int _eventTypeId;
  late TextEditingController _jenisEventController;
  late TextEditingController _priorityController;

  bool get isAddMode => widget.mode == FormMode.add;
  bool get isEditMode => widget.mode == FormMode.edit;

  @override
  void initState() {
    super.initState();
    _jenisEventController = TextEditingController(
      text: widget.eventType?.name ?? '',
    );
    _priorityController = TextEditingController(
      text: widget.eventType?.priority.toString() ?? '',
    );
    _eventTypeId = widget.eventType?.id ?? 0;
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
        title: Text(isAddMode ? 'Tambah Event Type' : 'Edit Event Type', style: const TextStyle(fontWeight: FontWeight.bold),),
        elevation: 0,
      ),
      body: BlocConsumer<EventTypeBloc, EventTypeState>(
        listener: (context, state) async {
          if (state.isSuccessTrx){
            CustomSnackBar.show(
              context,
              icon: Icons.check_circle,
              title: (state.typeTrx != null ? (
                state.typeTrx == "create" ? "Success Create Event Type" : 
                state.typeTrx == "update" ? "Success Update Event Type" : 
                state.typeTrx == "delete" ? "Success Delete Event Type" : "") 
                : ""),
              message: (state.typeTrx != null ? (
                state.typeTrx == "create" ? "Event Type berhasil ditambahkan" : 
                state.typeTrx == "update" ? "Event Type berhasil diedit" : 
                state.typeTrx == "delete" ? "Event Type berhasil dihapus" : "") 
                : ""),
              color: Colors.green,
            );
            state.copyWith(isSuccessTrx: false);
            state.copyWith(typeTrx: null);
            await Future.delayed(const Duration(seconds: 1));
            if (context.mounted) {
              context.pop(true);
            }
          } else if (state.errorTrx != null){
            CustomSnackBar.show(
              context,
              icon: Icons.error,
              title: (state.typeTrx != null ? (
                state.typeTrx == "create" ? "Failed Create User" : 
                state.typeTrx == "update" ? "Failed Update User" : 
                state.typeTrx == "delete" ? "Failed Delete User" : "") 
                : ""),
              message: state.errorTrx!,
              color: Colors.red,
            );
            state.copyWith(errorTrx: null);
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: Text(
                '⏳ Mohon tunggu, sedang memuat data...',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return SingleChildScrollView(
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
                            child: Container(
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
                              hintText: 'Masukkan nama jenis event',
                              prefixIcon: const Icon(Icons.category),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama jenis event tidak boleh kosong';
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
                              hintText: 'Masukkan priority (angka 1 - 9)',
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
                              if (priority < 1) {
                                return 'Nilai priority minimal 1';
                              }
                              if (priority > 9) {
                                return 'Nilai priority maksimal 9';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

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
                                    'Nilai priority yang lebih kecil akan ditampilkan di urutan atas',
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
                                    context.read<EventTypeBloc>().add(CreateEventTypeRequested(_jenisEventController.text, int.parse(_priorityController.text)));
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
                                      CustomDialog.show(
                                        context,
                                        icon: Icons.delete,
                                        iconColor: Colors.red,
                                        title: "Konfirmasi Hapus Event Type",
                                        message: "Apakah anda yakin menghapus event type ini?",
                                        confirmText: "Ya, hapus",
                                        confirmColor: Colors.red,
                                        cancelText: "Batal",
                                        cancelColor: Colors.black,
                                        onConfirm: () {
                                          context.read<EventTypeBloc>().add(DeleteEventTypeRequested(_eventTypeId));
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.delete),
                                    label: const Text('Hapus'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      side: const BorderSide(color: Colors.red),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 2,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        String? name;
                                        int? priority;
                                        if (_jenisEventController.text != widget.eventType?.name){
                                          name = _jenisEventController.text;
                                        }
                                        if (int.parse(_priorityController.text) != widget.eventType?.priority){
                                          priority = int.parse(_priorityController.text);
                                        }
                                        context.read<EventTypeBloc>().add(UpdateEventTypeRequested(_eventTypeId, name, priority));
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
          );
        }, 
      )
    );
  }
}
