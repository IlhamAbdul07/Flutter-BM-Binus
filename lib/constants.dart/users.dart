class Users {
  final String email;
  final String password;
  final String role;

  Users({required this.email, required this.password, required this.role});
}

final List<Users> DetailUser = [
  Users(email: 'test@gmail.com', password: 'test123', role: 'staff'),
  Users(email: 'angel@gmail.com', password: 'angel123', role: 'bm'),
  Users(email: 'admin@gmail.com', password: 'admin123', role: 'iss'),
];
