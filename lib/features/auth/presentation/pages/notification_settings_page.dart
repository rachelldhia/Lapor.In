import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:laporin/theme.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _reportResolved = true;
  bool _reportStatusChange = true;
  bool _emergencyAlerts = true;
  bool _announcements = false;

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pengaturan Notifikasi",
                  style: AppTextStyles.heading2.copyWith(fontSize: 15, color: Colors.black87),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildSwitchTile(
                            icon: Icons.assignment_turned_in_rounded,
                            title: "Laporan Selesai",
                            subtitle: "Notifikasi saat laporan Anda telah selesai ditindaklanjuti",
                            value: _reportResolved,
                            onChanged: (val) {
                              setState(() {
                                _reportResolved = val;
                              });
                            },
                          ),
                          const Divider(height: 1, color: Colors.black12, indent: 60),
                          _buildSwitchTile(
                            icon: Icons.sync_problem_rounded,
                            title: "Update Status",
                            subtitle: "Notifikasi setiap ada perubahan status pada laporan Anda",
                            value: _reportStatusChange,
                            onChanged: (val) {
                              setState(() {
                                _reportStatusChange = val;
                              });
                            },
                          ),
                          const Divider(height: 1, color: Colors.black12, indent: 60),
                          _buildSwitchTile(
                            icon: Icons.emergency_share_rounded,
                            title: "SOS & Peringatan Darurat",
                            subtitle: "Notifikasi mengenai peringatan darurat di sekitar lokasi Anda",
                            value: _emergencyAlerts,
                            onChanged: (val) {
                              setState(() {
                                _emergencyAlerts = val;
                              });
                            },
                          ),
                          const Divider(height: 1, color: Colors.black12, indent: 60),
                          _buildSwitchTile(
                            icon: Icons.campaign_rounded,
                            title: "Info & Pengumuman",
                            subtitle: "Tips keamanan, informasi pemeliharaan sistem, dan promo",
                            value: _announcements,
                            onChanged: (val) {
                              setState(() {
                                _announcements = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFCC2D30).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFFCC2D30), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Colors.grey.shade500,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch.adaptive(
            value: value,
            activeThumbColor: const Color(0xFFCC2D30),
            activeTrackColor: const Color(0xFFCC2D30).withValues(alpha: 0.3),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
