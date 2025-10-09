import 'package:equatable/equatable.dart';

class SidebarState extends Equatable {
  final String selectedRoute;

  const SidebarState({required this.selectedRoute});

  SidebarState copyWith({String? selectedRoute}) {
    return SidebarState(selectedRoute: selectedRoute ?? this.selectedRoute);
  }

  @override
  List<Object> get props => [selectedRoute];
}
