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
        final response = await ApiService.handleNotifDashboard(method: "GET", params: {
          "order": "created_at",
          "order_by": "desc",
        });
        if (response != null && response["success"] == true && response["data"] != null) {
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

    on<MarkNotificationAsReadEvent>((event, emit) async {
      try {
        final response = await ApiService.handleNotifDashboard(method: "PATCH", notifId: int.parse(event.notificationId));
        if (response["success"] == true && response["data"] != null) {
          final data = response["data"];
          add(LoadNotificationsEvent());
          emit(state.setRequestId(data["request_id"]));
        } else {
          emit(state.error("Gagal mark notif as read"));
        }
      } catch (e) {
        emit(state.error("Terjadi kesalahan: $e"));
      }
    });

    on<MarkAllNotificationsAsReadEvent>((event, emit) async {
      try {
        final response = await ApiService.handleNotifDashboard(method: "PUT");
        if (response["success"] == true && response["data"] != null) {
          add(LoadNotificationsEvent());
        } else {
          emit(state.error("Gagal mark all notif as read"));
        }
      } catch (e) {
        emit(state.error("Terjadi kesalahan: $e"));
      }
    });
  }

  NotificationType _detectType(String? title) {
    if (title == null) return NotificationType.info;

    final lower = title.toLowerCase();
    if (lower.contains("komentar")) {
      return NotificationType.comment;
    } else if (lower.contains("berkas baru")) {
      return NotificationType.file;
    } else if (lower.contains("berkas dihapus")) {
      return NotificationType.delete;
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
}
