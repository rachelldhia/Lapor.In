import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:laporin/theme.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Notifikasi",
          style: AppTextStyles.heading1.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
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
          child: Column(
            children: [
              const SizedBox(height: 8),
              // Premium styled Tab Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: const Color(0xFFCC2D30),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFCC2D30).withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey.shade700,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
                    tabs: const [
                      Tab(text: "Peringatan Daerah"),
                      Tab(text: "Aktivitas Laporan"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Tab View
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLocalAlertsTab(),
                    _buildReportActivityTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocalAlertsTab() {
    final List<Map<String, dynamic>> alerts = [
      {
        "type": "Kecelakaan",
        "title": "Kecelakaan Beruntun 3 Kendaraan",
        "description": "Terjadi tabrakan beruntun di lajur kanan Tol Dalam Kota (arah Semanggi). Kemacetan parah terjadi sepanjang 2 km. Harap gunakan jalur alternatif.",
        "location": "Jl. Jend. Sudirman (200m dari lokasi Anda)",
        "time": "15 menit lalu",
        "icon": Icons.car_crash_rounded,
        "color": const Color(0xFFFFB020),
        "bg": const Color(0xFFFFF7E6),
      },
      {
        "type": "Kriminal",
        "title": "Laporan Pencurian Motor",
        "description": "Dilaporkan adanya pencurian sepeda motor matik merah di area parkir ruko dekat stasiun MRT. Waspada untuk seluruh pengendara di sekitar area ini dan pastikan kunci ganda.",
        "location": "Mega Kuningan (500m dari lokasi Anda)",
        "time": "1 jam lalu",
        "icon": Icons.shield_rounded,
        "color": const Color(0xFFD14343),
        "bg": const Color(0xFFFEECEB),
      },
      {
        "type": "Bencana",
        "title": "Pohon Tumbang Menghalangi Jalan",
        "description": "Sebuah pohon besar tumbang akibat angin kencang dan menutup setengah badan jalan utama. Petugas damkar sedang melakukan evakuasi. Arus lalin tersendat.",
        "location": "Jl. Gatot Subroto (1.2km dari lokasi Anda)",
        "time": "2 jam lalu",
        "icon": Icons.warning_amber_rounded,
        "color": const Color(0xFFFFB020),
        "bg": const Color(0xFFFFF7E6),
      },
      {
        "type": "Kriminal",
        "title": "Aksi Penjambretan Ponsel",
        "description": "Hati-hati bagi pejalan kaki di trotoar Sudirman. Dilaporkan pelaku menggunakan motor tanpa plat nomor menargetkan ponsel pejalan kaki yang lengah.",
        "location": "Karet Semanggi (800m dari lokasi Anda)",
        "time": "3 jam lalu",
        "icon": Icons.gavel_rounded,
        "color": const Color(0xFFD14343),
        "bg": const Color(0xFFFEECEB),
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemCount: alerts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return _buildAlertCard(alert);
      },
    );
  }

  Widget _buildReportActivityTab() {
    final List<Map<String, dynamic>> activities = [
      {
        "status": "Selesai",
        "title": "Laporan Jalan Berlubang Selesai",
        "description": "Laporan Anda mengenai jalan berlubang parah di Jl. Jend. Sudirman No. 12 telah selesai diperbaiki oleh Dinas Bina Marga DKI Jakarta. Terima kasih atas laporan Anda!",
        "reportId": "LPR-2026-9081",
        "time": "30 menit lalu",
        "icon": Icons.check_circle_rounded,
        "color": const Color(0xFF14B8A6),
        "bg": const Color(0xFFF0FDFB),
      },
      {
        "status": "Diproses",
        "title": "Laporan Lampu Jalan Mati Diproses",
        "description": "Laporan Anda tentang lampu jalan mati di area Sudirman sedang diproses oleh Dinas Perhubungan dan petugas lapangan telah dikirim ke lokasi.",
        "reportId": "LPR-2026-8721",
        "time": "2 jam lalu",
        "icon": Icons.pending_rounded,
        "color": const Color(0xFF3B82F6),
        "bg": const Color(0xFFEFF6FF),
      },
      {
        "status": "Terkirim",
        "title": "Laporan Baru Berhasil Diajukan",
        "description": "Laporan kecelakaan lalu lintas Anda berhasil terkirim dan masuk antrean sistem. Tim verifikator sedang memeriksa laporan Anda.",
        "reportId": "LPR-2026-9122",
        "time": "4 jam lalu",
        "icon": Icons.send_rounded,
        "color": const Color(0xFF6B7280),
        "bg": const Color(0xFFF9FAFB),
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemCount: activities.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final act = activities[index];
        return _buildActivityCard(act);
      },
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: alert["bg"],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(alert["icon"], color: alert["color"], size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert["type"],
                        style: TextStyle(
                          color: alert["color"],
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        alert["time"],
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                alert["title"],
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                alert["description"],
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: Colors.black12),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Colors.grey, size: 14),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      alert["location"],
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> act) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: act["bg"],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(act["icon"], color: act["color"], size: 20),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            act["reportId"],
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            act["time"],
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: act["bg"],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: act["color"].withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      act["status"],
                      style: TextStyle(
                        color: act["color"],
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                act["title"],
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                act["description"],
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
