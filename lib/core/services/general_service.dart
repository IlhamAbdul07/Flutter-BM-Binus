class GeneralService {
  static String buildQueryParams(Map<String, String>? params) {
    if (params == null || params.isEmpty) return '';
    return '?${Uri(queryParameters: params).query}';
  }

  static String justBuildQuery(Map<String, String>? params) {
    if (params == null || params.isEmpty) return '';
    return Uri(queryParameters: params).query;
  }

  static String formatTanggalIndo(String isoString) {
      final d = DateTime.parse(isoString);
      const hari = [
        "Minggu", "Senin", "Selasa", "Rabu", "Kamis", "Jum'at", "Sabtu"
      ];
      const bulan = [
        "Januari", "Februari", "Maret", "April", "Mei", "Juni",
        "Juli", "Agustus", "September", "Oktober", "November", "Desember"
      ];
      final namaHari = hari[d.weekday % 7];
      final namaBulan = bulan[d.month - 1];
      final jam = d.hour.toString().padLeft(2, '0');
      final menit = d.minute.toString().padLeft(2, '0');
      return "$namaHari, ${d.day} $namaBulan ${d.year} $jam:$menit";
    }
}