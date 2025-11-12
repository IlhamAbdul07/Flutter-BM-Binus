// import 'package:bm_binus/data/models/event_type_model.dart';

class EventTypeData {
  // static List<EventTypeModel> dummyEventTypes = [
  //   EventTypeModel(id: '1', jenisEvent: 'Seminar Nasional', priority: 100),
  //   EventTypeModel(id: '2', jenisEvent: 'Workshop Teknologi', priority: 90),
  //   EventTypeModel(id: '3', jenisEvent: 'Pelatihan SDM', priority: 80),
  //   EventTypeModel(id: '4', jenisEvent: 'Kompetisi Mahasiswa', priority: 70),
  //   EventTypeModel(id: '5', jenisEvent: 'Webinar Online', priority: 60),
  //   EventTypeModel(id: '6', jenisEvent: 'Gathering Karyawan', priority: 50),
  //   EventTypeModel(
  //     id: '7',
  //     jenisEvent: 'Conference Internasional',
  //     priority: 40,
  //   ),
  //   EventTypeModel(id: '8', jenisEvent: 'Rapat Koordinasi', priority: 30),
  //   EventTypeModel(id: '9', jenisEvent: 'Sosialisasi Program', priority: 20),
  //   EventTypeModel(id: '10', jenisEvent: 'Fun Games', priority: 10),
  // ];

  // // Method untuk mendapatkan semua event types (sudah sorted by priority desc)
  // static List<EventTypeModel> getAllEventTypes() {
  //   // Sort by priority descending (nilai terbesar di awal)
  //   List<EventTypeModel> sorted = List.from(dummyEventTypes);
  //   sorted.sort((a, b) => b.priority.compareTo(a.priority));
  //   return sorted;
  // }

  // // Method untuk mendapatkan event type berdasarkan ID
  // static EventTypeModel? getEventTypeById(String id) {
  //   try {
  //     return dummyEventTypes.firstWhere((eventType) => eventType.id == id);
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // // Method untuk mendapatkan event type berdasarkan priority
  // static EventTypeModel? getEventTypeByPriority(int priority) {
  //   try {
  //     return dummyEventTypes.firstWhere(
  //       (eventType) => eventType.priority == priority,
  //     );
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // // Method untuk cek apakah priority sudah digunakan
  // static bool isPriorityUsed(int priority, {String? excludeId}) {
  //   return dummyEventTypes.any(
  //     (eventType) =>
  //         eventType.priority == priority && eventType.id != excludeId,
  //   );
  // }

  // // Method untuk mendapatkan priority tertinggi
  // static int getHighestPriority() {
  //   if (dummyEventTypes.isEmpty) return 0;
  //   return dummyEventTypes
  //       .map((e) => e.priority)
  //       .reduce((a, b) => a > b ? a : b);
  // }

  // // Method untuk mendapatkan priority terendah
  // static int getLowestPriority() {
  //   if (dummyEventTypes.isEmpty) return 0;
  //   return dummyEventTypes
  //       .map((e) => e.priority)
  //       .reduce((a, b) => a < b ? a : b);
  // }

  // // Method untuk mendapatkan next available priority
  // static int getNextAvailablePriority() {
  //   List<int> usedPriorities = dummyEventTypes.map((e) => e.priority).toList();
  //   usedPriorities.sort();

  //   // Cari gap dalam urutan priority
  //   for (int i = 0; i < usedPriorities.length - 1; i++) {
  //     if (usedPriorities[i + 1] - usedPriorities[i] > 10) {
  //       return usedPriorities[i] + 10;
  //     }
  //   }

  //   // Jika tidak ada gap, tambahkan di akhir
  //   return usedPriorities.isEmpty ? 10 : usedPriorities.last + 10;
  // }
}
