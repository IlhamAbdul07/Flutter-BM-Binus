import 'package:bm_binus/core/constants/ui_helpers.dart';
import 'package:bm_binus/presentation/bloc/file/file_bloc.dart';
import 'package:bm_binus/presentation/bloc/file/file_event.dart';
import 'package:bm_binus/presentation/bloc/file/file_state.dart';
import 'package:bm_binus/presentation/widgets/custom_dialog.dart';
import 'package:bm_binus/presentation/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class FilesSection extends StatefulWidget {
  final int requestId;

  const FilesSection({super.key, required this.requestId});

  @override
  State<FilesSection> createState() => _FilesSectionState();
}

class _FilesSectionState extends State<FilesSection> {
  List<Map<String, String>> _uploadedFiles = [];

  // 📌 Fungsi Upload File
  Future<void> _handleUploadFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
    );

    if (result == null) return;

    List<http.MultipartFile> multipartFiles = [];

    for (var file in result.files) {
      if (file.bytes == null) continue;

      multipartFiles.add(
        http.MultipartFile.fromBytes(
          'files',
          file.bytes!,
          filename: file.name,
        ),
      );
    }

    if (multipartFiles.isEmpty) {
      CustomSnackBar.show(
        context,
        icon: Icons.error,
        title: 'Error',
        message: 'File tidak valid.',
        color: Colors.red,
      );
      return;
    }

    context
        .read<FileBloc>()
        .add(CreateFileRequested(widget.requestId, multipartFiles));
  }

  @override
  void initState() {
    super.initState();
    context.read<FileBloc>().add(LoadFileEvent(widget.requestId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FileBloc, FileState>(
      listener: (context, state) {
        // ERROR FETCH
        if (state.errorFetch != null) {
          CustomSnackBar.show(
            context,
            icon: Icons.error,
            title: "Gagal memuat file",
            message: state.errorFetch!,
            color: Colors.red,
          );
        }

        // TRANSACTION SUCCESS
        if (state.isSuccessTrx == true) {
          if (state.typeTrx == "create") {
            CustomSnackBar.show(
              context,
              icon: Icons.check_circle,
              title: "File Berhasil Diupload",
              message: "File berhasil diunggah ke pengajuan.",
              color: Colors.green,
            );
          } else if (state.typeTrx == "delete") {
            CustomSnackBar.show(
              context,
              icon: Icons.check_circle,
              title: "File Berhasil Dihapus",
              message: "File berhasil dihapus dari pengajuan.",
              color: Colors.green,
            );
          }

          context.read<FileBloc>().add(LoadFileEvent(widget.requestId));
          context.read<FileBloc>().add(ResetFileTrx());
        }

        // TRANSACTION ERROR
        if (state.isSuccessTrx == false && state.errorTrx != null) {
          CustomSnackBar.show(
            context,
            icon: Icons.error,
            title: "Error",
            message: state.errorTrx!,
            color: Colors.red,
          );
        }

        // UPDATE UI FILE LIST
        if (!state.isLoading && state.errorFetch == null) {
          _uploadedFiles = state.files
              .map((f) => {
                    'id': f.id.toString(),
                    'name': f.fileName,
                    'extension': f.fileExt,
                  })
              .toList();
        }
      },

      builder: (context, state) {
        if (state.isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                '⏳ Memuat file...',
                style: TextStyle(fontSize: 13, color: Colors.black),
              ),
            ),
          );
        }

        return _buildFileUploadSection();
      },
    );
  }

  // 📌 UI FILE SECTION
  Widget _buildFileUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HEADER
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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

            // BUTTON UPLOAD
            OutlinedButton.icon(
              onPressed: _handleUploadFile,
              icon: const Icon(Icons.upload_file, size: 18),
              label: const Text('Upload'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.deepPurple,
                side: BorderSide(color: Colors.deepPurple.shade300),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // FILE LIST
        if (_uploadedFiles.isEmpty)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
                child: Text(
              "Belum ada file",
              style: TextStyle(color: Colors.grey.shade600),
            )),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _uploadedFiles.map((file) {
                return _buildFileCard(
                  fileId: int.parse(file['id']!),
                  fileName: file['name']!,
                  extension: file['extension']!,
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  // 📌 FILE CARD
  Widget _buildFileCard({
    required int fileId,
    required String fileName,
    required String extension,
  }) {
    final fileColor = UIHelpers.getFileColor(extension);
    final fileIcon = UIHelpers.getFileIcon(extension);

    return Container(
      width: 160, // <----- UBAH LEBAR CARD DI SINI (default tadi 140)
      // bisa coba 160 / 170 / 180 sampai pas
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        clipBehavior: Clip.hardEdge, // <— penting biar tdk overflow
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: fileColor.withOpacity(0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100, // <--- TAMBAH SEDIKIT HEIGHT (boleh tweak)
            child: Stack(
              children: [
                // DELETE BUTTON
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.close, size: 14, color: Colors.black),
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
                          context.read<FileBloc>().add(DeleteFileRequested(fileId));
                        },
                      );
                    },
                  ),
                ),

                // FILE CONTENT
                Positioned.fill(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: fileColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(fileIcon, color: fileColor, size: 24),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // <--- PEMOTONG NAMA OTOMATIS
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
}
