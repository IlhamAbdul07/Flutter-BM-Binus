import 'package:flutter/material.dart';

class StatusData {
  final String status;
  final int count;
  final Color color;
  final double percentage;

  StatusData({
    required this.status,
    required this.count,
    required this.color,
    this.percentage = 0.0,
  });

  StatusData copyWith({
    String? status,
    int? count,
    Color? color,
    double? percentage,
  }) {
    return StatusData(
      status: status ?? this.status,
      count: count ?? this.count,
      color: color ?? this.color,
      percentage: percentage ?? this.percentage,
    );
  }
}

class TypeData {
  final String type;
  final int count;
  final double percentage;

  TypeData({required this.type, required this.count, this.percentage = 0.0});

  TypeData copyWith({String? type, int? count, double? percentage}) {
    return TypeData(
      type: type ?? this.type,
      count: count ?? this.count,
      percentage: percentage ?? this.percentage,
    );
  }
}

class EventStatusDashboard {
  final List<StatusData> statusList;
  final int totalEvents;

  EventStatusDashboard({required this.statusList, required this.totalEvents});

  factory EventStatusDashboard.calculate(List<StatusData> data) {
    final total = data.fold<int>(0, (sum, item) => sum + item.count);
    final updatedList = data.map((item) {
      final percentage = total > 0 ? (item.count / total * 100) : 0.0;
      return item.copyWith(percentage: percentage);
    }).toList();

    return EventStatusDashboard(statusList: updatedList, totalEvents: total);
  }
}

class EventTypeDashboard {
  final List<TypeData> typeList;
  final int totalEvents;

  EventTypeDashboard({required this.typeList, required this.totalEvents});

  factory EventTypeDashboard.calculate(List<TypeData> data) {
    final total = data.fold<int>(0, (sum, item) => sum + item.count);
    final updatedList = data.map((item) {
      final percentage = total > 0 ? (item.count / total * 100) : 0.0;
      return item.copyWith(percentage: percentage);
    }).toList();

    // Sort by count descending
    updatedList.sort((a, b) => b.count.compareTo(a.count));

    return EventTypeDashboard(typeList: updatedList, totalEvents: total);
  }
}
