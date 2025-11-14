import 'package:equatable/equatable.dart';

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
