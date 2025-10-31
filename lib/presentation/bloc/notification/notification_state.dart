// notification_state.dart
import 'package:bm_binus/data/models/notification_model.dart';
import 'package:equatable/equatable.dart';

// State = kondisi/keadaan notifikasi saat ini
class NotificationState extends Equatable {
  final List<NotificationModel> notifications; // List semua notifikasi
  final bool isLoading; // Lagi loading atau tidak
  final String? errorMessage; // Pesan error (kalau ada)
  final int unreadCount; // Jumlah notifikasi belum dibaca

  const NotificationState({
    this.notifications = const [],
    this.isLoading = false,
    this.errorMessage,
    this.unreadCount = 0,
  });

  // State awal (pas pertama kali)
  factory NotificationState.initial() {
    return const NotificationState(
      notifications: [],
      isLoading: false,
      errorMessage: null,
      unreadCount: 0,
    );
  }

  // State loading (lagi ambil data)
  NotificationState loading() {
    return copyWith(isLoading: true, errorMessage: null);
  }

  // State success (data berhasil diambil)
  NotificationState success(List<NotificationModel> notifications) {
    final unread = notifications.where((n) => !n.isRead).length;
    return copyWith(
      notifications: notifications,
      isLoading: false,
      errorMessage: null,
      unreadCount: unread,
    );
  }

  // State error (ada error)
  NotificationState error(String message) {
    return copyWith(isLoading: false, errorMessage: message);
  }

  // Method untuk copy state dengan perubahan tertentu
  NotificationState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    String? errorMessage,
    int? unreadCount,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  List<Object?> get props => [
    notifications,
    isLoading,
    errorMessage,
    unreadCount,
  ];
}
