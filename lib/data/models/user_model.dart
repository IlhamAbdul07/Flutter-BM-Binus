class User {
  final int id;
  final String name;
  final String email;
  final int roleId;
  final String roleName;

  User({required this.id, required this.name, required this.email, required this.roleId, required this.roleName});

  factory User.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return User(
      id: data['id'] ?? 0,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      roleId: data['role']?['id'] ?? 0,
      roleName: data['role']?['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role_id': roleId,
      'role_name': roleName,
    };
  }
}
