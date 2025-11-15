import 'package:flutter_bloc/flutter_bloc.dart';
import 'priority_event.dart';
import 'priority_state.dart';

class PriorityBloc extends Bloc<PriorityEvent, PriorityState> {
  PriorityBloc() : super(const PriorityState()) {
    on<TogglePriorityEvent>(_onTogglePriority);
    on<LoadPriorityEvent>(_onLoadPriority);
  }

  Future<void> _onTogglePriority(
    TogglePriorityEvent event,
    Emitter<PriorityState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      // TODO: Implement API call untuk save priority setting
      // await apiService.updatePriority(event.isEnabled);

      // Dummy delay untuk simulasi API call
      await Future.delayed(const Duration(milliseconds: 500));

      emit(
        state.copyWith(
          usePriority: event.isEnabled,
          isLoading: false,
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadPriority(
    LoadPriorityEvent event,
    Emitter<PriorityState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      // TODO: Implement API call untuk load priority setting
      // final priority = await apiService.getPriority();

      // Dummy delay untuk simulasi API call
      await Future.delayed(const Duration(milliseconds: 500));

      emit(
        state.copyWith(
          usePriority: false, // nanti ganti dengan data dari API
          isLoading: false,
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
