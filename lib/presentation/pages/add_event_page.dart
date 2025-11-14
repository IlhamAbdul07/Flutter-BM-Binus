import 'package:bm_binus/core/constants/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _namaEventController = TextEditingController();
  final _lokasiEventController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _jumlahPesertaController = TextEditingController();
  DateTime? _tanggalMulai;
  DateTime? _tanggalSelesai;
  String? _selectedEventType;

  // FocusNodes
  final _namaEventFocus = FocusNode();
  final _lokasiFocus = FocusNode();
  final _deskripsiFocus = FocusNode();
  final _jumlahPesertaFocus = FocusNode();

  final List<String> _eventTypes = [
    'Seminar',
    'Workshop',
    'Conference',
    'Other',
  ];

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
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Tambah Event',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // ===== Header =====
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Tambah Event',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Tambahkan Pengajuan Event',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
              ],
            ),

            // ===== FORM =====
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  ),
                  const SizedBox(height: 20),

                  // ==== Tanggal Mulai ====
                  GestureDetector(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) setState(() => _tanggalMulai = date);
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Tanggal Mulai',
                          labelStyle: TextStyle(color: Colors.black),
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.orange,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange, width: 2),
                          ),
                        ),
                        controller: TextEditingController(
                          text: _tanggalMulai != null
                              ? "${_tanggalMulai!.day}/${_tanggalMulai!.month}/${_tanggalMulai!.year}"
                              : '',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ==== Tanggal Selesai ====
                  GestureDetector(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) setState(() => _tanggalSelesai = date);
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Tanggal Selesai',
                          labelStyle: TextStyle(color: Colors.black),
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.orange,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange, width: 2),
                          ),
                        ),
                        controller: TextEditingController(
                          text: _tanggalSelesai != null
                              ? "${_tanggalSelesai!.day}/${_tanggalSelesai!.month}/${_tanggalSelesai!.year}"
                              : '',
                        ),
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
                  DropdownButtonFormField<String>(
                    value: _selectedEventType,
                    decoration: const InputDecoration(
                      labelText: 'Event Type',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange, width: 2),
                      ),
                    ),
                    items: _eventTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() => _selectedEventType = value);
                    },
                  ),
                  const SizedBox(height: 20),

                  // ==== Jumlah Peserta ====
                  TextFormField(
                    controller: _jumlahPesertaController,
                    focusNode: _jumlahPesertaFocus,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Jumlah Peserta',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ==== Upload Button ====
                  SizedBox(
                    width: size.width * 0.1,
                    height: size.height * 0.1,
                    child: ElevatedButton.icon(
                      onPressed: () {},
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
                            // submit logic
                          }
                        },
                        child: const Text(
                          'Submit',
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
      ),
    );
  }
}