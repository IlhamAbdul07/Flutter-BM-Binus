import 'package:bm_binus/data/models/file_model.dart';
import 'package:equatable/equatable.dart';

class FileState extends Equatable {
  final List<FileModel> files;
  final bool isLoading;
  final String? errorFetch; 
  final bool isSuccessTrx;
  final String? errorTrx;
  final String? typeTrx;

  const FileState({
    this.files = const [],
    this.isLoading = false,
    this.errorFetch,
    required this.isSuccessTrx,
    this.errorTrx,
    this.typeTrx,
  });

  factory FileState.initial() {
    return const FileState(
      files: [],
      isLoading: false,
      errorFetch: null,
      isSuccessTrx: false,
      errorTrx: null,
      typeTrx: null,
    );
  }

  FileState loading() {
    return copyWith(isLoading: true, errorFetch: null);
  }

  FileState success(List<FileModel> files) {
    return copyWith(
      files: files,
      isLoading: false,
      errorFetch: null,
    );
  }

  FileState error(String message) {
    return copyWith(isLoading: false, errorFetch: message);
  }

  FileState setLoading(bool loading) {
    return copyWith(isLoading: loading);
  }

  FileState copyWith({
    List<FileModel>? files,
    bool? isLoading,
    String? errorFetch,
    bool? isSuccessTrx,
    String? errorTrx,
    String? typeTrx,
  }) {
    return FileState(
      files: files ?? this.files,
      isLoading: isLoading ?? this.isLoading,
      errorFetch: errorFetch ?? this.errorFetch,
      isSuccessTrx: isSuccessTrx ?? this.isSuccessTrx,
      errorTrx: errorTrx ?? this.errorTrx,
      typeTrx: typeTrx ?? this.typeTrx,
    );
  }

  @override
  List<Object?> get props => [files, isLoading, errorFetch, isSuccessTrx, errorTrx, typeTrx];
}
