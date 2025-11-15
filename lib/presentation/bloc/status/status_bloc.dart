import 'package:bm_binus/core/services/api_service.dart';
import 'package:bm_binus/data/models/status_model.dart';
import 'package:bm_binus/presentation/bloc/status/status_event.dart';
import 'package:bm_binus/presentation/bloc/status/status_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  StatusBloc() : super(StatusState.initial()) {
    on<LoadStatusEvent>((event, emit) async {
      emit(state.loading());
      try {
        final response = await ApiService.handleStatus(method: "GET", params: {
          "no_paging": "yes",
        });
        if (response != null && response["success"] == true && response["data"] != null) {
          final data = response["data"]["data"];

          if (data == null) {
            emit(state.success([]));
            return;
          }

          final List<Status> status = (data as List)
              .map((item) => Status(
                    id: item["id"] ?? 0,
                    name: item["name"] ?? "",
                  ))
              .toList();

          emit(state.success(status));
        } else {
          emit(state.error("Gagal memuat data status"));
        }
      } catch (e) {
        emit(state.error("Terjadi kesalahan: $e"));
      }
    });
  }
}
