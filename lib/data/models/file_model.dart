class FileModel {
  final int id;
  final int requestId;
  final String fileName;
  final String fileContent;
  final String fileView;
  final String fileExt;
  final DateTime createdAt;
  final DateTime updatedAt;

  FileModel({
    required this.id,
    required this.requestId,
    required this.fileName,
    required this.fileContent,
    required this.fileView,
    required this.fileExt,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert dari JSON
  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['id'] ?? 0,
      requestId: json['request_id'] ?? 0,
      fileName: json['file_name'] ?? '',
      fileContent: json['file']?['content'] ?? '',
      fileView: json['file']?['view'] ?? '',
      fileExt: json['file']?['ext'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request_id': requestId,
      'file_name': fileName,
      'file_content': fileContent,
      'file_view': fileView,
      'file_ext': fileExt,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
