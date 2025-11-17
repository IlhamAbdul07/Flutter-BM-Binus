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
import 'package:url_launcher/url_launcher.dart';

class FilesSection extends StatefulWidget {
  final int requestId;

  const FilesSection({super.key, required this.requestId});

  @override
  State<FilesSection> createState() => _FilesSectionState();
}

class _FilesSectionState extends State<FilesSection> {
  List<Map<String, String>> _uploadedFiles = [];

  Future<void> _handleUploadFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
    );

    if (result == null) return;

    const approvedExt = {
      // image
      ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".tiff", ".webp", ".svg",
      // document
      ".txt", ".pdf", ".csv", ".docx", ".xlsx", ".pptx",
      // data
      ".json", ".xml", ".yml", ".yaml", ".ini", ".log",
      // media
      ".mp3", ".wav", ".ogg", ".flac", ".mp4", ".avi", ".mkv", ".webm",
    };

    List<http.MultipartFile> multipartFiles = [];

    for (var file in result.files) {
      if (file.bytes == null) continue;

      final ext = file.extension != null
        ? ".${file.extension!.toLowerCase()}"
        : "";

      if (!approvedExt.contains(ext)) {
        CustomSnackBar.show(
          context,
          icon: Icons.error,
          title: 'Format Tidak Didukung',
          message: 'File "${file.name}" dengan format $ext tidak diizinkan.',
          color: Colors.red,
        );
        return;
      }

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
              message: "File berhasil diunggah ke pengajuan event.",
              color: Colors.green,
            );
          } else if (state.typeTrx == "delete") {
            CustomSnackBar.show(
              context,
              icon: Icons.check_circle,
              title: "File Berhasil Dihapus",
              message: "File berhasil dihapus dari pengajuan event.",
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

          context.read<FileBloc>().add(ResetFileTrx());
        }

        // UPDATE UI FILE LIST
        if (!state.isLoading && state.errorFetch == null) {
          _uploadedFiles = state.files
              .map((f) => {
                    'id': f.id.toString(),
                    'name': f.fileName,
                    'ext': f.fileExt,
                    'content': f.fileContent,
                    'view': f.fileView,
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
                '⏳ Memuat lampiran...',
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
                  'Lampiran',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            SizedBox(
              height: 30,
              width: 130,
              child: OutlinedButton.icon(
                onPressed: _handleUploadFile,
                icon: const Icon(Icons.upload_file, size: 22),
                label: const Text('Unggah', style: TextStyle(fontSize: 14),),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.deepPurple,
                  side: BorderSide(color: Colors.deepPurple.shade300),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // FILE LIST
        if (_uploadedFiles.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Icon(Icons.attach_file_outlined, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada lampiran',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ),
            ),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _uploadedFiles.map((file) {
                return _buildFileCard(
                  fileId: int.parse(file['id']!),
                  fileName: file['name']!,
                  fileExt: file['ext']!,
                  fileContent: file['content']!,
                  fileView: file['view']!,
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  // 📌 FILE CARD (UI DITINGKATKAN)
  Widget _buildFileCard({
    required int fileId,
    required String fileName,
    required String fileExt,
    required String fileContent,
    required String fileView,
  }) {
    final fileColor = UIHelpers.getFileColor(fileExt);
    final fileIcon = UIHelpers.getFileIcon(fileExt);

    final isImage = ['jpg', 'jpeg', 'png', 'gif'].contains(fileExt.toLowerCase());

    return Container(
      width: 165,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 3,
        shadowColor: fileColor.withOpacity(0.25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: fileColor.withOpacity(0.15)),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                fileColor.withOpacity(0.06),
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: 135,
              child: Stack(
                children: [
                  // DELETE BUTTON (lebih halus dan elegan)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      splashRadius: 18,
                      icon: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: Colors.black.withOpacity(0.55),
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
                        const SizedBox(height: 22),

                        // FILE ICON + EXT BADGE
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: fileColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(fileIcon, color: fileColor, size: 26),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: fileColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                fileExt.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // FILE NAME
                        Text(
                          fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const Spacer(),

                        // DOWNLOAD + PREVIEW BUTTONS (lebih rapi)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              splashRadius: 18,
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.download_rounded, size: 20, color: Colors.blue),
                              onPressed: () async {
                                final url = Uri.parse(fileContent);
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url, mode: LaunchMode.platformDefault);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Tidak bisa membuka link download')),
                                  );
                                }
                              },
                            ),

                            SizedBox(width: 5,),

                            if (isImage)
                              IconButton(
                                padding: EdgeInsets.zero,
                                splashRadius: 18,
                                constraints: const BoxConstraints(),
                                icon: const Icon(Icons.visibility_rounded, size: 20, color: Colors.green),
                                onPressed: () async {
                                  final url = Uri.parse(fileView);
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url, mode: LaunchMode.platformDefault);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Tidak bisa membuka preview')),
                                    );
                                  }
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
