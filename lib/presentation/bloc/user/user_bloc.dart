import 'package:bm_binus/core/services/api_service.dart';
import 'package:bm_binus/data/models/users_model.dart';
import 'package:bm_binus/presentation/bloc/user/user_event.dart';
import 'package:bm_binus/presentation/bloc/user/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UsersState> {
  UserBloc() : super(UsersState.initial()) {
    on<LoadUsersEvent>((event, emit) async {
      emit(state.loading());
      try {
        final response = await ApiService.handleUser(method: "GET", params: {
          "no_paging": "yes",
          "order": "created_at",
          "order_by": "asc"
        });
        if (response != null && response["success"] == true && response["data"] != null) {
          final data = response["data"]["data"];

          if (data == null) {
            emit(state.success([]));
            return;
          }

          final List<Users> users = (data as List)
              .map((item) => Users(
                    id: item["id"] ?? 0,
                    name: item["name"] ?? "",
                    email: item["email"] ?? "",
                    createdAt: DateTime.parse(item["created_at"]),
                    roleId: item["role"]?["id"] ?? 0,
                    roleName: item["role"]?["name"] ?? "",
                  ))
              .toList();

          emit(state.success(users));
        } else {
          emit(state.error("Gagal memuat data user"));
        }
      } catch (e) {
        emit(state.error("Terjadi kesalahan: $e"));
      }
    });

    on<CreateUserRequested>((event, emit) async {
      try {
        final response = await ApiService.handleUser(method: 'POST', data: {
          'name': event.name,
          'email': event.email,
          'role_id': event.roleId,
        });

        if (response != null && response['success'] == true) {
          emit(UsersState(isChangePw: false, isSuccessTrx: true, errorTrx: null, typeTrx: "create"));
        } else {
          if (response != null && response['data'] != null) {
            final message = response['data']?['message'] ?? 'Terjadi kesalahan yang tidak diketahui';
            final translatedMessage = message == 'email already exist'
                ? 'Email sudah digunakan user lain.'
                : message;
            emit(
              UsersState(
                isChangePw: false,
                isSuccessTrx: false,
                errorTrx: translatedMessage,
                typeTrx: null,
              ),
            );
          } else {
            emit(
              UsersState(
                isChangePw: false,
                isSuccessTrx: false,
                errorTrx: response?['message'] ?? 'Terjadi kesalahan yang tidak diketahui',
                typeTrx: null,
              ),
            );
          }
        }
      } catch (e) {
        emit(
          UsersState(
            isChangePw: false,
            isSuccessTrx: false,
            errorTrx: '$e',
            typeTrx: null,
          ),
        );
      }
    });

    on<UpdateUserRequested>((event, emit) async {
      try {
        Map<String, dynamic> data = {};
        if (event.name != null){
          data['name'] = event.name;
        }
        if (event.email != null){
          data['email'] = event.email;
        }
        if (event.roleId != null){
          data['role_id'] = event.roleId;
        }
        final response = await ApiService.handleUser(method: 'PUT', userId: event.userId, data: data);

        if (response != null && response['success'] == true) {
          emit(UsersState(isChangePw: false, isSuccessTrx: true, errorTrx: null, typeTrx: "update"));
        } else {
          if (response != null && response['data'] != null) {
            final message = response['data']?['message'] ?? 'Terjadi kesalahan yang tidak diketahui';
            emit(
              UsersState(
                isChangePw: false,
                isSuccessTrx: false,
                errorTrx: message,
                typeTrx: null,
              ),
            );
          } else {
            emit(
              UsersState(
                isChangePw: false,
                isSuccessTrx: false,
                errorTrx: response?['message'] ?? 'Terjadi kesalahan yang tidak diketahui',
                typeTrx: null,
              ),
            );
          }
        }
      } catch (e) {
        emit(
          UsersState(
            isChangePw: false,
            isSuccessTrx: false,
            errorTrx: '$e',
            typeTrx: null,
          ),
        );
      }
    });

    on<DeleteUserRequested>((event, emit) async {
      try {
        final response = await ApiService.handleUser(method: 'DELETE', userId: event.userId);

        if (response != null && response['success'] == true) {
          emit(UsersState(isChangePw: false, isSuccessTrx: true, errorTrx: null, typeTrx: "delete"));
        } else {
          if (response != null && response['data'] != null) {
            final message = response['data']?['message'] ?? 'Terjadi kesalahan yang tidak diketahui';
            emit(
              UsersState(
                isChangePw: false,
                isSuccessTrx: false,
                errorTrx: message,
                typeTrx: null,
              ),
            );
          } else {
            emit(
              UsersState(
                isChangePw: false,
                isSuccessTrx: false,
                errorTrx: response?['message'] ?? 'Terjadi kesalahan yang tidak diketahui',
                typeTrx: null,
              ),
            );
          }
        }
      } catch (e) {
        emit(
          UsersState(
            isChangePw: false,
            isSuccessTrx: false,
            errorTrx: '$e',
            typeTrx: null,
          ),
        );
      }
    });

    on<DownloadUsersEvent>((event, emit) async {
      try {
        final response = await ApiService.exportUsers();
        if (response.statusCode == 200) {
          await ApiService.downloadFileFromResponse(response);
        } else {
          emit(state.error("Gagal download data user"));
        }
      } catch (e) {
        emit(state.error("Terjadi kesalahan: $e"));
      }
    });
    
    on<ChangePasswordUserRequested>((event, emit) async {
      try {
        final response = await ApiService.handleUser(method: 'PATCH', userId: event.userId, data: {
          'old_password': event.oldPassword,
          'new_password': event.newPassword,
        });

        if (response != null && response['success'] == true) {
          emit(UsersState(isChangePw: true, errorChangePw: null, isSuccessTrx: false));
        } else {
          if (response != null && response['data'] != null) {
            final message = response['data']?['message'] ?? 'Terjadi kesalahan yang tidak diketahui';
            final translatedMessage = message == 'old password is wrong'
                ? 'Password lama anda salah.'
                : message;
            emit(
              UsersState(
                isChangePw: false,
                errorChangePw: translatedMessage,
                isSuccessTrx: false
              ),
            );
          } else {
            emit(
              UsersState(
                isChangePw: false,
                errorChangePw: response?['message'] ?? 'Terjadi kesalahan yang tidak diketahui',
                isSuccessTrx: false
              ),
            );
          }
        }
      } catch (e) {
        emit(
          UsersState(
            isChangePw: false,
            errorChangePw: '$e',
            isSuccessTrx: false
          ),
        );
      }
    });
  }
}
