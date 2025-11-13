import 'package:bm_binus/core/constants/custom_colors.dart';
import 'package:bm_binus/core/constants/ui_helpers.dart';
import 'package:bm_binus/data/dummy/komentar_data.dart';
import 'package:bm_binus/data/models/event_detail_model.dart';
import 'package:bm_binus/presentation/bloc/pengajuan/event_bloc.dart';
// import 'package:bm_binus/presentation/bloc/pengajuan/event_event.dart';
import 'package:bm_binus/presentation/bloc/pengajuan/event_state.dart';
import 'package:bm_binus/presentation/widgets/custom_dialog.dart';
import 'package:bm_binus/presentation/widgets/custom_input_dialog.dart';
import 'package:bm_binus/presentation/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
// import 'package:bm_binus/data/models/event_model.dart';
import 'package:bm_binus/data/models/komentar_model.dart';

class EventDetailPage extends StatefulWidget {
  final EventDetailModel event;

  const EventDetailPage({super.key, required this.event});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _komentarController = TextEditingController();

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

  late List<KomentarModel> _komentarList;

  // Dummy file list
  final List<Map<String, String>> _uploadedFiles = [
    {'name': 'proposal_event.pdf', 'extension': 'PDF'},
    {'name': 'budget_plan.xlsx', 'extension': 'XLSX'},
    {'name': 'venue_photo.jpg', 'extension': 'JPG'},
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadKomentar();
  }

  void _initializeControllers() {
    _staffController = TextEditingController(text: widget.event.userName);
    _eventController = TextEditingController(text: widget.event.eventName);
    _lokasiController = TextEditingController(text: widget.event.eventLocation);
    _eventTipeController = TextEditingController(text: widget.event.eventTypeName);
    _statusController = TextEditingController(text: widget.event.statusName);

    _tglMulai = widget.event.eventDateStart;
    _tglSelesai = widget.event.eventDateEnd;

    _tglMulaiController = TextEditingController(
      text: DateFormat('dd MMM yyyy').format(_tglMulai),
    );
    _tglSelesaiController = TextEditingController(
      text: DateFormat('dd MMM yyyy').format(_tglSelesai),
    );
  }

