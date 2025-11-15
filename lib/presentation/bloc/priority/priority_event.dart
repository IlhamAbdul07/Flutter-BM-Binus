import 'package:equatable/equatable.dart';

abstract class PriorityEvent extends Equatable {
  const PriorityEvent();

  @override
  List<Object> get props => [];
}

class TogglePriorityEvent extends PriorityEvent {
  final bool isEnabled;

  const TogglePriorityEvent(this.isEnabled);

  @override
  List<Object> get props => [isEnabled];
}

class LoadPriorityEvent extends PriorityEvent {}
