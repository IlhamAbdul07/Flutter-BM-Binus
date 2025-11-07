class EventTypeModel {
  final String id;
  final String jenisEvent;
  final int priority;

  EventTypeModel({
    required this.id,
    required this.jenisEvent,
    required this.priority,
  });

  // Convert dari JSON
  factory EventTypeModel.fromJson(Map<String, dynamic> json) {
    return EventTypeModel(
      id: json['id'] as String,
      jenisEvent: json['jenisEvent'] as String,
      priority: json['priority'] as int,
    );
  }

  // Convert ke JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'jenisEvent': jenisEvent, 'priority': priority};
  }

  // Copy with method untuk update data
  EventTypeModel copyWith({String? id, String? jenisEvent, int? priority}) {
    return EventTypeModel(
      id: id ?? this.id,
      jenisEvent: jenisEvent ?? this.jenisEvent,
      priority: priority ?? this.priority,
    );
  }

  // Compare untuk sorting berdasarkan priority (descending)
  int compareTo(EventTypeModel other) {
    return other.priority.compareTo(priority); // Descending order
  }
}
