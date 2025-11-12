import 'package:bm_binus/core/services/api_service.dart';
import 'package:bm_binus/data/models/event_type_model.dart';
import 'package:bm_binus/presentation/bloc/event_type/event_type_event.dart';
import 'package:bm_binus/presentation/bloc/event_type/event_type_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventTypeBloc extends Bloc<EventTypeEvent, EventTypeState> {
  EventTypeBloc() : super(EventTypeState.initial()) {
    on<LoadEventTypeEvent>((event, emit) async {
      emit(state.loading());
      try {
        final response = await ApiService.handleEventType(method: "GET", params: {
          "no_paging": "yes",
          "order": "priority",
          "order_by": "asc"
        });
        if (response != null && response["success"] == true && response["data"] != null) {
          final data = response["data"]["data"];
          final info = response["data"]["info"];

          if (data == null) {
            emit(state.success([], info as String));
            return;
          }

          final List<EventType> eventType = (data as List)
              .map((item) => EventType(
                    id: item["id"] ?? 0,
                    name: item["name"] ?? "",
                    priority: item["priority"] ?? 0,
                  ))
              .toList();

          emit(state.success(eventType, info as String));
        } else {
          emit(state.error("Gagal memuat data event type"));
        }
      } catch (e) {
        emit(state.error("Terjadi kesalahan: $e"));
      }
    });

    on<CreateEventTypeRequested>((event, emit) async {
      try {
        final response = await ApiService.handleEventType(method: 'POST', data: {
          'name': event.name,
          'priority': event.priority,
        });

        if (response != null && response['success'] == true) {
          emit(EventTypeState(isSuccessTrx: true, errorTrx: null, typeTrx: "create"));
        } else {
          if (response != null && response['data'] != null) {
            final message = response['data']?['message'] ?? 'Terjadi kesalahan yang tidak diketahui';
            emit(
              EventTypeState(
                isSuccessTrx: false,
                errorTrx: message,
                typeTrx: null,
              ),
            );
          } else {
            emit(
              EventTypeState(
                isSuccessTrx: false,
                errorTrx: response?['message'] ?? 'Terjadi kesalahan yang tidak diketahui',
                typeTrx: null,
              ),
            );
          }
        }
      } catch (e) {
        emit(
          EventTypeState(
            isSuccessTrx: false,
            errorTrx: '$e',
            typeTrx: null,
          ),
        );
      }
    });

    on<UpdateEventTypeRequested>((event, emit) async {
      try {
        Map<String, dynamic> data = {};
        if (event.name != null){
          data['name'] = event.name;
        }
        if (event.priority != null){
          data['priority'] = event.priority;
        }
        final response = await ApiService.handleEventType(method: 'PUT', eventTypeId: event.eventTypeId, data: data);

        if (response != null && response['success'] == true) {
          emit(EventTypeState(isSuccessTrx: true, errorTrx: null, typeTrx: "update"));
        } else {
          if (response != null && response['data'] != null) {
            final message = response['data']?['message'] ?? 'Terjadi kesalahan yang tidak diketahui';
            emit(
              EventTypeState(
                isSuccessTrx: false,
                errorTrx: message,
                typeTrx: null,
              ),
            );
          } else {
            emit(
              EventTypeState(
                isSuccessTrx: false,
                errorTrx: response?['message'] ?? 'Terjadi kesalahan yang tidak diketahui',
                typeTrx: null,
              ),
            );
          }
        }
      } catch (e) {
        emit(
          EventTypeState(
            isSuccessTrx: false,
            errorTrx: '$e',
            typeTrx: null,
          ),
        );
      }
    });

    on<DeleteEventTypeRequested>((event, emit) async {
      try {
        final response = await ApiService.handleEventType(method: 'DELETE', eventTypeId: event.eventTypeId);

        if (response != null && response['success'] == true) {
          emit(EventTypeState(isSuccessTrx: true, errorTrx: null, typeTrx: "delete"));
        } else {
          if (response != null && response['data'] != null) {
            final message = response['data']?['message'] ?? 'Terjadi kesalahan yang tidak diketahui';
            emit(
              EventTypeState(
                isSuccessTrx: false,
                errorTrx: message,
                typeTrx: null,
              ),
            );
          } else {
            emit(
              EventTypeState(
                isSuccessTrx: false,
                errorTrx: response?['message'] ?? 'Terjadi kesalahan yang tidak diketahui',
                typeTrx: null,
              ),
            );
          }
        }
      } catch (e) {
        emit(
          EventTypeState(
            isSuccessTrx: false,
            errorTrx: '$e',
            typeTrx: null,
          ),
        );
      }
    });
  }
}
