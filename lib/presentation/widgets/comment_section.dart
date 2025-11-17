import 'package:bm_binus/data/models/comment_model.dart';
import 'package:bm_binus/presentation/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:bm_binus/presentation/bloc/comment/comment_bloc.dart';
import 'package:bm_binus/presentation/bloc/comment/comment_event.dart';
import 'package:bm_binus/presentation/bloc/comment/comment_state.dart';

class CommentSection extends StatefulWidget {
  final int requestId;
  final int userId;

  const CommentSection({super.key, required this.requestId, required this.userId});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CommentBloc>().add(LoadCommentEvent(widget.requestId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentBloc, CommentState>(
      listener: (context, state) {
        // Jika create/update/delete sukses → reload comment
        if (state.isSuccessTrx == true) {
          context.read<CommentBloc>().add(LoadCommentEvent(widget.requestId));
          _controller.clear();

          context.read<CommentBloc>().add(ResetCommentTrx());
        }

        if (state.errorTrx != null) {
          CustomSnackBar.show(
            context,
            icon: Icons.error,
            title: "Error",
            message: state.errorTrx!,
            color: Colors.red,
          );

          context.read<CommentBloc>().add(ResetCommentTrx());
        }
      },
      builder: (context, state) {
        final comments = state.comments;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔵 TITLE + COUNTER
            Row(
              children: [
                const Icon(Icons.comment, color: Colors.blue),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${comments.length}',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 17),

            // 🔄 LOADING COMMENTS ONLY
            if (state.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    '⏳ Memuat komentar...',
                    style: TextStyle(fontSize: 13, color: Colors.black),
                  ),
                ),
              ),

            // 📭 EMPTY COMMENT
            if (!state.isLoading && comments.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(Icons.comment_outlined, size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada komentar',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

            // 📌 COMMENT LIST
            if (!state.isLoading && comments.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return _buildCommentCard(comments[index], widget.userId);
                },
              ),

            const SizedBox(height: 5),

            // ✏️ INPUT COMMENT FIELD
            _buildInputField(),
          ],
        );
      },
    );
  }

  Widget _buildInputField() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      shadowColor: Colors.black.withOpacity(0.08),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Input Comment ---
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Tulis komentar Anda...',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // --- Button Send ---
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_controller.text.trim().isEmpty) return;
                  context.read<CommentBloc>().add(
                        CreateCommentRequested(widget.requestId, _controller.text.trim()),
                      );
                },
                icon: const Icon(Icons.send, size: 18),
                label: const Text('Kirim'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🧩 KOMENTAR CARD
  Widget _buildCommentCard(CommentModel komentar, int userLogin) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===============================
            // PROFILE ROW
            // ===============================
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.blue,
                  child: Text(
                    komentar.createdByName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    komentar.createdByName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (komentar.edited)...[
                  Text(
                    '(diedit)',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.blue,
                    ),
                  ),
                ],
                const SizedBox(width: 10),
                Text(
                  DateFormat('dd MMM yyyy, HH:mm').format(komentar.updatedAt),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ===============================
            // COMMENT TEXT (lebih simple)
            // ===============================
            Text(
              komentar.comment,
              style: const TextStyle(
                fontSize: 13.5,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 10),

            // ===============================
            // ACTION BUTTONS (lebih kecil & di kiri)
            // ===============================
            if (userLogin == komentar.createdById)...[
              Row(
                children: [
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.grey.shade700,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () async {
                      final controller = TextEditingController(text: komentar.comment);

                      final result = await showDialog<String>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Edit Komentar"),
                          content: TextField(
                            controller: controller,
                            maxLines: 3,
                            decoration: const InputDecoration(hintText: "Edit komentar"),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Batal"),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, controller.text),
                              child: const Text("Simpan"),
                            ),
                          ],
                        ),
                      );

                      if (result != null && result.trim().isNotEmpty) {
                        context.read<CommentBloc>().add(
                              UpdateCommentRequested(komentar.id, result.trim()),
                            );
                      }
                    },
                  ),

                  const SizedBox(width: 8),

                  IconButton(
                    icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Hapus Komentar"),
                          content: const Text("Yakin ingin menghapus komentar ini?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Batal"),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Hapus"),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        context.read<CommentBloc>().add(DeleteCommentRequested(komentar.id));
                      }
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}