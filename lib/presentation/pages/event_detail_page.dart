import 'package:bm_binus/core/constants/custom_colors.dart';
import 'package:bm_binus/core/constants/ui_helpers.dart';
import 'package:bm_binus/data/dummy/komentar_data.dart';
import 'package:bm_binus/presentation/bloc/event_type/event_type_bloc.dart';
import 'package:bm_binus/presentation/bloc/event_type/event_type_state.dart';
import 'package:bm_binus/presentation/bloc/pengajuan/event_bloc.dart';
import 'package:bm_binus/presentation/bloc/pengajuan/event_event.dart';
import 'package:bm_binus/presentation/bloc/pengajuan/event_state.dart';
import 'package:bm_binus/presentation/bloc/status/status_bloc.dart';
import 'package:bm_binus/presentation/bloc/status/status_state.dart';
import 'package:bm_binus/presentation/widgets/custom_dialog.dart';
import 'package:bm_binus/presentation/widgets/custom_input_dialog.dart';
import 'package:bm_binus/presentation/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:bm_binus/data/models/komentar_model.dart';

class EventDetailPage extends StatefulWidget {
  final int requestId;

  const EventDetailPage({super.key, required this.requestId});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _staffController;
  late TextEditingController _eventController;
  late TextEditingController _lokasiController;
  late DateTime? _tglMulai;
  late DateTime? _tglSelesai;
  late TextEditingController _tglMulaiController;
  late TextEditingController _tglSelesaiController;
  late TextEditingController _deskripsiController;
  int? _selectedEventTypeId;
  late TextEditingController _jumlahPesertaController;
  int? _selectedStatusId;

  bool _handledTrx = false;

