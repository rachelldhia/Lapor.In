import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laporin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:laporin/features/auth/presentation/bloc/auth_state.dart';
import 'package:laporin/features/report/presentation/bloc/report_bloc.dart';
import 'package:laporin/features/report/presentation/bloc/report_state.dart';
import 'package:laporin/features/report/presentation/pages/report_page.dart';
import 'package:laporin/features/report/presentation/pages/history_page.dart';
import 'package:laporin/features/report/presentation/pages/detail_laporan_page.dart';
import 'package:laporin/features/home/presentation/pages/sos_page.dart';
import 'package:laporin/features/home/presentation/pages/emergency_contacts_page.dart';
import 'package:laporin/features/home/presentation/pages/notifications_page.dart';
import 'map_page.dart';
import 'package:laporin/theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
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
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
            children: [
              // 1. Map Image Background (scrolls with content)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapPage()),
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: Image.asset(
                  'assets/images/map_placeholder.png',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),

            // 2. Curve Overlay from Assets (scrolls with content)
            IgnorePointer(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: Image.asset(
                  'assets/images/lengkungan.png',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),

            // 3. Scrollable Content Layer + Profile Header
            SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Info Header inside SafeArea (so it sitting below system status bar)
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, authState) {
                          String name = "Eve";
                          String? avatarPath;

                          if (authState is AuthAuthenticated) {
                            name = authState.user.name;
                            avatarPath = authState.user.avatarPath;
                          }

                          return Row(
                            children: [
                              // Profile Picture with white border outline
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundImage: (avatarPath != null &&
                                          avatarPath.isNotEmpty &&
                                          !avatarPath.startsWith('http'))
                                      ? FileImage(File(avatarPath))
                                      : NetworkImage(avatarPath ??
                                              'https://i.pravatar.cc/150?u=eve')
                                          as ImageProvider,
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Greeting text
                              RichText(
                                text: TextSpan(
                                  text: "Hello, ",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF680002),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: name,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF680002),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              // Notification Icon with badge '3'
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const NotificationsPage()),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.3),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.notifications_none_rounded,
                                        color: Color(0xFF680002),
                                        size: 26,
                                      ),
                                    ),
                                    Positioned(
                                      right: 2,
                                      top: 2,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Text(
                                          "3",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  // Spacer to push the scrollable body content below the map's curved bottom edge
                  SizedBox(height: screenSize.height * 0.35),

                  // Padding for the rest of the body content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SOS Emergency Call Card
                        _buildSOSCard(context),

                        const SizedBox(height: 24),

                        // Aksi Cepat (Quick Actions) Section
                        _buildQuickActionsHeader(),
                        const SizedBox(height: 12),
                        _buildQuickActionsGrid(context),

                        const SizedBox(height: 24),

                        // Riwayat Laporan (Reports History) Section
                        _buildReportsHistoryHeader(context),
                        const SizedBox(height: 12),
                        _buildReportsHistoryList(),

                        const SizedBox(
                          height: 20,
                        ), // Spacing for bottom navigation bar
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSOSCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SosPage()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Circular SOS Button
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFE97678).withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(6),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFEB6D70),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x40EB6D70),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    "SOS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Butuh Bantuan Cepat?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Ketuk tombol SOS untuk kirim sinyal bahaya, atau hubungi 112.",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsHeader() {
    return const Text(
      "Aksi Cepat",
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildActionCard(
            context,
            icon: Icons.campaign_rounded,
            label: "Kirim\nLaporan",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportPage()),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            context,
            icon: Icons.phone_in_talk_rounded,
            label: "Kontak\nDarurat",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EmergencyContactsPage()),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            context,
            icon: Icons.assignment_rounded,
            label: "Daftar\nLaporan",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryPage()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Icon(icon, color: const Color(0xFF5E6573), size: 32),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsHistoryHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Riwayat Laporan",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryPage()),
            );
          },
          child: const Text(
            "Lihat Semua",
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReportsHistoryList() {
    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
        if (state is ReportLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(color: Color(0xFFCC2D30)),
            ),
          );
        } else if (state is ReportsLoaded) {
          final reports = state.reports;
          if (reports.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Belum ada riwayat laporan",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ),
            );
          }

          // Show only top 3 reports on the home screen
          final displayReports = reports.take(3).toList();

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: displayReports.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final report = displayReports[index];
              final item = report.toMap();
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailLaporanPage(report: item),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Circle Color Indicator
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: item["color"],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            _getIconData(report.type),
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Content Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["title"],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item["location"],
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Status Pill + Time
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: (item["color"] as Color).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              item["status"],
                              style: TextStyle(
                                color: item["color"],
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item["date"],
                            style: TextStyle(color: Colors.grey.shade400, fontSize: 9),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  IconData _getIconData(String type) {
    switch (type) {
      case 'Kecelakaan':
        return Icons.car_crash_rounded;
      case 'Kebakaran':
        return Icons.local_fire_department_rounded;
      case 'Kriminalitas':
        return Icons.shield_rounded;
      case 'Bencana Alam':
        return Icons.warning_amber_rounded;
      default:
        return Icons.report_problem_rounded;
    }
  }
}
