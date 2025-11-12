class EventType {
  final int id;
  final String name;
  final int priority;

  EventType({
    required this.id,
    required this.name,
    required this.priority,
  });

  // Convert dari JSON
  factory EventType.fromJson(Map<String, dynamic> json) {
    return EventType(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      priority: json['priority'] ?? 0,
    );
  }

  // Convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'priority': priority,
    };
  }
}
