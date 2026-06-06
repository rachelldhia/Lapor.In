import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:laporin/theme.dart';
import 'package:laporin/features/home/presentation/pages/home_page.dart';
import 'package:laporin/features/report/presentation/pages/history_page.dart';
import 'package:laporin/features/auth/presentation/pages/profile_page.dart';
import 'package:laporin/features/home/presentation/pages/emergency_contacts_page.dart';
import 'package:laporin/features/home/presentation/pages/sos_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const HistoryPage(),
      const EmergencyContactsPage(),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _pages[_currentIndex],
          
          // Frosted status bar blur overlay (protects clock, battery, wifi visibility on scroll)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: topPadding,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // Solid full-width bar content
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, "Beranda"),
                  ),
                  Expanded(
                    child: _buildNavItem(1, Icons.assignment_rounded, Icons.assignment_outlined, "Laporan"),
                  ),
                  // Symmetrical spacer for the floating SOS button
                  const Expanded(
                    child: SizedBox(height: 1),
                  ),
                  Expanded(
                    child: _buildNavItem(2, Icons.phone_in_talk_rounded, Icons.phone_in_talk_outlined, "Darurat"),
                  ),
                  Expanded(
                    child: _buildNavItem(3, Icons.person_rounded, Icons.person_outline_rounded, "Profil"),
                  ),
                ],
              ),
            ),
            
            // Floating Circular SOS Button in the Center
            Positioned(
              bottom: 16, // Raised perfectly above the solid bottom bar
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SosPage()),
                  );
                },
                child: Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEB6D70),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEB6D70).withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "SOS",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? AppColors.primary : Colors.grey.shade400;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? activeIcon : inactiveIcon,
            color: color,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
