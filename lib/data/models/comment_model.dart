class CommentModel {
  final int id;
  final int requestId;
  final String comment;
  final bool edited;
  final int createdById;
  final String createdByName;
  final DateTime createdAt;
  final DateTime updatedAt;

  CommentModel({
    required this.id,
    required this.requestId,
    required this.comment,
    required this.edited,
    required this.createdById,
    required this.createdByName,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert dari JSON
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? 0,
      requestId: json['request_id'] ?? 0,
      comment: json['comment'] ?? '',
      edited: json['edited'] as bool,
      createdById: json['created_by']?['id'] ?? 0,
      createdByName: json['created_by']?['name'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request_id': requestId,
      'comment': comment,
      'edited': edited,
      'created_by_id': createdById,
      'created_by_name': createdByName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
