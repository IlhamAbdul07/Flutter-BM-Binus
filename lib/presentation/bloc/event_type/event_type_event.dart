import 'package:equatable/equatable.dart';

abstract class EventTypeEvent extends Equatable {
  const EventTypeEvent();

  @override
  List<Object> get props => [];
}

class LoadEventTypeEvent extends EventTypeEvent {}

class CreateEventTypeRequested extends EventTypeEvent {
  final String name;
  final int priority;

  const CreateEventTypeRequested(this.name, this.priority);

  @override
  List<Object> get props => [name, priority];
}

class UpdateEventTypeRequested extends EventTypeEvent {
  final int eventTypeId;
  final String? name;
  final int? priority;

  const UpdateEventTypeRequested(this.eventTypeId, this.name, this.priority);

  @override
  List<Object> get props => [eventTypeId, name!, priority!];
}

class DeleteEventTypeRequested extends EventTypeEvent {
  final int eventTypeId;

  const DeleteEventTypeRequested(this.eventTypeId);

  @override
  List<Object> get props => [eventTypeId];
}
