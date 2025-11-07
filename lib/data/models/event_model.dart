class EventModel {
  final int no;
  final String staff;
  final String event;
  final String lokasi;
  final DateTime tglMulai;
  final DateTime tglSelesai;
  final String eventTipe;
  final DateTime tglDibuat;
  final String status;

  EventModel({
    required this.no,
    required this.staff,
    required this.event,
    required this.lokasi,
    required this.tglMulai,
    required this.tglSelesai,
    required this.eventTipe,
    required this.tglDibuat,
    required this.status,
  });

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      no: map['no'] as int,
      staff: map['staff'] as String,
      event: map['event'] as String,
      lokasi: map['lokasi'] as String,
      tglMulai: map['tglMulai'] as DateTime,
      tglSelesai: map['tglSelesai'] as DateTime,
      eventTipe: map['eventTipe'] as String,
      tglDibuat: map['tglDibuat'] as DateTime,
      status: map['status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'no': no,
      'staff': staff,
      'event': event,
      'lokasi': lokasi,
      'tglMulai': tglMulai,
      'tglSelesai': tglSelesai,
      'eventTipe': eventTipe,
      'tglDibuat': tglDibuat,
      'status': status,
    };
  }

  EventModel copyWith({
    int? no,
    String? staff,
    String? event,
    String? lokasi,
    DateTime? tglMulai,
    DateTime? tglSelesai,
    String? eventTipe,
    DateTime? tglDibuat,
    String? status,
  }) {
    return EventModel(
      no: no ?? this.no,
      staff: staff ?? this.staff,
      event: event ?? this.event,
      lokasi: lokasi ?? this.lokasi,
      tglMulai: tglMulai ?? this.tglMulai,
      tglSelesai: tglSelesai ?? this.tglSelesai,
      eventTipe: eventTipe ?? this.eventTipe,
      tglDibuat: tglDibuat ?? this.tglDibuat,
      status: status ?? this.status,
    );
  }

  List<Object?> get props => [
    no,
    staff,
    event,
    lokasi,
    tglMulai,
    tglSelesai,
    eventTipe,
    tglDibuat,
    status,
  ];

  void operator [](String other) {}
}
