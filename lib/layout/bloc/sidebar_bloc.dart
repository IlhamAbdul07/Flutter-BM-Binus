import 'package:flutter_bloc/flutter_bloc.dart';
import 'sidebar_event.dart';
import 'sidebar_state.dart';

class SidebarBloc extends Bloc<SidebarEvent, SidebarState> {
  SidebarBloc() : super(const SidebarState(selectedRoute: '/dashboard')) {
    on<SelectPageEvent>((event, emit) {
      emit(state.copyWith(selectedRoute: event.route));
    });
  }
}
