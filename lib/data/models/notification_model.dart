// notification_model.dart

// Enum = tipe-tipe notifikasi yang ada
enum NotificationType {
  info, // Notifikasi informasi biasa
  file, // Notifikasi error (merah)
  comment, // Notifikasi pesan
  event, // Notifikasi event
  edit,
  delete,
}

// Model = struktur data notifikasi
class NotificationModel {
  final String id; // ID unik notifikasi
  final String title; // Judul notifikasi
  final String message; // Isi pesan notifikasi
  final DateTime timestamp; // Waktu notifikasi dibuat
  final bool isRead; // Sudah dibaca atau belum
  final NotificationType type; // Tipe notifikasi (info, success, dll)

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false, // Default: belum dibaca
    this.type = NotificationType.info, // Default: tipe info
  });

  // Method untuk copy model dengan perubahan tertentu
  // Contoh: ubah isRead jadi true tanpa ubah data lain
  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    NotificationType? type,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
    );
  }

  // Method untuk convert dari JSON (kalau nanti fetch dari API)
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      type: NotificationType.values.firstWhere(
        (e) => e.toString() == 'NotificationType.${json['type']}',
        orElse: () => NotificationType.info,
      ),
    );
  }

  // Method untuk convert ke JSON (kalau nanti kirim ke API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'type': type.toString().split('.').last,
    };
  }
}
