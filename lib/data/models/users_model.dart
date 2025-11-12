class Users {
  final int id;
  final String name;
  final String email;
  final int roleId;
  final String roleName;
  final DateTime createdAt;

  Users({
    required this.id,
    required this.name,
    required this.email,
    required this.roleId,
    required this.roleName,
    required this.createdAt,
  });

  // Convert dari JSON
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      roleId: json['role']?['id'] ?? 0,
      roleName: json['role']?['name'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role_id': roleId,
      'role_name': roleName,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
