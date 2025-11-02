import 'package:bm_binus/data/dummy/event_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  EventBloc() : super(EventInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<SelectEvent>(_onSelectEvent);
    on<UpdateEvent>(_onUpdateEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<ClearSelection>(_onClearSelection);
  }

  // Load semua events
  Future<void> _onLoadEvents(LoadEvents event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try {
      // Simulasi delay untuk loading
      await Future.delayed(const Duration(milliseconds: 500));

      final events = EventData.getEvents();
      emit(EventLoaded(events: events));
    } catch (e) {
      emit(EventError('Gagal memuat data: ${e.toString()}'));
    }
  }

  // Select event untuk detail
  Future<void> _onSelectEvent(
    SelectEvent event,
    Emitter<EventState> emit,
  ) async {
    if (state is EventLoaded) {
      final currentState = state as EventLoaded;
      emit(currentState.copyWith(selectedEvent: event.event));
    }
  }

  // Update event - HANYA SNACKBAR, data tidak berubah
  Future<void> _onUpdateEvent(
    UpdateEvent event,
    Emitter<EventState> emit,
  ) async {
    if (state is EventLoaded) {
      final currentState = state as EventLoaded;

      try {
        // Simulasi API call
        await Future.delayed(const Duration(milliseconds: 500));

        // Emit success untuk trigger snackbar
        // Data TETAP sama karena dummy
        emit(
          EventOperationSuccess(
            message: 'Event berhasil diupdate!',
            events: currentState.events, // 👈 Data TIDAK berubah
          ),
        );

        // Kembali ke loaded state dengan data yang SAMA
        await Future.delayed(const Duration(milliseconds: 100));
        emit(
          EventLoaded(
            events: currentState.events, // 👈 Data tetap dari dummy
            selectedEvent: event.event,
          ),
        );
      } catch (e) {
        emit(EventError('Gagal mengupdate event: ${e.toString()}'));
      }
    }
  }

  // Delete event - HANYA SNACKBAR, data tidak berubah
  Future<void> _onDeleteEvent(
    DeleteEvent event,
    Emitter<EventState> emit,
  ) async {
    if (state is EventLoaded) {
      final currentState = state as EventLoaded;

      try {
        // Simulasi API call
        await Future.delayed(const Duration(milliseconds: 500));

        // Emit success untuk trigger snackbar
        // Data TETAP sama karena dummy
        emit(
          EventOperationSuccess(
            message: 'Event berhasil dihapus!',
            events: currentState.events, // 👈 Data TIDAK berubah
          ),
        );

        // Kembali ke loaded state dengan data yang SAMA
        await Future.delayed(const Duration(milliseconds: 100));
        emit(
          EventLoaded(events: currentState.events),
        ); // 👈 Data tetap dari dummy
      } catch (e) {
        emit(EventError('Gagal menghapus event: ${e.toString()}'));
      }
    }
  }

  // Clear selection
  Future<void> _onClearSelection(
    ClearSelection event,
    Emitter<EventState> emit,
  ) async {
    if (state is EventLoaded) {
      final currentState = state as EventLoaded;
      emit(currentState.copyWith(clearSelection: true));
    }
  }
}
