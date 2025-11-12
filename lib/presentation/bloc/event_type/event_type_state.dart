import 'package:bm_binus/data/models/event_type_model.dart';
import 'package:equatable/equatable.dart';

class EventTypeState extends Equatable {
  final List<EventType> eventType;
  final bool isLoading;
  final String? errorFetch; 
  final String? infoFetch;
  final bool isSuccessTrx;
  final String? errorTrx;
  final String? typeTrx;

  const EventTypeState({
    this.eventType = const [],
    this.isLoading = false,
    this.errorFetch,
    this.infoFetch,
    required this.isSuccessTrx,
    this.errorTrx,
    this.typeTrx,
  });

  factory EventTypeState.initial() {
    return const EventTypeState(
      eventType: [],
      isLoading: false,
      errorFetch: null,
      infoFetch: null,
      isSuccessTrx: false,
      errorTrx: null,
      typeTrx: null,
    );
  }

  EventTypeState loading() {
    return copyWith(isLoading: true, errorFetch: null);
  }

  EventTypeState success(List<EventType> eventType, String info) {
    return copyWith(
      eventType: eventType,
      isLoading: false,
      errorFetch: null,
      infoFetch: info,
    );
  }

  EventTypeState error(String message) {
    return copyWith(isLoading: false, errorFetch: message);
  }

  EventTypeState setLoading(bool loading) {
    return copyWith(isLoading: loading);
  }

  EventTypeState copyWith({
    List<EventType>? eventType,
    bool? isLoading,
    String? errorFetch,
    String? infoFetch,
    bool? isSuccessTrx,
    String? errorTrx,
    String? typeTrx,
  }) {
    return EventTypeState(
      eventType: eventType ?? this.eventType,
      isLoading: isLoading ?? this.isLoading,
      errorFetch: errorFetch,
      infoFetch: infoFetch,
      isSuccessTrx: isSuccessTrx ?? this.isSuccessTrx,
      errorTrx: errorTrx,
      typeTrx: typeTrx,
    );
  }

  @override
  List<Object?> get props => [eventType, isLoading, errorFetch, infoFetch, isSuccessTrx, errorTrx, typeTrx];
}
