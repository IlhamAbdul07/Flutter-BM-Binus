import 'package:bm_binus/core/services/api_service.dart';
import 'package:bm_binus/data/models/comment_model.dart';
import 'package:bm_binus/presentation/bloc/comment/comment_event.dart';
import 'package:bm_binus/presentation/bloc/comment/comment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc() : super(CommentState.initial()) {
    on<LoadCommentEvent>((event, emit) async {
      emit(state.loading());
      try {
        final response = await ApiService.handleComment(method: "GET", commentId: event.requestId);
        if (response != null && response["success"] == true && response["data"] != null) {
          final data = response["data"]["data"];

          if (data == null) {
            emit(state.success([]));
            return;
          }

          final List<CommentModel> comments = (data as List)
              .map((item) => CommentModel(
                    id: item['id'] ?? 0,
                    requestId: item['request_id'] ?? 0,
                    comment: item['comment'] ?? '',
                    edited: item['edited'] as bool,
                    createdById: item['created_by']?['id'] ?? 0,
                    createdByName: item['created_by']?['name'] ?? '',
                    createdAt: DateTime.parse(item['created_at']),
                    updatedAt: DateTime.parse(item['updated_at']),
                  ))
              .toList();

          emit(state.success(comments));
        } else {
          emit(state.error("Gagal memuat data comment"));
        }
      } catch (e) {
        emit(state.error("Terjadi kesalahan: $e"));
      }
    });

    on<CreateCommentRequested>((event, emit) async {
      emit(state.setLoading(true));
      try {
        final response = await ApiService.handleComment(method: 'POST', data: {
          'request_id': event.requestId,
          'comment': event.comment
        });

        if (response != null && response['success'] == true) {
          emit(state.copyWith(
            isSuccessTrx: true,
            errorTrx: null,
            typeTrx: "create",
            isLoading: false
          ));
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
      }
    });

    on<UpdateCommentRequested>((event, emit) async {
      emit(state.setLoading(true));
      try {
        Map<String, dynamic> data = {};
        if (event.comment != null){
          data['comment'] = event.comment;
        }
        final response = await ApiService.handleComment(method: 'PUT', commentId: event.commentId, data: data);

        if (response != null && response['success'] == true) {
          emit(state.copyWith(
            isSuccessTrx: true,
            errorTrx: null,
            typeTrx: "update",
            isLoading: false
          ));
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
      }
    });

    on<DeleteCommentRequested>((event, emit) async {
      emit(state.setLoading(true));
      try {
        final response = await ApiService.handleComment(method: 'DELETE', commentId: event.commentId);

        if (response != null && response['success'] == true) {
          emit(state.copyWith(
            isSuccessTrx: true,
            errorTrx: null,
            typeTrx: "delete",
            isLoading: false
          ));
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
      }
    });

    on<ResetCommentTrx>((event, emit) {
      emit(state.copyWith(
        isSuccessTrx: false,
        errorTrx: null,
        typeTrx: null,
      ));
    });
  }
}
