import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object> get props => [];
}

class LoadsEventRequested extends EventEvent {
  final int? userId;
  final String? ahp;
  final String? eventComplexity;

  const LoadsEventRequested(this.userId, this.ahp, this.eventComplexity);

  @override
  List<Object> get props => [userId!, ahp!, eventComplexity!];
}

class DownloadEventRequested extends EventEvent {
  final int? userId;
  final bool? forAdmin;

  const DownloadEventRequested(this.userId, this.forAdmin);

  @override
  List<Object> get props => [userId!, forAdmin!];
}

class LoadDetailEventRequested extends EventEvent {
  final int requestId;

  const LoadDetailEventRequested(this.requestId);

  @override
  List<Object> get props => [requestId];
}

class CreateEventRequested extends EventEvent {
  final String eventName;
  final String eventLocation;
  final String eventDateStart;
  final String eventDateEnd;
  final String description;
  final int eventTypeId;
  final int countParticipant;
  final List<http.MultipartFile> files;

  const CreateEventRequested(
    this.eventName, 
    this.eventLocation, 
    this.eventDateStart,
    this.eventDateEnd,
    this.description,
    this.eventTypeId,
    this.countParticipant,
    this.files
  );

  @override
  List<Object> get props => [
    eventName, 
    eventLocation, 
    eventDateStart,
    eventDateEnd,
    description,
    eventTypeId,
    countParticipant,
    files
  ];
}

class DownloadEventDetailRequested extends EventEvent {
  final int? reqId;

  const DownloadEventDetailRequested(this.reqId);

  @override
  List<Object> get props => [reqId!];
}

class UpdateEventRequested extends EventEvent {
  final int requestId;
  final String? eventName;
  final String? eventLocation;
  final String? eventDateStart;
  final String? eventDateEnd;
  final String? description;
  final int? eventTypeId;
  final int? countParticipant;
  final int? statusId;

  const UpdateEventRequested(
    this.requestId,
    this.eventName, 
    this.eventLocation, 
    this.eventDateStart,
    this.eventDateEnd,
    this.description,
    this.eventTypeId,
    this.countParticipant,
    this.statusId
  );

  @override
  List<Object> get props => [
    requestId,
    eventName!, 
    eventLocation!, 
    eventDateStart!,
    eventDateEnd!,
    description!,
    eventTypeId!,
    countParticipant!,
    statusId!
  ];
}

class DeleteEventRequested extends EventEvent {
  final int reqId;

  const DeleteEventRequested(this.reqId);

  @override
  List<Object> get props => [reqId];
}

class ResetTrxStateRequested extends EventEvent {}
