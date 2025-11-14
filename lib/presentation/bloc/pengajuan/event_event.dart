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