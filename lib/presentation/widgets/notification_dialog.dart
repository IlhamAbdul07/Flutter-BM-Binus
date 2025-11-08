// notification_dialog.dart
import 'package:bm_binus/data/models/notification_model.dart';
import 'package:bm_binus/presentation/bloc/notification/notification_bloc.dart';
import 'package:bm_binus/presentation/bloc/notification/notification_event.dart';
import 'package:bm_binus/presentation/bloc/notification/notification_state.dart';
import 'package:bm_binus/presentation/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationDialog extends StatelessWidget {
  const NotificationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dialogWidth = size.width * 0.9;
    final maxDialogWidth = 500.0;
    final dialogHeight = size.height * 0.7;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      elevation: 0,
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxDialogWidth,
          minWidth: dialogWidth < maxDialogWidth ? dialogWidth : maxDialogWidth,
          maxHeight: dialogHeight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(context),

            // List Notifikasi (pakai BlocBuilder)
            Expanded(
              child: BlocConsumer<NotificationBloc, NotificationState>(
                listener: (context, state) {
                  if (state.requestId != null){
                    CustomSnackBar.show(
                      context,
                      icon: Icons.check_circle,
                      title: 'success set read!',
                      message: 'Request ID: ${state.requestId}',
                      color: Colors.green,
                    );
                    state.setRequestId(null);
                  }
                },
                builder: (context, state) {
                  // Loading
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Error
                  if (state.errorMessage != null) {
                    return Center(
                      child: Text(
                        state.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  // Empty
                  if (state.notifications.isEmpty) {
                    return _buildEmptyState();
                  }

                  // Success - tampilkan list
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: state.notifications.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final notif = state.notifications[index];
                      return _buildNotificationTile(context, notif);
                    },
                  );
                },
              ),
            ),

            // Footer
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.notifications, color: Colors.blue.shade700, size: 28),
              const SizedBox(width: 12),
              const Text(
                'Notifikasi',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Muat ulang notifikasi',
                icon: Icon(Icons.refresh, color: Colors.blue.shade700),
                onPressed: () {
                  context.read<NotificationBloc>().add(LoadNotificationsEvent());
                },
              ),
            ],
          ),
          BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              if (state.unreadCount > 0) {
                return TextButton(
                  onPressed: () {
                    context.read<NotificationBloc>().add(MarkAllNotificationsAsReadEvent());
                  },
                  child: Text(
                    'Tandai Semua Dibaca',
                    style: TextStyle(color: Colors.blue.shade700, fontSize: 12),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(BuildContext context, NotificationModel notif) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: notif.isRead
            ? Colors.grey.shade300
            : Colors.blue.shade100,
        child: _getNotificationIcon(notif.type, notif.isRead)
      ),
      title: Text(
        notif.title,
        style: TextStyle(
          fontWeight: notif.isRead ? FontWeight.normal : FontWeight.bold,
          fontSize: 15,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            notif.message,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            _formatTime(notif.timestamp),
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
        ],
      ),
      onTap: () {
        context.read<NotificationBloc>().add(MarkNotificationAsReadEvent(notif.id));
      },
      tileColor: notif.isRead ? Colors.white : Colors.blue.shade50,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Tidak ada notifikasi',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Tutup',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Icon _getNotificationIcon(NotificationType type, bool isRead) {
    switch (type) {
      case NotificationType.event:
        return Icon(
          Icons.event,
          size: 24,
          color: isRead ? Colors.grey.shade600 : Colors.green.shade700,
        );
      case NotificationType.edit:
        return Icon(
          Icons.edit,
          size: 24,
          color: isRead ? Colors.grey.shade600 : Colors.yellow.shade700,
        );
      case NotificationType.delete:
        return Icon(
          Icons.delete,
          size: 24,
          color: isRead ? Colors.grey.shade600 : Colors.red.shade700,
        );
      case NotificationType.file:
        return Icon(
          Icons.file_copy,
          size: 24,
          color: isRead ? Colors.grey.shade600 : Colors.blue.shade700,
        );
      case NotificationType.comment:
        return Icon(
          Icons.message,
          size: 24,
          color: isRead ? Colors.grey.shade600 : Colors.blue.shade700,
        );
      case NotificationType.info:
        return Icon(
          Icons.info_outline,
          size: 24,
          color: isRead ? Colors.grey.shade600 : Colors.blue.shade700,
        );
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      final List<String> monthNames = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
      ];

      final day = timestamp.day.toString().padLeft(2, '0');
      final month = monthNames[timestamp.month - 1];
      final year = timestamp.year;
      final hour = timestamp.hour.toString().padLeft(2, '0');
      final minute = timestamp.minute.toString().padLeft(2, '0');

      return '$day $month $year, $hour:$minute';
    }
  }

  /// Helper function untuk show dialog
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => BlocProvider.value(
        value: context.read<NotificationBloc>(),
        child: const NotificationDialog(),
      ),
    );
  }
}
