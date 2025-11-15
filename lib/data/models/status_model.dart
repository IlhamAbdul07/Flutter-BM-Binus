class Status {
  final int id;
  final String name;

  Status({
    required this.id,
    required this.name,
  });

  // Convert dari JSON
  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  // Convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
