import 'package:bm_binus/data/models/comment_model.dart';
import 'package:equatable/equatable.dart';

class CommentState extends Equatable {
  final List<CommentModel> comments;
  final bool isLoading;
  final String? errorFetch; 
  final bool isSuccessTrx;
  final String? errorTrx;
  final String? typeTrx;

  const CommentState({
    this.comments = const [],
    this.isLoading = false,
    this.errorFetch,
    required this.isSuccessTrx,
    this.errorTrx,
    this.typeTrx,
  });

  factory CommentState.initial() {
    return const CommentState(
      comments: [],
      isLoading: false,
      errorFetch: null,
      isSuccessTrx: false,
      errorTrx: null,
      typeTrx: null,
    );
  }

  CommentState loading() {
    return copyWith(isLoading: true, errorFetch: null);
  }

  CommentState success(List<CommentModel> comments) {
    return copyWith(
      comments: comments,
      isLoading: false,
      errorFetch: null,
    );
  }

  CommentState error(String message) {
    return copyWith(isLoading: false, errorFetch: message);
  }

  CommentState setLoading(bool loading) {
    return copyWith(isLoading: loading);
  }

  CommentState copyWith({
    List<CommentModel>? comments,
    bool? isLoading,
    String? errorFetch,
    bool? isSuccessTrx,
    String? errorTrx,
    String? typeTrx,
  }) {
    return CommentState(
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      errorFetch: errorFetch ?? this.errorFetch,
      isSuccessTrx: isSuccessTrx ?? this.isSuccessTrx,
      errorTrx: errorTrx ?? this.errorTrx,
      typeTrx: typeTrx ?? this.typeTrx,
    );
  }

  @override
  List<Object?> get props => [comments, isLoading, errorFetch, isSuccessTrx, errorTrx, typeTrx];
}
