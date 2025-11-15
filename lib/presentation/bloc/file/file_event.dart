import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

abstract class FileEvent extends Equatable {
  const FileEvent();

  @override
  List<Object> get props => [];
}

class LoadFileEvent extends FileEvent {
  final int requestId;

  const LoadFileEvent(this.requestId);

  @override
  List<Object> get props => [requestId];
}

class CreateFileRequested extends FileEvent {
  final int requestId;
  final List<http.MultipartFile> files;

  const CreateFileRequested(this.requestId, this.files);

  @override
  List<Object> get props => [requestId, files];
}

class UpdateFileRequested extends FileEvent {
  final int fileId;
  final String? name;

  const UpdateFileRequested(this.fileId, this.name);

  @override
  List<Object> get props => [fileId, name!];
}

class DeleteFileRequested extends FileEvent {
  final int fileId;

  const DeleteFileRequested(this.fileId);

  @override
  List<Object> get props => [fileId];
}

class ResetFileTrx extends FileEvent {}