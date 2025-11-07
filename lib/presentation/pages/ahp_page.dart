import 'package:flutter/material.dart';

class AhpPage extends StatelessWidget {
  const AhpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _SectionTitle(isMobile: isMobile),
          const SizedBox(height: 24),
          _SectionWhatIsAHP(isMobile: isMobile),
          const SizedBox(height: 24),
          _SectionApplyAHP(isMobile: isMobile),
          const SizedBox(height: 24),
          // _SectionEventPriority(isMobile: isMobile),
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
    return Text(
      "Analytical Hierarchy Process (AHP)",
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: isMobile ? 24 : 32,
        fontWeight: FontWeight.bold,
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
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.start,
      children: [
        Text(
          "Apa itu AHP?",
          style: TextStyle(
            fontSize: isMobile ? 18 : 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "AHP (Analytical Hierarchy Process) adalah metode pengambilan keputusan "
          "yang membantu menentukan prioritas dari beberapa pilihan berdasarkan "
          "sejumlah kriteria. Sederhananya, AHP membantu sistem untuk menilai "
          "mana permintaan event yang lebih penting atau mendesak untuk diproses lebih dulu.",
          textAlign: isMobile ? TextAlign.justify : TextAlign.justify,
          style: TextStyle(fontSize: isMobile ? 14 : 16, height: 1.5),
        ),
        Divider(),
      ],
    );
  }
}

// --------------------
// SECTION 3: FITUR PENERAPAN AHP
// --------------------
class _SectionApplyAHP extends StatefulWidget {
  final bool isMobile;
  const _SectionApplyAHP({required this.isMobile});

  @override
  State<_SectionApplyAHP> createState() => _SectionApplyAHPState();
}

class _SectionApplyAHPState extends State<_SectionApplyAHP> {
  bool _useAHP = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: widget.isMobile
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.start,
      children: [
        Text(
          "Penerapan AHP dalam Sistem",
          style: TextStyle(
            fontSize: widget.isMobile ? 18 : 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Fitur ini memungkinkan sistem untuk secara otomatis "
          "menentukan urutan prioritas event yang diajukan oleh pengguna. "
          "Ketika switch diaktifkan, data event akan diurutkan menggunakan algoritma AHP "
          "berdasarkan tingkat kepentingan setiap kriteria yang telah ditetapkan.",
          textAlign: widget.isMobile ? TextAlign.justify : TextAlign.start,
          style: TextStyle(fontSize: widget.isMobile ? 14 : 16, height: 1.5),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: widget.isMobile
              ? MainAxisAlignment.start
              : MainAxisAlignment.start,
          children: [
            const Text("Gunakan AHP"),
            Switch(
              value: _useAHP,
              onChanged: (val) {
                setState(() {
                  _useAHP = val;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        // TODO: Tambahkan gambar atau ilustrasi di sini
        // Contoh:
        // Image.asset('assets/images/ahp_diagram.png'),
        Divider(),
      ],
    );
  }
}

// --------------------
// SECTION 4: PENJELASAN PRIORITY EVENT TYPE
// --------------------
// class _SectionEventPriority extends StatelessWidget {
//   final bool isMobile;
//   const _SectionEventPriority({required this.isMobile});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: isMobile
//           ? CrossAxisAlignment.start
//           : CrossAxisAlignment.center,
//       children: [
//         Text(
//           "Priority dalam Event Type",
//           style: TextStyle(
//             fontSize: isMobile ? 18 : 22,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           "Setiap event memiliki tipe tertentu, misalnya seminar, pameran, "
//           "atau kegiatan internal kampus. Dalam sistem ini, setiap event type "
//           "dapat diberikan tingkat prioritas yang berbeda. Nilai prioritas inilah "
//           "yang akan digunakan oleh algoritma AHP untuk menilai seberapa penting "
//           "event tersebut dibandingkan yang lain.",
//           textAlign: isMobile ? TextAlign.justify : TextAlign.center,
//           style: TextStyle(fontSize: isMobile ? 14 : 16, height: 1.5),
//         ),
//       ],
//     );
//   }
// }