import 'package:bm_binus/core/services/api_service.dart';
import 'package:bm_binus/presentation/bloc/user/user_event.dart';
import 'package:bm_binus/presentation/bloc/user/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserState(isChangePw: false)) {
    on<ChangePasswordRequested>(_onChangePasswordRequested);
  }

  Future<void> _onChangePasswordRequested(ChangePasswordRequested event, Emitter<UserState> emit) async {
    try {
      final response = await ApiService.handleUser(method: 'PATCH', userId: event.userId, data: {
        'old_password': event.oldPassword,
        'new_password': event.newPassword,
      });

      if (response != null && response['success'] == true) {
        emit(UserState(isChangePw: true, errorChangePw: null));
      } else {
        if (response != null && response['data'] != null) {
          final message = response['data']?['message'] ?? 'Terjadi kesalahan yang tidak diketahui';
          final translatedMessage = message == 'old password is wrong'
              ? 'Password lama anda salah.'
              : message;
          emit(
            UserState(
              isChangePw: false,
              errorChangePw: translatedMessage,
            ),
          );
        } else {
          emit(
            UserState(
              isChangePw: false,
              errorChangePw: response?['message'] ?? 'Terjadi kesalahan yang tidak diketahui',
            ),
          );
        }
      }
    } catch (e) {
      emit(
        UserState(
          isChangePw: false,
          errorChangePw: '$e',
        ),
      );
    }
  }
}
