import 'package:bm_binus/core/services/api_service.dart';
import 'package:bm_binus/data/models/file_model.dart';
import 'package:bm_binus/presentation/bloc/file/file_event.dart';
import 'package:bm_binus/presentation/bloc/file/file_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  FileBloc() : super(FileState.initial()) {
    on<LoadFileEvent>((event, emit) async {
      emit(state.loading());
      try {
        final response = await ApiService.handleFile(method: "GET", fileId: event.requestId);
        if (response != null && response["success"] == true && response["data"] != null) {
          final data = response["data"]["data"];

          if (data == null) {
            emit(state.success([]));
            return;
          }

          final List<FileModel> files = (data as List)
              .map((item) => FileModel(
                    id: item['id'] ?? 0,
                    requestId: item['request_id'] ?? 0,
                    fileName: item['file_name'] ?? '',
                    fileContent: item['file']?['content'] ?? '',
                    fileView: item['file']?['view'] ?? '',
                    fileExt: item['file']?['ext'] ?? '',
                    createdAt: DateTime.parse(item['created_at']),
                    updatedAt: DateTime.parse(item['updated_at']),
                  ))
              .toList();

          emit(state.success(files));
        } else {
          emit(state.error("Gagal memuat data file"));
        }
      } catch (e) {
        emit(state.error("Terjadi kesalahan: $e"));
      }
    });

    on<CreateFileRequested>((event, emit) async {
      emit(state.setLoading(true));
      try {
        final response = await ApiService.handleFile(method: 'POST', data: {
          'request_id': event.requestId,
        }, listFile: event.files, contentType: 'multipart/form-data');

        if (response != null && response['success'] == true) {
          emit(state.copyWith(isSuccessTrx: true, errorTrx: null, typeTrx: "create", isLoading: false));
        } else {
          if (response != null && response['data'] != null) {
            final message = response['data']?['message'] ?? 'Terjadi kesalahan yang tidak diketahui';
            final translatedMessage = message.toString().contains('not approved')
                ? 'Format berkas yang diunggah tidak didukung.'
                : message;
            emit(
              state.copyWith(
                isSuccessTrx: false,
                errorTrx: translatedMessage,
                typeTrx: null,
              ),
            );
          } else {
            emit(
              state.copyWith(
                isSuccessTrx: false,
                errorTrx: response?['message'] ?? 'Terjadi kesalahan yang tidak diketahui',
                typeTrx: null,
              ),
            );
          }
        }
      } catch (e) {
        emit(
          state.copyWith(
            isSuccessTrx: false,
            errorTrx: '$e',
            typeTrx: null,
          ),
        );
      } finally {
        emit(state.setLoading(false));
      }
    });

    on<UpdateFileRequested>((event, emit) async {
      emit(state.setLoading(true));
      try {
        Map<String, dynamic> data = {};
        if (event.name != null){
          data['name'] = event.name;
        }
        final response = await ApiService.handleFile(method: 'PUT', fileId: event.fileId, data: data);

        if (response != null && response['success'] == true) {
          emit(state.copyWith(isSuccessTrx: true, errorTrx: null, typeTrx: "update", isLoading: false));
        } else {
          if (response != null && response['data'] != null) {
            final message = response['data']?['message'] ?? 'Terjadi kesalahan yang tidak diketahui';
            final translatedMessage = message.toString().contains('failed rename')
                ? 'Error update file dari google drive'
                : message;
            emit(
              state.copyWith(
                isSuccessTrx: false,
                errorTrx: translatedMessage,
                typeTrx: null,
              ),
            );
          } else {
            emit(
              state.copyWith(
                isSuccessTrx: false,
                errorTrx: response?['message'] ?? 'Terjadi kesalahan yang tidak diketahui',
                typeTrx: null,
              ),
            );
          }
        }
      } catch (e) {
        emit(
          state.copyWith(
            isSuccessTrx: false,
            errorTrx: '$e',
            typeTrx: null,
          ),
        );
      } finally {
        emit(state.setLoading(false));
      }
    });

    on<DeleteFileRequested>((event, emit) async {
      emit(state.setLoading(true));
      try {
        final response = await ApiService.handleFile(method: 'DELETE', fileId: event.fileId);

        if (response != null && response['success'] == true) {
          emit(state.copyWith(isSuccessTrx: true, errorTrx: null, typeTrx: "delete", isLoading: false));
        } else {
          if (response != null && response['data'] != null) {
            final message = response['data']?['message'] ?? 'Terjadi kesalahan yang tidak diketahui';
            emit(
              state.copyWith(
                isSuccessTrx: false,
                errorTrx: message,
                typeTrx: null,
              ),
            );
          } else {
            emit(
              state.copyWith(
                isSuccessTrx: false,
                errorTrx: response?['message'] ?? 'Terjadi kesalahan yang tidak diketahui',
                typeTrx: null,
              ),
            );
          }
        }
      } catch (e) {
        emit(
          state.copyWith(
            isSuccessTrx: false,
            errorTrx: '$e',
            typeTrx: null,
          ),
        );
      } finally {
        emit(state.setLoading(false));
      }
    });

    on<ResetFileTrx>((event, emit) {
      emit(state.copyWith(
        isSuccessTrx: false,
        errorTrx: null,
        typeTrx: null,
        isLoading: false
      ));
    });
  }
}
