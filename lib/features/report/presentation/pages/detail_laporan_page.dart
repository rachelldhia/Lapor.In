import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:laporin/theme.dart';

class DetailLaporanPage extends StatefulWidget {
  final Map<String, dynamic> report;

  const DetailLaporanPage({super.key, required this.report});

  @override
  State<DetailLaporanPage> createState() => _DetailLaporanPageState();
}

class _DetailLaporanPageState extends State<DetailLaporanPage> {
  bool _isAccidentExpanded = false;
  bool _isBystanderExpanded = false;
  bool _isPlayingAudio = false;

  @override
  Widget build(BuildContext context) {
    final statusColor = widget.report["color"] ?? Colors.amber;
    final statusText = widget.report["status"] ?? "Menunggu";

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Detail Laporan",
          style: AppTextStyles.heading1.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.gradientColors,
            stops: AppColors.gradientStops,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                // Premium Detailed Card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBEAEA), // Light red-pink theme matching report screen cards
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Title & Status Pill
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.report["title"],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: statusColor.withValues(alpha: 0.5)),
                            ),
                            child: Text(
                              statusText,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Meta Info: Location & Time
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              widget.report["location"],
                              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded, size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            widget.report["date"] ?? "Baru saja",
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(height: 1, color: Colors.black12),
                      const SizedBox(height: 20),

                      // Description
                      const Text(
                        "Deskripsi Kejadian",
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.report["description"] ??
                            "Laporan kecelakaan lalu lintas tabrakan beruntun di depan jalan Sudirman yang membutuhkan bantuan darurat segera di tempat kejadian perkara.",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade800,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Attachments Placeholder
                      const Text(
                        "Foto / Video Bukti",
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _buildAttachmentBox(context, Icons.image_rounded, "Foto_Kejadian_1.png"),
                          const SizedBox(width: 12),
                          _buildAttachmentBox(context, Icons.video_collection_rounded, "Video_Kejadian.mp4"),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Audio Card
                      const Text(
                        "Rekaman Suara",
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildAudioPlayerCard(),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Tips Section Accordion
                const Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 12),
                  child: Text(
                    "Tips yang Mungkin Membantu",
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                _buildAccordionCard(
                  title: "Jika Anda Mengalami Kecelakaan",
                  icon: Icons.personal_injury_rounded,
                  isExpanded: _isAccidentExpanded,
                  onToggle: () {
                    setState(() {
                      _isAccidentExpanded = !_isAccidentExpanded;
                    });
                  },
                  tips: const [
                    "Tetap Tenang & Periksa Cedera – Evaluasi kondisi fisik Anda dan penumpang.",
                    "Pindah ke Tempat Aman (Jika Memungkinkan) – Jika mobil dapat dikendarai, tepikan ke sisi jalan.",
                    "Hubungi Layanan Darurat – Hubungi 112 untuk bantuan ambulans dan polisi.",
                    "Jangan Tinggalkan TKP – Tetap berada di lokasi hingga petugas resmi datang.",
                    "Tukar Informasi Kontak – Bertukar data asuransi dengan pengendara lain.",
                    "Dokumentasikan TKP – Ambil foto/video kerusakan mobil dan detail lingkungan sekitar.",
                    "Hindari Perdebatan – Jangan mengaku salah atau berdebat di tempat kejadian.",
                  ],
                ),
                const SizedBox(height: 12),
                _buildAccordionCard(
                  title: "Jika Anda Adalah Saksi Mata",
                  icon: Icons.visibility_rounded,
                  isExpanded: _isBystanderExpanded,
                  onToggle: () {
                    setState(() {
                      _isBystanderExpanded = !_isBystanderExpanded;
                    });
                  },
                  tips: const [
                    "Pastikan Keselamatan Anda Terlebih Dahulu – Jangan masuk ke lalu lintas yang berbahaya.",
                    "Hubungi Layanan Darurat Segera – Berikan info detail lokasi dan jumlah kendaraan/korban.",
                    "Berikan Bantuan Secara Cermat – Jika Anda memiliki sertifikat P3K, tolonglah dengan hati-hati.",
                    "Jangan Pindahkan Korban Cedera – Memindahkan korban dapat memperparah kondisinya.",
                    "Bantu Arahkan Lalu Lintas – Beri tanda lampu bahaya kepada pengendara lain.",
                    "Berikan Laporan Akurat kepada Petugas – Beritahu saksi kejadian secara jujur.",
                    "Jangan Mengganggu Operasi Penyelamatan – Biarkan tim pemadam dan medis melakukan pekerjaannya.",
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentBox(BuildContext context, IconData icon, String filename) {
    return Expanded(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFCC2D30), size: 26),
            const SizedBox(height: 6),
            Text(
              filename,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioPlayerCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _isPlayingAudio ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
              color: const Color(0xFFCC2D30),
              size: 36,
            ),
            onPressed: () {
              setState(() {
                _isPlayingAudio = !_isPlayingAudio;
              });
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "rekaman_kejadian.wav",
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                // Simulated slider indicator line
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: _isPlayingAudio ? 0.35 : 0.0,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFCC2D30)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isPlayingAudio ? "0:12" : "0:00",
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccordionCard({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onToggle,
    required List<String> tips,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCC2D30).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: const Color(0xFFCC2D30), size: 20),
                ),
                title: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                trailing: Icon(
                  isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey,
                ),
                onTap: onToggle,
              ),
              if (isExpanded) ...[
                const Divider(height: 1, color: Colors.black12),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: tips.map((tip) {
                      final parts = tip.split(" – ");
                      final titleText = parts[0];
                      final descText = parts.length > 1 ? parts[1] : "";

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFFCC2D30),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: "$titleText ",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.black87,
                                    height: 1.35,
                                  ),
                                  children: [
                                    if (descText.isNotEmpty)
                                      TextSpan(
                                        text: "– $descText",
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 11.5,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
