import 'package:equatable/equatable.dart';

abstract class StatusEvent extends Equatable {
  const StatusEvent();

  @override
  List<Object> get props => [];
}

class LoadStatusEvent extends StatusEvent {}