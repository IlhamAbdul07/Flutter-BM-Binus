// notification_model.dart

// Enum = tipe-tipe notifikasi yang ada
enum NotificationType {
  info, // Notifikasi informasi biasa
  success, // Notifikasi sukses (hijau)
  warning, // Notifikasi peringatan (kuning)
  error, // Notifikasi error (merah)
  message, // Notifikasi pesan
  event, // Notifikasi event
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

// =====================================================
// DUMMY DATA (untuk testing, nanti bisa diganti dari API)
// =====================================================
class NotificationDummyData {
  static List<NotificationModel> getDummyNotifications() {
    return [
      NotificationModel(
        id: '1',
        title: 'Event Baru Ditambahkan',
        message:
            'Event "Workshop Flutter Advanced" telah ditambahkan ke sistem oleh Admin',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
        type: NotificationType.event,
      ),
      NotificationModel(
        id: '2',
        title: 'Pengajuan Disetujui ✅',
        message:
            'Pengajuan event "Seminar AI & Machine Learning" Anda telah disetujui oleh Kepala Departemen',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
        type: NotificationType.success,
      ),
      NotificationModel(
        id: '3',
        title: 'Reminder Meeting',
        message:
            'Jangan lupa hadiri meeting evaluasi event hari ini jam 14.00 di Ruang Rapat A',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: false,
        type: NotificationType.warning,
      ),
      NotificationModel(
        id: '4',
        title: 'Pesan dari Admin',
        message:
            'Harap segera melengkapi data profil Anda untuk kelancaran proses verifikasi',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        type: NotificationType.message,
      ),
      NotificationModel(
        id: '5',
        title: 'Update Sistem',
        message:
            'Sistem akan maintenance pada tanggal 5 November 2025 pukul 00.00 - 03.00 WIB',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
        type: NotificationType.info,
      ),
      NotificationModel(
        id: '6',
        title: 'Pengajuan Ditolak',
        message:
            'Pengajuan event "Workshop React" ditolak. Alasan: Budget tidak mencukupi',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        isRead: true,
        type: NotificationType.error,
      ),
    ];
  }
}