  late List<KomentarModel> _komentarList;
  final _komentarController = TextEditingController();

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
    _staffController = TextEditingController(text: '');
    _eventController = TextEditingController(text: '');
    _lokasiController = TextEditingController(text: '');
    _tglMulai = null;
    _tglSelesai = null;
    _tglMulaiController = TextEditingController(text: '');
    _tglSelesaiController = TextEditingController(text: '');
    _deskripsiController = TextEditingController(text: '');
    _selectedEventTypeId = null;
    _jumlahPesertaController = TextEditingController(text: '');
    _selectedStatusId = null;
  }

  void _loadKomentar() {
    _komentarList = KomentarData.getKomentarForEvent(widget.requestId);
  }

  @override
  void dispose() {
    _staffController.dispose();
    _eventController.dispose();
    _lokasiController.dispose();
    _tglMulaiController.dispose();
    _tglSelesaiController.dispose();
    _deskripsiController.dispose();
    _jumlahPesertaController.dispose();
    _komentarController.dispose();
    super.dispose();
  }

  void _refreshDetail() {
    context.read<EventBloc>().add(LoadDetailEventRequested(widget.requestId));
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _tglMulai : _tglSelesai,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context, 
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null){
        final fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute
        );

        if (isStartDate && _tglSelesai != null) {
          if (fullDateTime.isAfter(_tglSelesai!)) {
            CustomSnackBar.show(
              context,
              icon: Icons.error,
              title: 'Failed',
              message: 'Tanggal mulai harus lebih kecil dari tanggal selesai!',
              color: Colors.red,
            );
            return;
          }
        }

        if (!isStartDate && _tglMulai != null) {
          if (fullDateTime.isBefore(_tglMulai!)) {
            CustomSnackBar.show(
              context,
              icon: Icons.error,
              title: 'Failed',
              message: 'Tanggal selesai harus lebih besar dari tanggal mulai!',
              color: Colors.red,
            );
            return;
          }
        }

        setState(() {
          if (isStartDate) {
            _tglMulai = fullDateTime;
            _tglMulaiController.text = _formatDateTime(fullDateTime);
          } else {
            _tglSelesai = fullDateTime;
            _tglSelesaiController.text = _formatDateTime(fullDateTime);
          }
        });
      }
    }
  }

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

  String formatBM(DateTime createdAt) {
    final day = createdAt.day.toString().padLeft(2, '0');
    final month = createdAt.month.toString().padLeft(2, '0');
    final year = createdAt.year.toString();

    return 'BM-$day$month$year';
  }

  String _formatDateTime(DateTime dt) {
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];

    String month = months[dt.month - 1];
    String hour12 = (dt.hour % 12 == 0 ? 12 : dt.hour % 12).toString();
    String minute = dt.minute.toString().padLeft(2, '0');
    String ampm = dt.hour >= 12 ? "PM" : "AM";

    return "${dt.day} $month ${dt.year} | $hour12:$minute $ampm";
  }

  String formatToDateTimeSql(DateTime dt) {
    String year = dt.year.toString();
    String month = dt.month.toString().padLeft(2, '0');
    String day = dt.day.toString().padLeft(2, '0');

    String hour = dt.hour.toString().padLeft(2, '0');
    String minute = dt.minute.toString().padLeft(2, '0');
    String second = dt.second.toString().padLeft(2, '0');

    return "$year-$month-$day $hour:$minute:$second";
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.pop(true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Detail Pengajuan Event',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton.icon(
              onPressed: _refreshDetail,
              style: TextButton.styleFrom(
                side: const BorderSide(color: Colors.black, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              icon: const Icon(Icons.refresh, color: Colors.black, size: 18),
              label: const Text(
                'Refresh Data',
                style: TextStyle(color: Colors.black, fontSize: 13),
              ),
            ),
            SizedBox(width: 30,)
          ],
        ),
        body: BlocListener<EventBloc, EventState>(
          listener: (context, state) async {
            if (state.singleEvent != null && !state.isLoading) {
              final event = state.singleEvent!;
              setState(() {
                _staffController.text = event.userName;
                _eventController.text = event.eventName;
                _lokasiController.text = event.eventLocation;
                _tglMulai = event.eventDateStart;
                _tglSelesai = event.eventDateEnd;
                _tglMulaiController.text = _formatDateTime(_tglMulai!);
                _tglSelesaiController.text = _formatDateTime(_tglSelesai!);
                _deskripsiController.text = event.description;
                _selectedEventTypeId = event.eventTypeId;
                _jumlahPesertaController.text = event.countParticipant.toString();
                _selectedStatusId = event.statusId;
              });
            }
      
            if (state.errorFetch != null) {
              CustomSnackBar.show(
                context,
                icon: Icons.error,
                title: 'Error',
                message: state.errorFetch!,
                color: Colors.red,
              );
            }

            if (!_handledTrx) {
              if (state.isSuccessTrx) {
                _handledTrx = true;

                CustomSnackBar.show(
                  context,
                  icon: Icons.check_circle,
                  title: state.typeTrx == 'update'
                      ? "Success Update Event"
                      : "Success Delete Event",
                  message: state.typeTrx == 'update'
                      ? "Pengajuan Event berhasil diedit"
                      : "Pengajuan Event berhasil dihapus",
                  color: Colors.green,
                );

                await Future.delayed(const Duration(seconds: 1));

                if (state.typeTrx == "update") {
                  _refreshDetail();
                } else if (state.typeTrx == "delete") {
                  if (context.mounted) context.pop(true);
                }

                context.read<EventBloc>().add(ResetTrxStateRequested());

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _handledTrx = false;
                });
              } else if (state.errorTrx != null) {
                _handledTrx = true;

                CustomSnackBar.show(
                  context,
                  icon: Icons.error,
                  title: state.typeTrx == 'update'
                      ? "Failed Update Event"
                      : "Failed Delete Event",
                  message: state.errorTrx!,
                  color: Colors.red,
                );

                context.read<EventBloc>().add(ResetTrxStateRequested());

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _handledTrx = false;
                });
              }
            }
          },
          child: BlocBuilder<EventBloc, EventState>(
            builder: (context, state){
              if (state.isLoading) {
                return const Center(
                  child: Text(
                    '⏳ Mohon tunggu, sedang memuat data...',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                );
              }
      
              if (state.singleEvent == null) {
                return const SizedBox.shrink();
              }
      
              final data = state.singleEvent!;
      
              return SingleChildScrollView(
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.info_outline, color: Colors.blue),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Event #${formatBM(data.createdAt)}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (data.statusId == 5)...[
                                        Text(
                                          '   (Detail Pengajuan Event dapat di download)',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  if (data.statusId == 5)...[
                                    DownloadButton(reqId: data.id,)
                                  ],
                                ],
                              ),
                              const SizedBox(height: 8),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Pembaruan terakhir: ',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    TextSpan(
                                      text: _formatDateTime(data.updatedAt),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic, // <<< hanya bagian ini italic
                                      ),
                                    ),
                                  ],
                                ),
                              )
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
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
              
                      _buildTextField(
                        controller: _eventController,
                        label: 'Nama Event',
                        icon: Icons.event,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama event wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
              
                      _buildTextField(
                        controller: _lokasiController,
                        label: 'Lokasi Event',
                        icon: Icons.location_on,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lokasi event wajib diisi';
                          }
                          return null;
                        },
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
                        controller: _deskripsiController,
                        label: 'Deskripsi',
                        icon: Icons.description,
                        maxLines: 4
                      ),
                      const SizedBox(height: 16),
              
                      BlocBuilder<EventTypeBloc, EventTypeState>(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: LinearProgressIndicator(),
                            );
                          }

                          if (state.errorFetch != null) {
                            return Text(
                              "Gagal memuat event type: ${state.errorFetch}",
                              style: const TextStyle(color: Colors.red),
                            );
                          }

                          final eventTypes = state.eventType;

                          if (_selectedEventTypeId == null && eventTypes.isNotEmpty) {
                            _selectedEventTypeId = eventTypes.first.id;
                          }

                          return DropdownButtonFormField<int>(
                            initialValue: _selectedEventTypeId,
                            decoration: InputDecoration(
                              labelText: 'Jenis Event',
                              prefixIcon: Icon(Icons.category),
                              filled: true,
                              labelStyle: TextStyle(color: Colors.black),
                              fillColor: Colors.grey[50],
                            ),
                            items: eventTypes.map((et) {
                              return DropdownMenuItem<int>(
                                value: et.id,
                                child: Text(et.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedEventTypeId = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return "Jenis event wajib dipilih";
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _jumlahPesertaController,
                        label: 'Jumlah Partisipan',
                        icon: Icons.people,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Jumlah partisipan wajib diisi';
                          }
                          final participant = int.tryParse(value);
                          if (participant == null) {
                            return 'Jumlah partisipan harus berupa angka';
                          }
                          if (participant < 1) {
                            return 'Jumlah partisipan minimal 1';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
              
                      BlocBuilder<StatusBloc, StatusState>(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: LinearProgressIndicator(),
                            );
                          }

                          if (state.errorFetch != null) {
                            return Text(
                              "Gagal memuat status: ${state.errorFetch}",
                              style: const TextStyle(color: Colors.red),
                            );
                          }

                          final status = state.status;

                          if (_selectedStatusId == null && status.isNotEmpty) {
                            _selectedStatusId = status.first.id;
                          }

                          return DropdownButtonFormField<int>(
                            initialValue: _selectedStatusId,
                            decoration: InputDecoration(
                              labelText: 'Status',
                              prefixIcon: Icon(Icons.flag),
                              filled: true,
                              labelStyle: TextStyle(color: Colors.black),
                              fillColor: Colors.grey[50],
                            ),
                            items: status.map((et) {
                              final color = _getStatusColor(et.name);
                              return DropdownMenuItem<int>(
                                value: et.id,
                                child: Container(
                                  constraints: const BoxConstraints(
                                    minHeight: 30,
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), // diperkecil
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: color, width: 1),
                                  ),
                                  child: Text(
                                    et.name,
                                    style: TextStyle(
                                      color: color,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedStatusId = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return "Status wajib dipilih";
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
              
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  String? eventName;
                                  String? eventLocation;
                                  String? eventDateStart;
                                  String? eventDateEnd;
                                  String? description;
                                  int? eventTypeId;
                                  int? countParticipant;
                                  int? statusId;
                                  if (_eventController.text != data.eventName){
                                    eventName = _eventController.text;
                                  }
                                  if (_lokasiController.text != data.eventLocation){
                                    eventLocation = _lokasiController.text;
                                  }
                                  if (_tglMulai != data.eventDateStart){
                                    eventDateStart = formatToDateTimeSql(_tglMulai!);
                                  }
                                  if (_tglSelesai != data.eventDateEnd){
                                    eventDateEnd = formatToDateTimeSql(_tglSelesai!);
                                  }
                                  if (_deskripsiController.text != data.description){
                                    description = _deskripsiController.text;
                                    if (_deskripsiController.text.isEmpty){
                                      description = '-';
                                    }
                                  }
                                  if (_selectedEventTypeId != data.eventTypeId){
                                    eventTypeId = _selectedEventTypeId;
                                  }
                                  if (int.parse(_jumlahPesertaController.text) != data.countParticipant){
                                    countParticipant = int.parse(_jumlahPesertaController.text);
                                  }
                                  if (_selectedStatusId != data.statusId){
                                    statusId = _selectedStatusId;
                                  }
                                  context.read<EventBloc>().add(UpdateEventRequested(
                                    data.id, 
                                    eventName,
                                    eventLocation,
                                    eventDateStart,
                                    eventDateEnd,
                                    description,
                                    eventTypeId,
                                    countParticipant,
                                    statusId
                                  ));
                                }
                              },
                              icon: const Icon(Icons.save),
                              label: Text(state.loadingType["update"] == true ? 'Mohon tunggu...' : 'Update Event'),
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
                              onPressed: () {
                                CustomDialog.show(
                                  context,
                                  icon: Icons.delete,
                                  iconColor: Colors.red,
                                  title: "Konfirmasi Hapus Pengajuan Event",
                                  message: "Apakah anda yakin menghapus data pengajuan ini?",
                                  confirmText: "Ya, hapus",
                                  confirmColor: Colors.red,
                                  cancelText: "Batal",
                                  cancelColor: Colors.black,
                                  onConfirm: () {
                                    context.read<EventBloc>().add(DeleteEventRequested(data.id));
                                  },
                                );
                              },
                              icon: const Icon(Icons.delete),
                              label: Text(state.loadingType["delete"] == true ? 'Mohon tunggu...' : 'Hapus Event'),
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
              );
            },
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
    bool readOnly = false,
    int maxLines = 1,
    FormFieldValidator<String>? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: validator,
      maxLines: maxLines,
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required VoidCallback? onTap,
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
          return '$label wajib diisi';
        }
        return null;
      },
    );
  }
}

class DownloadButton extends StatelessWidget {
  final int? reqId;
  const DownloadButton({super.key, this.reqId});
 
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(
      builder: (context, eventState) {
        final isDownloading = eventState.isLoadingTrx;
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green, width: 1.5),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              context.read<EventBloc>().add(DownloadEventDetailRequested(reqId));
            },
            icon: isDownloading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.green,),
                )
              : const Icon(Icons.download,color: Colors.green,),
            tooltip: "Download Detail Pengajuan Event",
          ),
        );
      },
    );
  }
}
 