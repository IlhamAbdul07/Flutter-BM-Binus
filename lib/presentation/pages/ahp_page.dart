import 'package:bm_binus/presentation/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';

class AhpPage extends StatelessWidget {
  const AhpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _SectionTitle(isMobile: isMobile),
          const SizedBox(height: 24),
          _SectionWhatIsAHP(isMobile: isMobile),
          const SizedBox(height: 24),
          _SectionHowAHPWorks(isMobile: isMobile),
          const SizedBox(height: 24),
          _SectionCriteriaAndAlternatives(isMobile: isMobile),
          const SizedBox(height: 24),
          _SectionAHPResult(isMobile: isMobile),
          const SizedBox(height: 24),
          _SectionApplyAHP(isMobile: isMobile),
        ],
      ),
    );
  }
}

// --------------------
// SECTION 1: TITLE
// --------------------
class _SectionTitle extends StatelessWidget {
  final bool isMobile;
  const _SectionTitle({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Analytical Hierarchy Process (AHP)",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: isMobile ? 26 : 34,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF133017),
        ),
      ),
    );
  }
}

// --------------------
// SECTION 2: PENJELASAN AHP
// --------------------
class _SectionWhatIsAHP extends StatelessWidget {
  final bool isMobile;
  const _SectionWhatIsAHP({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.account_tree, color: Color(0xFF133017)),
                SizedBox(width: 8),
                Text(
                  "Apa itu AHP?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF133017),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "AHP (Analytical Hierarchy Process) adalah metode pengambilan keputusan "
              "yang digunakan untuk menentukan prioritas dari beberapa alternatif "
              "berdasarkan sejumlah kriteria yang telah ditetapkan. "
              "Dalam sistem Building Management BINUS, AHP digunakan untuk menentukan "
              "urutan prioritas pengajuan event berdasarkan tingkat urgensi, kepentingan, "
              "jumlah peserta, dan kompleksitas persiapan event.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: isMobile ? 14 : 16, height: 1.6),
            ),
            const SizedBox(height: 12),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/ahp_diagram.png',
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// --------------------
// SECTION 3: LANGKAH AHP
// --------------------
class _SectionHowAHPWorks extends StatelessWidget {
  final bool isMobile;
  const _SectionHowAHPWorks({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {
        "icon": Icons.menu,
        "title": "1. Menentukan Kriteria dan Alternatif",
        "desc":
            "Kriteria seperti Urgency, Importance, Participants, dan Complexity ditentukan untuk menilai setiap pengajuan event.",
      },
      {
        "icon": Icons.grid_3x3,
        "title": "2. Membuat Matriks Perbandingan Berpasangan",
        "desc":
            "Setiap kriteria dibandingkan satu sama lain untuk menentukan tingkat kepentingan relatifnya.",
      },
      {
        "icon": Icons.calculate,
        "title": "3. Normalisasi dan Hitung Bobot Prioritas",
        "desc":
            "Setiap nilai matriks dibagi dengan total kolom untuk memperoleh nilai normalisasi, lalu dihitung rata-ratanya untuk mendapatkan bobot prioritas.",
      },
      {
        "icon": Icons.rule,
        "title": "4. Menguji Konsistensi (Consistency Ratio)",
        "desc":
            "CR dihitung untuk memastikan penilaian tidak bersifat acak. Jika CR < 0.1, maka hasil dinilai konsisten.",
      },
      {
        "icon": Icons.check_circle,
        "title": "5. Menghitung Skor Akhir (Global Priority)",
        "desc":
            "Setiap alternatif (Event A, B, C) dikalikan dengan bobot kriteria dan dijumlahkan untuk mendapatkan skor prioritas global.",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Langkah-langkah Perhitungan AHP",
          style: TextStyle(
            fontSize: isMobile ? 18 : 22,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF133017),
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: steps
              .map(
                (step) => Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(step["icon"] as IconData,
                        color: const Color(0xFF133017)),
                    title: Text(
                      step["title"].toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      step["desc"].toString(),
                      style: const TextStyle(height: 1.4),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

// --------------------
// SECTION 3.5: KRITERIA DAN ALTERNATIF
// --------------------
class _SectionCriteriaAndAlternatives extends StatelessWidget {
  final bool isMobile;
  const _SectionCriteriaAndAlternatives({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.tune, color: Color(0xFF133017)),
                SizedBox(width: 8),
                Text(
                  "Kriteria dan Alternatif AHP",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF133017),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Dalam penerapan metode AHP, diperlukan kriteria dan alternatif sebagai dasar penilaian prioritas event. "
              "Kriteria membantu menentukan aspek yang paling berpengaruh terhadap pengambilan keputusan, sedangkan alternatif adalah pilihan event yang dibandingkan berdasarkan kriteria tersebut.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: isMobile ? 14 : 16, height: 1.6),
            ),
            const SizedBox(height: 16),
            const Text(
              "📊 Kriteria yang digunakan:",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF133017)),
            ),
            const SizedBox(height: 8),
            _buildCriteriaList(),
            const SizedBox(height: 16),
            const Text(
              "🎯 Alternatif event yang dinilai (contoh):",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF133017)),
            ),
            const SizedBox(height: 8),
            _buildAlternativesList(),
          ],
        ),
      ),
    );
  }

  static Widget _buildCriteriaList() {
    final criteria = [
      {
        "title": "Urgency (Tingkat Urgensi)",
        "desc":
            "Menilai seberapa mendesak event perlu segera dilaksanakan. Misalnya event yang harus dilakukan segera karena permintaan klien dekat dengan jadwal mulai event. Data untuk perbandingannya diambil dari jarak antara tanggal pembuatan pengajuan event dengan tanggal mulai event. Semakin dekat jaraknya, maka semakin prioritas."
      },
      {
        "title": "Importance (Tingkat Kepentingan)",
        "desc":
            "Mengukur seberapa besar dampak event terhadap tujuan perusahaan. Contohnya event dengan tipe yang memiliki tingkat prioritas tinggi. Data untuk perbandingannya diambil dari event type yang diinputkan ketika pembuatan pengajuan event. Semakin tingkat prioritas event type mendekati 1, maka semakin prioritas."
      },
      {
        "title": "Participants (Jumlah Peserta)",
        "desc":
            "Menilai seberapa banyak peserta yang terlibat. Semakin banyak peserta, semakin besar skala event-nya. Data perbandingannya diambil dari data jumlah partisipan yang diinputkan ketika pembuatan pengajuan event. Semakin banyak partisipan, maka semakin prioritas."
      },
      {
        "title": "Complexity (Tingkat Kompleksitas)",
        "desc":
            "Menilai tingkat kesulitan pelaksanaan, koordinasi, serta kebutuhan sumber daya dan waktu. Data perbandingannya diambil dari data yang diminta ketika user Building Management klik (Priority: ON)."
      },
    ];

    return Column(
      children: criteria
          .map(
            (item) => Card(
              elevation: 1,
              color: Colors.green[50],
              margin: const EdgeInsets.symmetric(vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.label, color: Color(0xFF133017)),
                title: Text(item["title"]!,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(item["desc"]!, textAlign: TextAlign.justify),
              ),
            ),
          )
          .toList(),
    );
  }

  static Widget _buildAlternativesList() {
    final alternatives = [
      {
        "title": "Event A - Meeting Tim BiOn dengan WR CGE",
        "desc":
            "Kegiatan ini dijadwalkan pada 6 Oktober 2025 bertempat di Faculty Lounge Lt. 8 Kampus Anggrek. Berdasarkan isi email, kegiatan ini membutuhkan penataan layout ruang dengan kapasitas 50 peserta, penambahan meja letter U, meja coffee break, meja prasmanan, serta penyediaan kabel extension di setiap meja peserta. Dari sisi penilaian kriteria, event ini memiliki tingkat Urgency tinggi karena pelaksanaan yang dekat dengan tanggal pengajuan, Importance tinggi karena melibatkan pihak manajemen tingkat universitas (WR), Participants menengah (50 peserta), dan Complexity sedang karena memerlukan pengaturan tata ruang dan perlengkapan listrik tambahan."
      },
      {
        "title": "Event B - Book Review oleh LKC Anggrek",
        "desc":
            "Berdasarkan email dari Ajeng Ramadhanty (Support Staff LKC Anggrek), kegiatan Book Review dilaksanakan pada 30 September 2025 pukul 09.30–12.00 di Recreation Room LKC Anggrek. Permintaan mencakup penyediaan Infocus (1 unit), layar (1 unit), dan sound system berupa speaker (2 unit) dan microphone (4 unit), serta bantuan penataan sofa dan meja. Dari sisi penilaian, event ini memiliki tingkat Urgency sedang, Importance menengah (kegiatan akademik internal), Participants relatif sedikit, dan Complexity rendah karena kebutuhan peralatan yang standar."
      },
      {
        "title": "Event C - Movie Freak On Stage “From Comic to Cinema” oleh Binus TV",
        "desc":
            "Kegiatan ini akan diselenggarakan pada 7 Oktober 2025 di Faculty Lounge Lt. 8, dengan jumlah peserta sekitar 100 orang. Berdasarkan email, kebutuhan yang diminta meliputi kursi peserta (100 unit), kursi bar (2 unit), meja tinggi (1 unit), dan flipchart (1 unit). Event ini memiliki tingkat Urgency sedang (tanggal cukup dekat dengan pengajuan), Importance tinggi (acara publik kampus yang melibatkan banyak peserta), Participants besar, dan Complexity tinggi karena melibatkan pengaturan kursi dalam jumlah besar dan kebutuhan peralatan tambahan."
      },
    ];

    return Column(
      children: alternatives
          .map(
            (item) => Card(
              elevation: 1,
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.event, color: Color(0xFF133017)),
                title: Text(item["title"]!,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(item["desc"]!, textAlign: TextAlign.justify),
              ),
            ),
          )
          .toList(),
    );
  }
}

