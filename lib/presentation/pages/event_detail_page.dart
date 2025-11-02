import 'package:bm_binus/core/constants.dart/custom_colors.dart';
import 'package:bm_binus/presentation/bloc/pengajuan/event_bloc.dart';
import 'package:bm_binus/presentation/bloc/pengajuan/event_event.dart';
import 'package:bm_binus/presentation/bloc/pengajuan/event_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:bm_binus/data/models/event_model.dart';

class EventDetailPage extends StatefulWidget {
  final EventModel event;

  const EventDetailPage({super.key, required this.event});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _staffController;
  late TextEditingController _eventController;
  late TextEditingController _lokasiController;
  late TextEditingController _tglMulaiController;
  late TextEditingController _tglSelesaiController;
  late TextEditingController _eventTipeController;
  late TextEditingController _statusController;

  late DateTime _tglMulai;
  late DateTime _tglSelesai;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _staffController = TextEditingController(text: widget.event.staff);
    _eventController = TextEditingController(text: widget.event.event);
    _lokasiController = TextEditingController(text: widget.event.lokasi);
    _eventTipeController = TextEditingController(text: widget.event.eventTipe);
    _statusController = TextEditingController(text: widget.event.status);

    _tglMulai = widget.event.tglMulai;
    _tglSelesai = widget.event.tglSelesai;

    _tglMulaiController = TextEditingController(
      text: DateFormat('dd MMM yyyy').format(_tglMulai),
    );
    _tglSelesaiController = TextEditingController(
      text: DateFormat('dd MMM yyyy').format(_tglSelesai),
    );
  }

  @override
  void dispose() {
    _staffController.dispose();
    _eventController.dispose();
    _lokasiController.dispose();
    _tglMulaiController.dispose();
    _tglSelesaiController.dispose();
    _eventTipeController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _tglMulai : _tglSelesai,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _tglMulai = picked;
          _tglMulaiController.text = DateFormat('dd MMM yyyy').format(picked);
        } else {
          _tglSelesai = picked;
          _tglSelesaiController.text = DateFormat('dd MMM yyyy').format(picked);
        }
      });
    }
  }

  void _handleUpdate() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isUpdating = true);

      final updatedEvent = widget.event.copyWith(
        staff: _staffController.text,
        event: _eventController.text,
        lokasi: _lokasiController.text,
        tglMulai: _tglMulai,
        tglSelesai: _tglSelesai,
        eventTipe: _eventTipeController.text,
        status: _statusController.text,
      );

      // Trigger update event (hanya snackbar)
      context.read<EventBloc>().add(UpdateEvent(updatedEvent));
    }
  }

  void _handleDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus event ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Trigger delete event (hanya snackbar)
              context.read<EventBloc>().add(DeleteEvent(widget.event.no));
              // Langsung kembali ke pengajuan page
              context.pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengajuan Event'),
        backgroundColor: CustomColors.oranges,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<EventBloc, EventState>(
        listener: (context, state) {
          if (state is EventOperationSuccess) {
            setState(() => _isUpdating = false);

            // Tampil snackbar sukses
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );

            // TIDAK pop, tetap di halaman detail
            // Data di form tetap bisa diedit lagi
          } else if (state is EventError) {
            setState(() => _isUpdating = false);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Card
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.info_outline, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(
                              'Event #${widget.event.no}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Dibuat: ${DateFormat('dd MMM yyyy').format(widget.event.tglDibuat)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                size: 16,
                                color: Colors.orange.shade700,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Mode Dummy - Data tidak akan tersimpan',
                                style: TextStyle(
                                  color: Colors.orange.shade700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Form Fields
                _buildTextField(
                  controller: _staffController,
                  label: 'Nama Staf',
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _eventController,
                  label: 'Nama Event',
                  icon: Icons.event,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _lokasiController,
                  label: 'Lokasi Event',
                  icon: Icons.location_on,
                ),
                const SizedBox(height: 16),

                // Date Fields
                Row(
                  children: [
                    Expanded(
                      child: _buildDateField(
                        controller: _tglMulaiController,
                        label: 'Tanggal Mulai',
                        onTap: () => _selectDate(context, true),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDateField(
                        controller: _tglSelesaiController,
                        label: 'Tanggal Selesai',
                        onTap: () => _selectDate(context, false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _eventTipeController,
                  label: 'Tipe Event',
                  icon: Icons.category,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _statusController,
                  label: 'Status',
                  icon: Icons.flag,
                ),
                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isUpdating ? null : _handleUpdate,
                        icon: _isUpdating
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.save),
                        label: Text(
                          _isUpdating ? 'Updating...' : 'Update Event',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.oranges,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isUpdating ? null : _handleDelete,
                        icon: const Icon(Icons.delete),
                        label: const Text('Hapus Event'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.calendar_today),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      readOnly: true,
      onTap: onTap,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }
}
