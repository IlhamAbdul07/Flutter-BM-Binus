class UserModel {
  final String id;
  final String nama;
  final String email;
  final UserRole role;
  final bool isAktif;

  UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.role,
    required this.isAktif,
  });

  // Convert dari JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      nama: json['nama'] as String,
      email: json['email'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
      ),
      isAktif: json['isAktif'] as bool,
    );
  }

  // Convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'role': role.toString().split('.').last,
      'isAktif': isAktif,
    };
  }

  // Copy with method untuk update data
  UserModel copyWith({
    String? id,
    String? nama,
    String? email,
    UserRole? role,
    bool? isAktif,
  }) {
    return UserModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      role: role ?? this.role,
      isAktif: isAktif ?? this.isAktif,
    );
  }

  // Getter untuk status dalam bentuk string
  String get statusText => isAktif ? 'Aktif' : 'Tidak Aktif';

  // Getter untuk role dalam bentuk string yang lebih readable
  String get roleText {
    switch (role) {
      case UserRole.staff:
        return 'Staff';
      case UserRole.bm:
        return 'BM';
      case UserRole.iss:
        return 'ISS';
    }
  }
}

// Enum untuk role user
enum UserRole { staff, bm, iss }
