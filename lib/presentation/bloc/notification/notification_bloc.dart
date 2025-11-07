import 'dart:developer';

import 'package:bm_binus/core/notifiers/session_notifier.dart';
import 'package:bm_binus/core/services/api_service.dart';
import 'package:bm_binus/data/models/notification_model.dart';
import 'package:bm_binus/presentation/bloc/notification/notification_event.dart';
import 'package:bm_binus/presentation/bloc/notification/notification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationState.initial()) {

    sessionExpiredNotifier.addListener(() {
      final expired = sessionExpiredNotifier.value;
      if (expired) {
        add(SessionExpiredInternalEvent());
      }
    });

    on<SessionExpiredInternalEvent>((event, emit) {
      emit(state.sessionExpired("Sesi Anda telah berakhir, Silakan login ulang."));
    });

    on<ResetSessionEvent>((event, emit) {
      sessionExpiredNotifier.value = false;
      log("Session Reset: ${sessionExpiredNotifier.value}");
      emit(state.copyWith(
        isLoading: false,
        sessionExp: false,
        errorMessage: null,
      ));
    });

    on<LoadNotificationsEvent>((event, emit) async {
      emit(state.loading());
      try {
        final response = await ApiService.handleNotifDashboard(method: "GET");
        if (response["success"] == true && response["data"] != null) {
          final data = response["data"]["data"];

          if (data == null) {
            emit(state.success([]));
            return;
          }

          final List<NotificationModel> notifications = (data as List)
              .map((item) => NotificationModel(
                    id: item["id"].toString(),
                    title: item["title"] ?? "-",
                    message: item["message"] ?? "-",
                    timestamp: DateTime.parse(item["created_at"]),
                    isRead: item["is_read"] ?? false,
                    type: _detectType(item["title"]),
                  ))
              .toList();

          emit(state.success(notifications));
        } else {
          emit(state.error("Gagal memuat data notifikasi"));
        }
      } catch (e) {
        emit(state.error("Terjadi kesalahan: $e"));
      }
    });

    // =====================================================
    // HANDLER: Mark As Read (1 notifikasi)
    // =====================================================
    on<MarkNotificationAsReadEvent>((event, emit) {
      final updatedNotifications = state.notifications.map((notif) {
        if (notif.id == event.notificationId) {
          return notif.copyWith(isRead: true);
        }
        return notif;
      }).toList();

      emit(state.success(updatedNotifications));
    });

    // =====================================================
    // HANDLER: Mark All As Read
    // =====================================================
    on<MarkAllNotificationsAsReadEvent>((event, emit) {
      final updatedNotifications =
          state.notifications.map((notif) => notif.copyWith(isRead: true)).toList();

      emit(state.success(updatedNotifications));
    });

    // =====================================================
    // HANDLER: Delete Notification (hapus 1)
    // =====================================================
    on<DeleteNotificationEvent>((event, emit) {
      final updatedNotifications = state.notifications
          .where((notif) => notif.id != event.notificationId)
          .toList();

      emit(state.success(updatedNotifications));
    });

    // =====================================================
    // HANDLER: Clear All (hapus semua)
    // =====================================================
    on<ClearAllNotificationsEvent>((event, emit) {
      emit(state.success([]));
    });

    // =====================================================
    // HANDLER: Add Notification (tambah notif baru)
    // =====================================================
    on<AddNotificationEvent>((event, emit) {
      final newNotification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: event.title,
        message: event.message,
        timestamp: DateTime.now(),
        isRead: false,
        type: _getTypeFromString(event.type),
      );

      final updatedNotifications = [newNotification, ...state.notifications];

      emit(state.success(updatedNotifications));
    });
  }

  // Helper untuk deteksi tipe notifikasi berdasarkan judul
  NotificationType _detectType(String? title) {
    if (title == null) return NotificationType.info;

    final lower = title.toLowerCase();
    if (lower.contains("berkas")) {
      return NotificationType.file;
    } else if (lower.contains("komentar")) {
      return NotificationType.comment;
    } else if (lower.contains("event baru")) {
      return NotificationType.event;
    } else if (lower.contains("event diperbarui")) {
      return NotificationType.edit;
    } else if (lower.contains("event dihapus")) {
      return NotificationType.delete;
    } else {
      return NotificationType.info;
    }
  }

  // Helper konversi string ke NotificationType
  NotificationType _getTypeFromString(String type) {
    switch (type.toLowerCase()) {
      case 'event baru':
        return NotificationType.event;
      case 'event diperbarui':
        return NotificationType.edit;
      case 'event dihapus':
        return NotificationType.delete;
      case 'comment':
        return NotificationType.comment;
      case 'file':
        return NotificationType.file;
      default:
        return NotificationType.info;
    }
  }
}
