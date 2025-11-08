// notification_state.dart
import 'package:bm_binus/data/models/notification_model.dart';
import 'package:equatable/equatable.dart';

// State = kondisi/keadaan notifikasi saat ini
class NotificationState extends Equatable {
  final List<NotificationModel> notifications; // List semua notifikasi
  final bool isLoading; // Lagi loading atau tidak
  final bool sessionExp;
  final String? errorMessage; // Pesan error (kalau ada)
  final int unreadCount; // Jumlah notifikasi belum dibaca
  final int? requestId;

  const NotificationState({
    this.notifications = const [],
    this.isLoading = false,
    this.sessionExp = false,
    this.errorMessage,
    this.unreadCount = 0,
    this.requestId,
  });

  // State awal (pas pertama kali)
  factory NotificationState.initial() {
    return const NotificationState(
      notifications: [],
      isLoading: false,
      sessionExp: false,
      errorMessage: null,
      unreadCount: 0,
      requestId: null,
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
    return copyWith(isLoading: false, sessionExp: false, errorMessage: message);
  }

  NotificationState sessionExpired(String message) {
    return copyWith(isLoading: false, sessionExp: true, errorMessage: message);
  }

  NotificationState setRequestId(int? reqId) {
    return copyWith(requestId: reqId);
  }

  // Method untuk copy state dengan perubahan tertentu
  NotificationState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    bool? sessionExp,
    String? errorMessage,
    int? unreadCount,
    int? requestId,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      sessionExp: sessionExp ?? this.sessionExp,
      errorMessage: errorMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      requestId: requestId,
    );
  }

  @override
  List<Object?> get props => [
    notifications,
    isLoading,
    sessionExp,
    errorMessage,
    unreadCount,
    requestId,
  ];
}
