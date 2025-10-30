import 'package:equatable/equatable.dart';

abstract class SidebarEvent extends Equatable {
  const SidebarEvent();

  @override
  List<Object> get props => [];
}

class SelectPageEvent extends SidebarEvent {
  final String route;

  const SelectPageEvent(this.route);

  @override
  List<Object> get props => [route];
}

class ToggleMenuExpansionEvent extends SidebarEvent {
  final String menuId;

  const ToggleMenuExpansionEvent(this.menuId);

  @override
  List<Object> get props => [menuId];
}