  void _loadKomentar() {
    _komentarList = KomentarData.getKomentarForEvent(widget.event.id);
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
    _komentarController.dispose();
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

      // final updatedEvent = widget.event.copyWith(
      //   staff: _staffController.text,
      //   event: _eventController.text,
      //   lokasi: _lokasiController.text,
      //   tglMulai: _tglMulai,
      //   tglSelesai: _tglSelesai,
      //   eventTipe: _eventTipeController.text,
      //   status: _statusController.text,
      // );

      // context.read<EventBloc>().add(UpdateEvent(updatedEvent));
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
              // context.read<EventBloc>().add(DeleteEvent(widget.event.id));
              context.pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _handleKirimKomentar() {
    if (_komentarController.text.trim().isEmpty) {
      CustomSnackBar.show(
        context,
        icon: Icons.error,
        title: 'WARNING',
        message: 'Komentar tidak boleh kosong',
        color: Colors.orange,
      );
      return;
    }

    CustomSnackBar.show(
      context,
      icon: Icons.error,
      title: 'SUKSES',
      message: 'Komentar berhasil dikirim!',
      color: Colors.green,
    );
    _komentarController.clear();
    FocusScope.of(context).unfocus();
  }

  void _handleUploadFile() {
    CustomSnackBar.show(
      context,
      icon: Icons.error,
      title: 'INFO',
      message: 'Upload file - Fitur akan segera tersedia',
      color: Colors.blue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Pengajuan Event',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocListener<EventBloc, EventState>(
        listener: (context, state) {
          // if (state is EventOperationSuccess) {
          //   setState(() => _isUpdating = false);

          //   CustomSnackBar.show(
          //     context,
          //     icon: Icons.error,
          //     title: 'SUKSES',
          //     message: state.message,
          //     color: Colors.green,
          //   );
          // } else if (state is EventError) {
          //   setState(() => _isUpdating = false);

          //   CustomSnackBar.show(
          //     context,
          //     icon: Icons.error,
          //     title: 'Error',
          //     message: state.message,
          //     color: Colors.red,
          //   );
          // }
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
                              'Event #${widget.event.id}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Dibuat: ${DateFormat('dd MMM yyyy').format(widget.event.createdAt)}',
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
                const SizedBox(height: 24),

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

                const SizedBox(height: 40),
                const Divider(thickness: 2),
                const SizedBox(height: 24),

                // 📎 SECTION FILE UPLOAD
                _buildFileUploadSection(),

                const SizedBox(height: 40),
                const Divider(thickness: 2),
                const SizedBox(height: 24),

                // 💬 SECTION KOMENTAR
                Row(
                  children: [
                    const Icon(Icons.comment_outlined, color: Colors.blue),
                    const SizedBox(width: 8),
                    const Text(
                      'Komentar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_komentarList.length}',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // List Komentar
                if (_komentarList.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Belum ada komentar',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _komentarList.length,
                    itemBuilder: (context, index) {
                      final komentar = _komentarList[index];
                      return _buildKomentarCard(komentar);
                    },
                  ),
                const SizedBox(height: 24),

                // Form Input Komentar
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _komentarController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Tulis komentar Anda...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: _handleKirimKomentar,
                            icon: const Icon(Icons.send, size: 18),
                            label: const Text('Kirim Komentar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.attach_file, color: Colors.deepPurple),
                const SizedBox(width: 8),
                const Text(
                  'File Lampiran',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_uploadedFiles.length}',
                    style: TextStyle(
                      color: Colors.deepPurple.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            OutlinedButton.icon(
              onPressed: _handleUploadFile,
              icon: const Icon(Icons.upload_file, size: 18),
              label: const Text('Upload'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.deepPurple,
                side: BorderSide(color: Colors.deepPurple.shade300),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _uploadedFiles.map((file) {
              return _buildFileCard(
                fileName: file['name']!,
                extension: file['extension']!,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFileCard({required String fileName, required String extension}) {
    final fileColor = UIHelpers.getFileColor(extension);
    final fileIcon = UIHelpers.getFileIcon(extension);

    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: fileColor.withOpacity(0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            8.0,
          ), // reduced padding to give more space
          child: SizedBox(
            // ensure fixed height so Positioned works nicely
            height: 100,
            child: Stack(
              children: [
                // Positioned close button in the top-right corner with minimal padding
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 28,
                      minHeight: 28,
                    ),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 14,
                    ),
                    onPressed: () {
                      CustomDialog.show(
                        context,
                        icon: Icons.delete,
                        iconColor: Colors.red,
                        title: "Konfirmasi Hapus File",
                        message: "Apakah anda yakin menghapus file ini?",
                        confirmText: "Ya, hapus",
                        confirmColor: Colors.red,
                        cancelText: "Batal",
                        cancelColor: Colors.black,
                        onConfirm: () {
                          setState(() {
                            _uploadedFiles.removeWhere(
                              (f) => f['name'] == fileName,
                            );
                          });
                        },
                      );
                    },
                  ),
                ),

                // Main content
                Positioned.fill(
                  left: 0,
                  right: 0,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // give a tiny top spacing so content doesn't overlap the button
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: fileColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(fileIcon, color: fileColor, size: 24),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: fileColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              extension,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        fileName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
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
      ),
    );
  }

  Widget _buildKomentarCard(KomentarModel komentar) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: UIHelpers.getRoleColor(komentar.role),
                  radius: 20,
                  child: Text(
                    komentar.nama.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        komentar.nama,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: UIHelpers.getRoleColor(
                            komentar.role,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          komentar.role,
                          style: TextStyle(
                            fontSize: 11,
                            color: UIHelpers.getRoleColor(komentar.role),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  DateFormat('dd MMM, HH:mm').format(komentar.tanggal),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              komentar.komentar,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 16),
                  onPressed: () {
                    CustomInputDialog.show(
                      context,
                      icon: Icons.edit,
                      iconColor: Colors.blue,
                      title: 'Edit',
                      message: 'Masukkan data baru',
                      hintText: 'Ketik di sini...',
                      initialValue:
                          '', // Atau isi dengan value yang ingin diedit
                      confirmText: 'Simpan',
                      confirmColor: Colors.blue,
                      cancelText: 'Batal',
                      cancelColor: Colors.grey,
                      onConfirm: (value) {
                        // Handle hasil input
                        print('Input value: $value');
                        // Contoh: update state, simpan ke database, dll
                      },
                      onCancel: () {
                        print('Dialog dibatalkan');
                      },
                    );
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 16),
                  onPressed: () {
                    CustomDialog.show(
                      context,
                      icon: Icons.delete,
                      iconColor: Colors.red,
                      title: "Hapus Komentar",
                      message: "Apakah anda yakin ingin menghapus komentar?",
                      confirmText: "Ya, Hapus",
                      confirmColor: Colors.red,
                      cancelText: "Batal",
                      cancelColor: Colors.black,
                    );
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: Colors.red,
                ),
              ],
            ),
          ],
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
