import 'package:bm_binus/data/models/event_detail_model.dart';
import 'package:bm_binus/data/models/event_model.dart';
import 'package:equatable/equatable.dart';

class EventState extends Equatable {
  final List<EventModel> events;
  final EventDetailModel? singleEvent;
  final bool isLoading;
  final String? errorFetch; 
  final bool isSuccessTrx;
  final String? errorTrx;
  final String? typeTrx;
  final bool isLoadingTrx;

  const EventState({
    this.events = const [],
    this.singleEvent,
    this.isLoading = false,
    this.errorFetch,
    required this.isSuccessTrx,
    this.errorTrx,
    this.typeTrx,
    this.isLoadingTrx = false
  });

  factory EventState.initial() {
    return const EventState(
      events: [],
      singleEvent: null,
      isLoading: false,
      errorFetch: null,
      isSuccessTrx: false,
      errorTrx: null,
      typeTrx: null,
      isLoadingTrx: false
    );
  }

  EventState loading() {
    return copyWith(isLoading: true, errorFetch: null);
  }

  EventState success(List<EventModel> events) {
    return copyWith(
      events: events,
      isLoading: false,
      errorFetch: null,
    );
  }

  EventState error(String message) {
    return copyWith(isLoading: false, errorFetch: message);
  }

  EventState setLoadingTrx(bool loading) {
    return copyWith(isLoadingTrx: loading);
  }

  EventState successDetail(EventDetailModel? event) {
    return copyWith(
      singleEvent: event,
      isLoading: false,
      errorFetch: null,
    );
  }

  EventState copyWith({
    List<EventModel>? events,
    EventDetailModel? singleEvent,
    bool? isLoading,
    String? errorFetch,
    bool? isSuccessTrx,
    String? errorTrx,
    String? typeTrx,
    bool? isLoadingTrx,
  }) {
    return EventState(
      events: events ?? this.events,
      singleEvent: singleEvent ?? this.singleEvent,
      isLoading: isLoading ?? this.isLoading,
      errorFetch: errorFetch,
      isSuccessTrx: isSuccessTrx ?? this.isSuccessTrx,
      errorTrx: errorTrx,
      typeTrx: typeTrx,
      isLoadingTrx: isLoadingTrx ?? this.isLoadingTrx,
    );
  }

  @override
  List<Object?> get props => [events, singleEvent, isLoading, errorFetch, isSuccessTrx, errorTrx, typeTrx, isLoadingTrx];
}
