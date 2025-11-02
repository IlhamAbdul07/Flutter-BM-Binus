import 'package:equatable/equatable.dart';
import 'package:bm_binus/data/models/event_model.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object?> get props => [];
}

// Event untuk load semua data
class LoadEvents extends EventEvent {}

// Event untuk select/view detail event
class SelectEvent extends EventEvent {
  final EventModel event;

  const SelectEvent(this.event);

  @override
  List<Object?> get props => [event];
}

// Event untuk update event
class UpdateEvent extends EventEvent {
  final EventModel event;

  const UpdateEvent(this.event);

  @override
  List<Object?> get props => [event];
}

// Event untuk delete event
class DeleteEvent extends EventEvent {
  final int eventNo;

  const DeleteEvent(this.eventNo);

  @override
  List<Object?> get props => [eventNo];
}

// Event untuk clear selection
class ClearSelection extends EventEvent {}
