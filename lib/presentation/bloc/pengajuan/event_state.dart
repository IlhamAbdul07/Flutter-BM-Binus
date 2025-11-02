import 'package:equatable/equatable.dart';
import 'package:bm_binus/data/models/event_model.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object?> get props => [];
}

// Initial state
class EventInitial extends EventState {}

// Loading state
class EventLoading extends EventState {}

// Loaded state dengan list events
class EventLoaded extends EventState {
  final List<EventModel> events;
  final EventModel? selectedEvent;

  const EventLoaded({required this.events, this.selectedEvent});

  @override
  List<Object?> get props => [events, selectedEvent];

  EventLoaded copyWith({
    List<EventModel>? events,
    EventModel? selectedEvent,
    bool clearSelection = false,
  }) {
    return EventLoaded(
      events: events ?? this.events,
      selectedEvent: clearSelection
          ? null
          : (selectedEvent ?? this.selectedEvent),
    );
  }
}

// Success state untuk operasi update/delete
class EventOperationSuccess extends EventState {
  final String message;
  final List<EventModel> events;

  const EventOperationSuccess({required this.message, required this.events});

  @override
  List<Object?> get props => [message, events];
}

// Error state
class EventError extends EventState {
  final String message;

  const EventError(this.message);

  @override
  List<Object?> get props => [message];
}