// --------------------
// SECTION 3.6: HASIL PERHITUNGAN AHP
// --------------------
class _SectionAHPResult extends StatelessWidget {
  final bool isMobile;
  const _SectionAHPResult({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final criteria = ["Urgency", "Importance", "Participants", "Complexity"];

    final matrix = [
      [1.0000, 1.6667, 2.5000, 5.0000],
      [0.6000, 1.0000, 1.5000, 3.0000],
      [0.4000, 0.6667, 1.0000, 2.0000],
      [0.2000, 0.3333, 0.5000, 1.0000],
    ];

    final priority = [0.4565, 0.2715, 0.1771, 0.0949];
    final lambdaMax = 4.079;
    final ci = 0.026;
    final cr = 0.029;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.table_chart, color: Color(0xFF133017)),
                SizedBox(width: 8),
                Text(
                  "Hasil Perhitungan dan Pengujian AHP",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF133017),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Berikut merupakan hasil dari proses perbandingan berpasangan antar kriteria, "
              "yang digunakan untuk menentukan bobot prioritas tiap kriteria.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: isMobile ? 14 : 16, height: 1.5),
            ),
            const SizedBox(height: 16),

            Center(
              child: Column(
                children: [
                  const Text(
                    "📊 Matriks Perbandingan Kriteria",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF133017)),
                  ),
                  // 🔹 Matriks Perbandingan Kriteria
                  const SizedBox(height: 8),
                  _buildComparisonTable(criteria, matrix),

                  const SizedBox(height: 16),
                  const Text(
                    "⚖️ Bobot Prioritas (Eigen Vector)",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF133017)),
                  ),
                  const SizedBox(height: 8),
                  _buildPriorityTable(criteria, priority),

                  const SizedBox(height: 16),
                  _buildConsistencyTest(lambdaMax, ci, cr),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------
  // WIDGET: TABEL PERBANDINGAN
  // -------------------------
  static Widget _buildComparisonTable(
      List<String> criteria, List<List<double>> matrix) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.green[50],
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(const Color(0xFF133017)),
          headingTextStyle: const TextStyle(color: Colors.white),
          dataTextStyle: const TextStyle(fontSize: 13),
          columns: [
            const DataColumn(label: Text('Kriteria')),
            ...criteria.map((c) => DataColumn(label: Text(c))),
          ],
          rows: List.generate(
            criteria.length,
            (i) => DataRow(
              cells: [
                DataCell(Text(criteria[i],
                    style: const TextStyle(fontWeight: FontWeight.bold))),
                ...matrix[i].map(
                  (val) => DataCell(Text(val.toStringAsFixed(3))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------
  // WIDGET: TABEL PRIORITAS
  // -------------------------
  static Widget _buildPriorityTable(List<String> criteria, List<double> values) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(Colors.green[100]),
        columns: const [
          DataColumn(label: Text('Kriteria')),
          DataColumn(label: Text('Bobot Prioritas')),
        ],
        rows: List.generate(
          criteria.length,
          (i) => DataRow(
            cells: [
              DataCell(Text(criteria[i])),
              DataCell(Text(values[i].toStringAsFixed(4))),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------
  // WIDGET: PENGUJIAN KONSISTENSI
  // -------------------------
  static Widget _buildConsistencyTest(
      double lambdaMax, double ci, double cr) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cr < 0.1 ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: cr < 0.1 ? Colors.green.shade300 : Colors.red.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "🧮 Pengujian Konsistensi",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF133017)),
          ),
          const SizedBox(height: 8),
          Text("λmax = ${lambdaMax.toStringAsFixed(3)}"),
          Text("CI = ${ci.toStringAsFixed(3)}"),
          Text("CR = ${cr.toStringAsFixed(3)}"),
          const SizedBox(height: 8),
          Text(
            cr < 0.1
                ? "✅ Hasil konsisten (CR < 0.1)"
                : "⚠️ Hasil tidak konsisten (CR ≥ 0.1)",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: cr < 0.1 ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

// --------------------
// SECTION 4: FITUR PENERAPAN AHP DALAM SISTEM
// --------------------
class _SectionApplyAHP extends StatefulWidget {
  final bool isMobile;
  const _SectionApplyAHP({required this.isMobile});

  @override
  State<_SectionApplyAHP> createState() => _SectionApplyAHPState();
}

class _SectionApplyAHPState extends State<_SectionApplyAHP> {
  bool _useAHP = false;
  bool _formSubmitted = false;

  final Map<String, int?> _complexityValues = {
    'Event A': null,
    'Event B': null,
    'Event C': null,
  };

  void _submitForm() {
    final allFilled = _complexityValues.values.every((v) => v != null);
    if (allFilled) {
      setState(() => _formSubmitted = true);
    } else {
      CustomSnackBar.show(
        context, 
        icon: Icons.info, 
        title: "Uncompleted Data", 
        message: 'Mohon isi semua nilai complexity sebelum melanjutkan.', 
        color: Colors.orange
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.auto_graph, color: Color(0xFF133017)),
                SizedBox(width: 8),
                Text(
                  "Penerapan AHP dalam Sistem",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF133017),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Dalam sistem ini, AHP digunakan untuk membantu tim Building Management BINUS "
              "menentukan event mana yang lebih diprioritaskan berdasarkan kriteria yang telah ditentukan. "
              "Ketika fitur ini diaktifkan, sistem akan meminta User Building Management untuk menginputkan kompleksitas pengajuan event, kemudian secara otomatis menghitung bobot dan menghasilkan urutan event berdasarkan nilai prioritas tertinggi.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: widget.isMobile ? 14 : 16, height: 1.5),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text("Aktifkan Perhitungan AHP"),
                Switch(
                  activeColor: const Color(0xFF133017),
                  value: _useAHP,
                  onChanged: (val) {
                    setState(() {
                      _useAHP = val;
                      _formSubmitted = false; // reset form ketika toggle dimatikan
                    });
                  },
                ),
              ],
            ),

            // --- tampilkan form simulasi jika toggle aktif tapi belum submit ---
            if (_useAHP && !_formSubmitted)
              AnimatedOpacity(
                opacity: _useAHP ? 1 : 0,
                duration: const Duration(milliseconds: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    const Text(
                      "Simulasi Pengisian Complexity Event",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF133017),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Table(
                      border: TableBorder.all(color: Colors.grey.shade300),
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(1),
                      },
                      children: [
                        const TableRow(
                          decoration: BoxDecoration(color: Color(0xFF133017)),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Nama Event",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Complexity (1-9)",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ..._complexityValues.keys.map(
                          (event) => TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(event),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: DropdownButton<int>(
                                  value: _complexityValues[event],
                                  isExpanded: true,
                                  hint: const Text("Pilih"),
                                  items: List.generate(
                                    9,
                                    (i) => DropdownMenuItem(
                                      value: i + 1,
                                      child: Text("${i + 1}"),
                                    ),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      _complexityValues[event] = val;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          iconColor: Colors.white,
                          backgroundColor: const Color(0xFF133017),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text("Submit Simulasi", style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ],
                ),
              ),

            // --- tampilkan hasil AHP aktif setelah form submit ---
            if (_useAHP && _formSubmitted)
              AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 400),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: const Text(
                    "✅ AHP aktif! Sistem kini akan mengurutkan event berdasarkan hasil perhitungan prioritas.",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}