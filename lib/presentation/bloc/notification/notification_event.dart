// notification_event.dart
import 'package:equatable/equatable.dart';

// Event = aksi yang bisa dilakukan user
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

// Event: Load/ambil data notifikasi (pas pertama kali buka)
class LoadNotificationsEvent extends NotificationEvent {}

// Event: Tandai 1 notifikasi sebagai sudah dibaca
class MarkNotificationAsReadEvent extends NotificationEvent {
  final String notificationId;

  const MarkNotificationAsReadEvent(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

// Event: Tandai SEMUA notifikasi sebagai sudah dibaca
class MarkAllNotificationsAsReadEvent extends NotificationEvent {}

// Event: Hapus 1 notifikasi
class DeleteNotificationEvent extends NotificationEvent {
  final String notificationId;

  const DeleteNotificationEvent(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

// Event: Hapus SEMUA notifikasi
class ClearAllNotificationsEvent extends NotificationEvent {}

// Event: Tambah notifikasi baru (untuk simulasi)
class AddNotificationEvent extends NotificationEvent {
  final String title;
  final String message;
  final String type;

  const AddNotificationEvent({
    required this.title,
    required this.message,
    this.type = 'info',
  });

  @override
  List<Object> get props => [title, message, type];
}
