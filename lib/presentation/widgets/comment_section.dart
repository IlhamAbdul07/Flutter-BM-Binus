import 'package:bm_binus/data/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:bm_binus/presentation/bloc/comment/comment_bloc.dart';
import 'package:bm_binus/presentation/bloc/comment/comment_event.dart';
import 'package:bm_binus/presentation/bloc/comment/comment_state.dart';

class CommentSection extends StatefulWidget {
  final int requestId;

  const CommentSection({super.key, required this.requestId});

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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorTrx!)),
          );
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

            const SizedBox(height: 16),

            // 🔄 LOADING COMMENTS ONLY
            if (state.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    '⏳ Memuat comment...',
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
                      Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey.shade300),
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
                  return _buildCommentCard(comments[index]);
                },
              ),

            const SizedBox(height: 24),

            // ✏️ INPUT COMMENT FIELD
            _buildInputField(),
          ],
        );
      },
    );
  }

  Widget _buildInputField() {
    return Card(
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
              controller: _controller,
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
                onPressed: () {
                  if (_controller.text.trim().isEmpty) return;
                  context.read<CommentBloc>().add(
                        CreateCommentRequested(widget.requestId, _controller.text.trim()),
                      );
                },
                icon: const Icon(Icons.send, size: 18),
                label: const Text('Kirim Komentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🧩 KOMENTAR CARD
  Widget _buildCommentCard(CommentModel komentar) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // 🧑‍💼 Profile Row
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  komentar.createdByName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  komentar.createdByName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              Text(
                DateFormat('dd MMM, HH:mm').format(komentar.createdAt),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 💬 Comment text
          Text(komentar.comment, style: const TextStyle(fontSize: 14, height: 1.5)),

          const SizedBox(height: 8),

          // ✏️ Edit & Delete
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // EDIT
              IconButton(
                icon: const Icon(Icons.edit, size: 16),
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
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
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

              // DELETE
              IconButton(
                icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Hapus Komentar"),
                      content: const Text("Yakin ingin menghapus komentar ini?"),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
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
          )
        ]),
      ),
    );
  }
}