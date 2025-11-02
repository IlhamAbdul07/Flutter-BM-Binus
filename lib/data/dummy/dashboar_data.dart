import 'package:bm_binus/data/models/event_dashboard_model.dart';
import 'package:flutter/material.dart';

class DashboardData {
  static EventStatusDashboard getStatusData() {
    final rawData = [
      StatusData(status: "Pengajuan", count: 45, color: Colors.orange),
      StatusData(status: "Proses", count: 30, color: Colors.blue),
      StatusData(status: "Validasi", count: 25, color: Colors.purple),
      StatusData(status: "Finalisasi", count: 15, color: Colors.teal),
      StatusData(status: "Selesai", count: 85, color: Colors.green),
    ];

    return EventStatusDashboard.calculate(rawData);
  }

  static EventTypeDashboard getTypeData() {
    final rawData = [
      TypeData(type: "Seminar", count: 50),
      TypeData(type: "Workshop", count: 40),
      TypeData(type: "Webinar", count: 35),
      TypeData(type: "Pelatihan", count: 30),
      TypeData(type: "Konferensi", count: 25),
      TypeData(type: "Lomba", count: 20),
    ];

    return EventTypeDashboard.calculate(rawData);
  }
}
