import 'package:bm_binus/presentation/bloc/auth/auth_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:bm_binus/core/constants/custom_colors.dart';
import 'package:bm_binus/presentation/bloc/event_type/event_type_bloc.dart';
import 'package:bm_binus/presentation/bloc/event_type/event_type_state.dart';
import 'package:bm_binus/presentation/bloc/pengajuan/event_bloc.dart';
import 'package:bm_binus/presentation/bloc/pengajuan/event_event.dart';
import 'package:bm_binus/presentation/bloc/pengajuan/event_state.dart';
import 'package:bm_binus/presentation/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _userLogin = TextEditingController();
  final _namaEventController = TextEditingController();
  final _lokasiEventController = TextEditingController();
  DateTime? _tanggalMulai;
  DateTime? _tanggalSelesai;
  final _deskripsiController = TextEditingController();
  int? _selectedEventTypeId;
  final _jumlahPesertaController = TextEditingController();
  final List<http.MultipartFile> _uploadedFiles = [];
  final List<String> _fileNames = [];

  // FocusNodes
  final _namaEventFocus = FocusNode();
  final _lokasiFocus = FocusNode();
  final _deskripsiFocus = FocusNode();
  final _jumlahPesertaFocus = FocusNode();

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

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
    );

    if (result != null) {
      for (var file in result.files) {
        final bytes = file.bytes;
        final name = file.name;

        if (bytes != null) {
          final multipart = http.MultipartFile.fromBytes(
            'files',
            bytes,
            filename: name,
          );

          setState(() {
            _uploadedFiles.add(multipart);
            _fileNames.add(name);
          });
        }
      }
    }
  }

  void _removeFile(int index) {
    setState(() {
      _uploadedFiles.removeAt(index);
      _fileNames.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    setState(() {
      _userLogin.text = authState.name!;
    });
  }

  @override
  void dispose() {
    _namaEventController.dispose();
    _lokasiEventController.dispose();
    _deskripsiController.dispose();
    _jumlahPesertaController.dispose();
    _namaEventFocus.dispose();
    _lokasiFocus.dispose();
    _deskripsiFocus.dispose();
    _jumlahPesertaFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.pop(true);
        }
      },
      child: BlocConsumer<EventBloc, EventState>(
        listener: (context, state) async {
          if (state.isSuccessTrx){
            CustomSnackBar.show(
              context,
              icon: Icons.check_circle,
              title: "Success Create Event",
              message: "Pengajuan Event berhasil ditambahkan",
              color: Colors.green,
            );
            await Future.delayed(const Duration(seconds: 1));
            if (context.mounted) {
              context.pop(true);
            }
          } else if (state.errorTrx != null){
            CustomSnackBar.show(
              context,
              icon: Icons.error,
              title: "Failed Create Event",
              message: state.errorTrx!,
              color: Colors.red,
            );
          }
        },
        builder: (context, state){
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Tambah Pengajuan Event',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            body: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.event,
                    color: Colors.orange,
                    size: 60,
                  ),
                ),
                // ===== FORM =====
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _userLogin,
                        decoration: const InputDecoration(
                          labelText: 'Nama Staf (auto fill)',
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange, width: 2),
                          ),
                        ),
                        readOnly: true,
                      ),
                      const SizedBox(height: 20),
                      // ==== Nama Event ====
                      TextFormField(
                        controller: _namaEventController,
                        focusNode: _namaEventFocus,
                        decoration: const InputDecoration(
                          labelText: 'Nama Event',
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama event wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // ==== Lokasi Event ====
                      TextFormField(
                        controller: _lokasiEventController,
                        focusNode: _lokasiFocus,
                        decoration: const InputDecoration(
                          labelText: 'Lokasi Event',
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lokasi event wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // ==== Tanggal Mulai ====
                      GestureDetector(
                        onTap: () async {
                          final tomorrow = DateTime.now().add(const Duration(days: 1));

                          final date = await showDatePicker(
                            context: context,
                            initialDate: tomorrow,
                            firstDate: tomorrow, // minimal besok
                            lastDate: DateTime(2100), // tak terbatas
                          );

                          if (date != null) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (time != null) {
                              final fullDateTime = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );

                              setState(() => _tanggalMulai = fullDateTime);

                              // reset tanggal selesai jika sudah terisi tapi lebih kecil dari tanggal mulai
                              if (_tanggalSelesai != null && _tanggalSelesai!.isBefore(fullDateTime)) {
                                _tanggalSelesai = null;
                              }
                            }
                          }
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Tanggal Mulai',
                              labelStyle: TextStyle(color: Colors.black),
                              suffixIcon: Icon(Icons.calendar_today, color: Colors.orange),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange, width: 2),
                              ),
                            ),
                            controller: TextEditingController(
                              text: _tanggalMulai != null ? _formatDateTime(_tanggalMulai!) : '',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Tanggal mulai wajib diisi';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ==== Tanggal Selesai ====
                      GestureDetector(
                        onTap: _tanggalMulai == null
                            ? null // jika tanggal mulai belum diisi, disable
                            : () async {
                                final minEndDate = DateTime(
                                  _tanggalMulai!.year,
                                  _tanggalMulai!.month,
                                  _tanggalMulai!.day,
                                );

                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: minEndDate,
                                  firstDate: minEndDate, // minimal = tanggal mulai
                                  lastDate: DateTime(2100),
                                );

                                if (date != null) {
                                  final selectedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );

                                  if (selectedTime != null) {
                                    // ==== Tambahan logika minimal waktu ====

                                    DateTime fullDateTime = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      selectedTime.hour,
                                      selectedTime.minute,
                                    );

                                    // Jika tanggal sama dengan tanggal mulai
                                    if (date.year == _tanggalMulai!.year &&
                                        date.month == _tanggalMulai!.month &&
                                        date.day == _tanggalMulai!.day) {
                                      
                                      // Minimal waktu selesai = waktu mulai + 1 jam
                                      final minEndTime = _tanggalMulai!.add(const Duration(hours: 1));

                                      // Jika user pilih waktu sebelum minimal → paksa ke minimal
                                      if (fullDateTime.isBefore(minEndTime)) {
                                        fullDateTime = minEndTime;
                                      }
                                    }

                                    setState(() => _tanggalSelesai = fullDateTime);
                                  }
                                }
                              },
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Tanggal Selesai',
                              labelStyle: const TextStyle(color: Colors.black),
                              suffixIcon: Icon(
                                Icons.calendar_today,
                                color: _tanggalMulai == null ? Colors.grey : Colors.orange,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange, width: 2),
                              ),
                            ),
                            controller: TextEditingController(
                              text: _tanggalSelesai != null ? _formatDateTime(_tanggalSelesai!) : '',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Tanggal selesai wajib diisi';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ==== Deskripsi ====
                      TextFormField(
                        controller: _deskripsiController,
                        focusNode: _deskripsiFocus,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi',
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ==== Dropdown Type ====
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
                            decoration: const InputDecoration(
                              labelText: 'Jenis Event',
                              labelStyle: TextStyle(color: Colors.black),
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
                      const SizedBox(height: 20),

                      // ==== Jumlah Peserta ====
                      TextFormField(
                        controller: _jumlahPesertaController,
                        focusNode: _jumlahPesertaFocus,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Jumlah Partisipan',
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange, width: 2),
                          ),
                        ),
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
                      const SizedBox(height: 24),

                      // ==== Upload Button ====
                      SizedBox(
                        width: size.width * 0.1,
                        height: size.height * 0.1,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _pickFiles();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(
                            Icons.upload_file,
                            color: Colors.black,
                            size: 25,
                          ),
                          label: const Text(
                            'Upload File',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_fileNames.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "File Terupload:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ..._fileNames.asMap().entries.map((entry) {
                              final index = entry.key;
                              final name = entry.value;

                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.insert_drive_file, size: 20, color: Colors.orange),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        name,
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => _removeFile(index),
                                      icon: const Icon(Icons.close, color: Colors.red, size: 22),
                                      padding: EdgeInsets.zero,
                                      splashRadius: 20,
                                    )
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      const SizedBox(height: 24),

                      // ==== Submit Button ====
                      Align(
                        alignment: Alignment.center,
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints.tightFor(width: size.width * 0.3),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColors.oranges,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<EventBloc>().add(CreateEventRequested(
                                  _namaEventController.text,
                                  _lokasiEventController.text,
                                  formatToDateTimeSql(_tanggalMulai!),
                                  formatToDateTimeSql(_tanggalSelesai!),
                                  _deskripsiController.text.isEmpty ? '-' : _deskripsiController.text,
                                  _selectedEventTypeId!,
                                  int.parse(_jumlahPesertaController.text),
                                  _uploadedFiles
                                ));
                              }
                            },
                            child: Text(
                              state.isLoadingTrx ? '⏳ Mohon tunggu...' : 'Submit',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}