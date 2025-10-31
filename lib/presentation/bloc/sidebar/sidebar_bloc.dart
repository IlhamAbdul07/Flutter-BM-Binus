import 'package:flutter_bloc/flutter_bloc.dart';
import 'sidebar_event.dart';
import 'sidebar_state.dart';

class SidebarBloc extends Bloc<SidebarEvent, SidebarState> {
  SidebarBloc() : super(const SidebarState(selectedRoute: '/dashboard')) {
    on<SelectPageEvent>((event, emit) {
      emit(state.copyWith(selectedRoute: event.route));
    });

    on<ToggleMenuExpansionEvent>((event, emit) {
      // Ambil list menu yang lagi dibuka
      final newExpanded = Set<String>.from(state.expandedMenus);

      // Kalau menu sudah dibuka, tutup. Kalau belum, buka.
      if (newExpanded.contains(event.menuId)) {
        newExpanded.remove(event.menuId); // Tutup menu
      } else {
        newExpanded.add(event.menuId); // Buka menu
      }

      // Emit state baru
      emit(state.copyWith(expandedMenus: newExpanded));
    });
  }
}
