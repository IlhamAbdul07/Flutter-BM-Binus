import 'package:bm_binus/core/services/api_service.dart';
import 'package:bm_binus/data/models/event_detail_model.dart';
import 'package:bm_binus/data/models/event_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  EventBloc() : super(EventState.initial()) {
    on<LoadsEventRequested>((event, emit) async {
      emit(state.loading());
      try {
        Map<String, String> data = {};
        data["no_paging"] = "yes";
        if (event.userId != null){
          data["user_id"] = event.userId.toString();
        }
        if (event.ahp != null){
          data["use_ahp"] = "yes";
        }
        if (event.eventComplexity != null){
          data["event_complexity"] = event.eventComplexity!;
        }
        final response = await ApiService.handleRequest(method: "GET", params: data);
        if (response != null && response["success"] == true && response["data"] != null) {
          final data = response["data"]["data"];

          if (data == null) {
            emit(state.success([]));
            return;
          }

          final List<EventModel> events = (data as List)
              .map((item) => EventModel(
                    id: item['id'] ?? 0,
                    eventName: item['event_name'] ?? "",
                    eventLocation: item['event_location'] ?? "",
                    eventDateStart: DateTime.parse(item['event_date_start']),
                    eventDateEnd: DateTime.parse(item['event_date_end']),
                    eventTypeId: item['event_type']?['id'] ?? 0,
                    eventTypeName: item['event_type']?['name'] ?? '',
                    statusId: item['status']?['id'] ?? 0,
                    statusName: item['status']?['name'] ?? '',
                    userId: item['user']?['id'] ?? 0,
                    userName: item['user']?['name'] ?? '',
                    createdAt: DateTime.parse(item['created_at']),
                    ahpPercent: item['ahp_score']?['percent'] ?? '',
                    ahpRaw: item['ahp_score']?['raw'] ?? 0.0,
                  ))
              .toList();

          emit(state.success(events));
        } else {
          emit(state.error("Gagal memuat data events"));
        }
      } catch (e) {
        emit(state.error("Terjadi kesalahan: $e"));
      }
    });

    on<DownloadEventRequested>((event, emit) async {
      emit(state.setLoadingTrx(true));
      try {
        Map<String, String> params = {};
        params["format"] = 'pdf';
        if (event.userId != null){
          params["user_id"] = event.userId.toString();
        }
        if (event.forAdmin != null){
          params["for_admin"] = true.toString();
        }
        final response = await ApiService.exportRequests(params);
        if (response.statusCode == 200) {
          await ApiService.downloadFileFromResponse(response);
        } else {
          emit(state.error("Gagal download data requests"));
        }
      } catch (e) {
        emit(state.error("Terjadi kesalahan: $e"));
      }
      emit(state.setLoadingTrx(false));
    });

    on<LoadDetailEventRequested>((event, emit) async {
      emit(state.loading());
      try {
        final response = await ApiService.handleRequest(method: "GET", requestId: event.requestId);
        if (response != null && response["success"] == true && response["data"] != null) {
          final data = response["data"]["data"];

          if (data == null) {
            emit(state.successDetail(null));
            return;
          }

          final item = data;
          final eventDetail = EventDetailModel(
            id: item['id'] ?? 0,
            eventName: item['event_name'] ?? "",
            eventLocation: item['event_location'] ?? "",
            eventDateStart: DateTime.parse(item['event_date_start']),
            eventDateEnd: DateTime.parse(item['event_date_end']),
            description: item['description'] ?? "",
            eventTypeId: item['event_type']?['id'] ?? 0,
            eventTypeName: item['event_type']?['name'] ?? '',
            statusId: item['status']?['id'] ?? 0,
            statusName: item['status']?['name'] ?? '',
            userId: item['user']?['id'] ?? 0,
            userName: item['user']?['name'] ?? '',
            countParticipant: item['count_participant'] ?? 0,
            createdAt: DateTime.parse(item['created_at']),
            updatedAt: DateTime.parse(item['updated_at']),
          );

          emit(state.successDetail(eventDetail));
        } else {
          emit(state.error("Gagal memuat data single event"));
        }
      } catch (e) {
        emit(state.error("Terjadi kesalahan: $e"));
      }
    });

    on<CreateEventRequested>((event, emit) async {
      emit(state.setLoadingTrx(true));
      try {
        final response = await ApiService.handleRequest(method: 'POST', data: {
          'event_name': event.eventName,
          'event_location': event.eventLocation,
          'event_date_start': event.eventDateStart,
          'event_date_end': event.eventDateEnd,
          'description': event.description,
          'event_type_id': event.eventTypeId,
          'count_participant': event.countParticipant,
        }, listFile: event.files, contentType: 'multipart/form-data');

        if (response != null && response['success'] == true) {
          emit(EventState(isSuccessTrx: true, errorTrx: null));
        } else {
          if (response != null && response['data'] != null) {
            final message = response['data']?['message'] ?? 'Terjadi kesalahan yang tidak diketahui';
            final translatedMessage = message.toString().contains('not approved')
                ? 'Format berkas yang diunggah tidak didukung.'
                : message;
            emit(
              EventState(
                isSuccessTrx: false,
                errorTrx: translatedMessage,
              ),
            );
          } else {
            emit(
              EventState(
                isSuccessTrx: false,
                errorTrx: response?['message'] ?? 'Terjadi kesalahan yang tidak diketahui',
              ),
            );
          }
        }
      } catch (e) {
        emit(
          EventState(
            isSuccessTrx: false,
            errorTrx: '$e',
          ),
        );
      } finally {
        emit(state.setLoadingTrx(false));
      }
    });

    on<DownloadEventDetailRequested>((event, emit) async {
      emit(state.setLoadingTrx(true));
      try {
        final response = await ApiService.exportRequestById(event.reqId!);
        if (response.statusCode == 200) {
          await ApiService.downloadFileFromResponse(response);
        } else {
          emit(state.error("Gagal download data detail request"));
        }
      } catch (e) {
        emit(state.error("Terjadi kesalahan: $e"));
      }
      emit(state.setLoadingTrx(false));
    });

    on<UpdateEventRequested>((event, emit) async {
      emit(state.setLoadingType("update", true));
      try {
        Map<String, dynamic> data = {};
        if (event.eventName != null){
          data['event_name'] = event.eventName;
        }
        if (event.eventLocation != null){
          data['event_location'] = event.eventLocation;
        }
        if (event.eventDateStart != null){
          data['event_date_start'] = event.eventDateStart;
        }
        if (event.eventDateEnd != null){
          data['event_date_end'] = event.eventDateEnd;
        }
        if (event.description != null){
          data['description'] = event.description;
        }
        if (event.eventTypeId != null){
          data['event_type_id'] = event.eventTypeId;
        }
        if (event.countParticipant != null){
          data['count_participant'] = event.countParticipant;
        }
        if (event.statusId != null){
          data['status_id'] = event.statusId;
        }
        final response = await ApiService.handleRequest(method: 'PUT', requestId: event.requestId, data: data);

        if (response != null && response['success'] == true) {
          emit(state.copyWith(
            isSuccessTrx: true,
            errorTrx: null,
            typeTrx: "update",
          ));
        } else {
          if (response != null && response['data'] != null) {
            final message = response['data']?['message'] ?? 'Terjadi kesalahan yang tidak diketahui';
            emit(state.copyWith(
              isSuccessTrx: false,
              errorTrx: message,
              typeTrx: null,
            ));
          } else {
            emit(state.copyWith(
              isSuccessTrx: false,
              errorTrx: response?['message'] ?? 'Terjadi kesalahan yang tidak diketahui',
              typeTrx: null,
            ));
          }
        }
      } catch (e) {
        emit(state.copyWith(
          isSuccessTrx: false,
          errorTrx: '$e',
          typeTrx: null,
        ));
      } finally {
        emit(state.setLoadingType("update", false));
      }
    });

    on<DeleteEventRequested>((event, emit) async {
      emit(state.setLoadingType("delete", true));
      try {
        final response = await ApiService.handleRequest(method: 'DELETE', requestId: event.reqId);

        if (response != null && response['success'] == true) {
          emit(state.copyWith(
            isSuccessTrx: true,
            errorTrx: null,
            typeTrx: "delete",
          ));
        } else {
          if (response != null && response['data'] != null) {
            final message = response['data']?['message'] ?? 'Terjadi kesalahan yang tidak diketahui';
            emit(state.copyWith(
              isSuccessTrx: false,
              errorTrx: message,
              typeTrx: null,
            ));
          } else {
            emit(state.copyWith(
              isSuccessTrx: false,
              errorTrx: response?['message'] ?? 'Terjadi kesalahan yang tidak diketahui',
              typeTrx: null,
            ));
          }
        }
      } catch (e) {
        emit(state.copyWith(
          isSuccessTrx: false,
          errorTrx: '$e',
          typeTrx: null,
        ));
      } finally {
        emit(state.setLoadingType("delete", false));
      }
    });

    on<ResetTrxStateRequested>((event, emit) {
      emit(state.copyWith(
        isSuccessTrx: false,
        errorTrx: null,
        typeTrx: null,
        loadingType: {},
      ));
    });
  }
}
