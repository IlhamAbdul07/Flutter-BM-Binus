class KomentarModel {
  final int id;
  final String nama;
  final String role;
  final String komentar;
  final DateTime tanggal;

  const KomentarModel({
    required this.id,
    required this.nama,
    required this.role,
    required this.komentar,
    required this.tanggal,
  });

  factory KomentarModel.fromMap(Map<String, dynamic> map) {
    return KomentarModel(
      id: map['id'] as int,
      nama: map['nama'] as String,
      role: map['role'] as String,
      komentar: map['komentar'] as String,
      tanggal: map['tanggal'] as DateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'role': role,
      'komentar': komentar,
      'tanggal': tanggal,
    };
  }
}
