import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object> get props => [];
}

class LoadCommentEvent extends CommentEvent {
  final int requestId;

  const LoadCommentEvent(this.requestId);

  @override
  List<Object> get props => [requestId];
}

class CreateCommentRequested extends CommentEvent {
  final int requestId;
  final String comment;

  const CreateCommentRequested(this.requestId, this.comment);

  @override
  List<Object> get props => [requestId, comment];
}

class UpdateCommentRequested extends CommentEvent {
  final int commentId;
  final String? comment;

  const UpdateCommentRequested(this.commentId, this.comment);

  @override
  List<Object> get props => [commentId, comment!];
}

class DeleteCommentRequested extends CommentEvent {
  final int commentId;

  const DeleteCommentRequested(this.commentId);

  @override
  List<Object> get props => [commentId];
}

class ResetCommentTrx extends CommentEvent {}