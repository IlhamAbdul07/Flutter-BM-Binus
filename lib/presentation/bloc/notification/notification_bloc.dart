// notification_bloc.dart
import 'package:bm_binus/data/models/notification_model.dart';
import 'package:bm_binus/presentation/bloc/notification/notification_event.dart';
import 'package:bm_binus/presentation/bloc/notification/notification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationState.initial()) {
    // =====================================================
    // HANDLER: Load Notifications
    // =====================================================
    on<LoadNotificationsEvent>((event, emit) async {
      // 1. Emit state loading
      emit(state.loading());

      try {
        // 2. Simulasi delay (kayak fetch dari API)
        await Future.delayed(const Duration(milliseconds: 500));

        // 3. Ambil dummy data
        final notifications = NotificationDummyData.getDummyNotifications();

        // 4. Emit state success dengan data
        emit(state.success(notifications));
      } catch (e) {
        // 5. Kalau error, emit state error
        emit(state.error('Gagal memuat notifikasi: $e'));
      }
    });

    // =====================================================
    // HANDLER: Mark As Read (1 notifikasi)
    // =====================================================
    on<MarkNotificationAsReadEvent>((event, emit) {
      // 1. Ambil list notifikasi yang ada
      final updatedNotifications = state.notifications.map((notif) {
        // 2. Kalau ID cocok, ubah isRead jadi true
        if (notif.id == event.notificationId) {
          return notif.copyWith(isRead: true);
        }
        return notif;
      }).toList();

      // 3. Emit state baru dengan notifikasi yang sudah diupdate
      emit(state.success(updatedNotifications));
    });

    // =====================================================
    // HANDLER: Mark All As Read
    // =====================================================
    on<MarkAllNotificationsAsReadEvent>((event, emit) {
      // 1. Ubah SEMUA notifikasi jadi isRead = true
      final updatedNotifications = state.notifications.map((notif) {
        return notif.copyWith(isRead: true);
      }).toList();

      // 2. Emit state baru
      emit(state.success(updatedNotifications));
    });

    // =====================================================
    // HANDLER: Delete Notification (hapus 1)
    // =====================================================
    on<DeleteNotificationEvent>((event, emit) {
      // 1. Filter list, buang notifikasi dengan ID yang sama
      final updatedNotifications = state.notifications
          .where((notif) => notif.id != event.notificationId)
          .toList();

      // 2. Emit state baru
      emit(state.success(updatedNotifications));
    });

    // =====================================================
    // HANDLER: Clear All (hapus semua)
    // =====================================================
    on<ClearAllNotificationsEvent>((event, emit) {
      // Emit state dengan list kosong
      emit(state.success([]));
    });

    // =====================================================
    // HANDLER: Add Notification (tambah notif baru)
    // =====================================================
    on<AddNotificationEvent>((event, emit) {
      // 1. Buat notifikasi baru
      final newNotification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: event.title,
        message: event.message,
        timestamp: DateTime.now(),
        isRead: false,
        type: _getTypeFromString(event.type),
      );

      // 2. Tambahkan ke list yang ada (di paling atas)
      final updatedNotifications = [newNotification, ...state.notifications];

      // 3. Emit state baru
      emit(state.success(updatedNotifications));
    });
  }

  // Helper: Convert string ke NotificationType
  NotificationType _getTypeFromString(String type) {
    switch (type.toLowerCase()) {
      case 'success':
        return NotificationType.success;
      case 'warning':
        return NotificationType.warning;
      case 'error':
        return NotificationType.error;
      case 'message':
        return NotificationType.message;
      case 'event':
        return NotificationType.event;
      default:
        return NotificationType.info;
    }
  }
}
