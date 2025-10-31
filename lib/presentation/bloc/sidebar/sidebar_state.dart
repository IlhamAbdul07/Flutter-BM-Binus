import 'package:equatable/equatable.dart';

class SidebarState extends Equatable {
  final String selectedRoute;
  final Set<String> expandedMenus;

  const SidebarState({
    required this.selectedRoute,
    this.expandedMenus = const {},
  });

  SidebarState copyWith({String? selectedRoute, Set<String>? expandedMenus}) {
    return SidebarState(
      selectedRoute: selectedRoute ?? this.selectedRoute,
      expandedMenus: expandedMenus ?? this.expandedMenus,
    );
  }

  @override
  List<Object> get props => [selectedRoute, expandedMenus];
}
