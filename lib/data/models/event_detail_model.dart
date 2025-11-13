class EventDetailModel {
  final int id;
  final String eventName;
  final String eventLocation;
  final DateTime eventDateStart;
  final DateTime eventDateEnd;
  final String description;
  final int eventTypeId;
  final String eventTypeName;
  final int statusId;
  final String statusName;
  final int userId;
  final String userName;
  final int countParticipant;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventDetailModel({
    required this.id,
    required this.eventName,
    required this.eventLocation,
    required this.eventDateStart,
    required this.eventDateEnd,
    required this.description,
    required this.eventTypeId,
    required this.eventTypeName,
    required this.statusId,
    required this.statusName,
    required this.userId,
    required this.userName,
    required this.countParticipant,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventDetailModel.fromMap(Map<String, dynamic> map) {
    return EventDetailModel(
      id: map['id'] as int,
      eventName: map['event_name'] as String,
      eventLocation: map['event_location'] as String,
      eventDateStart: DateTime.parse(map['event_date_start']),
      eventDateEnd: DateTime.parse(map['event_date_end']),
      description: map['description'] as String,
      eventTypeId: map['event_type']?['id'] ?? 0,
      eventTypeName: map['event_type']?['name'] ?? '',
      statusId: map['status']?['id'] ?? 0,
      statusName: map['status']?['name'] ?? '',
      userId: map['user']?['id'] ?? 0,
      userName: map['user']?['name'] ?? '',
      countParticipant: map['count_participant'] as int,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event_name': eventName,
      'event_location': eventLocation,
      'event_date_start': eventDateStart.toIso8601String(),
      'event_date_end': eventDateEnd.toIso8601String(),
      'description': description,
      'event_type_id': eventTypeId,
      'event_type_name': eventTypeName,
      'status_id': statusId,
      'status_name': statusName,
      'user_id': userId,
      'user_name': userName,
      'count_participant': countParticipant,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
