import 'package:flutter/material.dart';
import 'package:laporin/theme.dart';
import 'calling_page.dart';

class SosPage extends StatefulWidget {
  const SosPage({super.key});

  @override
  State<SosPage> createState() => _SosPageState();
}

class _SosPageState extends State<SosPage> with TickerProviderStateMixin {
  bool _isActivated = false;
  
  // Controller for manual soft tap scale pulse
  late AnimationController _tapController;
  late Animation<double> _scaleAnimation;
  
  // Controller for continuous breathing animation when active
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeOutCubic),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // Smooth 1.2-second breathing cycle
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onSOSPressed() {
    // Soft bounce back up, then toggle state
    _tapController.animateTo(1.0, duration: const Duration(milliseconds: 150), curve: Curves.easeOutCubic).then((_) {
      setState(() {
        _isActivated = !_isActivated;
        if (_isActivated) {
          _pulseController.repeat(reverse: true);
        } else {
          _pulseController.stop();
          _pulseController.reset();
        }
      });
    });
  }

  void _call112() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CallingPage(
          contactName: "Layanan Darurat 112",
          phoneNumber: "112",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1. Top Header Area (Back button + Location title)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Lokasi Terkini Anda",
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Colors.grey.shade700),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "Jl. Sudirman - Sudirman OST",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(width: 44),
                  ],
                ),
              ),

              // 2. Dynamic Central Titles with Fixed Height & Animated Switchers (DISSOLVE FADE TRANSITION)
              Container(
                height: 110,
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: child.key == ValueKey<bool>(_isActivated) ? animation : Tween<double>(begin: 0.0, end: 1.0).animate(animation), child: child);
                      },
                      child: Text(
                        _isActivated ? "Bantuan dalam perjalanan!" : "Apakah Anda dalam keadaan darurat?",
                        key: ValueKey<bool>(_isActivated),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.25,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: Text(
                        _isActivated
                            ? "Bantuan sedang dalam perjalanan, harap tetap tenang dan bersabar!"
                            : "Tekan tombol di bawah dan bantuan akan segera datang",
                        key: ValueKey<bool>(_isActivated),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 3. Central Concentric Animated SOS Button (Animated container dissolves color smoothly)
              GestureDetector(
                onTapDown: (_) {
                  _tapController.animateTo(0.93, duration: const Duration(milliseconds: 150), curve: Curves.easeOutCubic);
                },
                onTapUp: (_) {
                  _onSOSPressed();
                },
                onTapCancel: () {
                  _tapController.animateTo(1.0, duration: const Duration(milliseconds: 150), curve: Curves.easeOutCubic);
                },
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: SizedBox(
                    width: 250,
                    height: 250,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Continuous smooth breathing outer radar ring (color dissolves smoothly via AnimatedContainer)
                        ScaleTransition(
                          scale: _isActivated ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              color: _isActivated
                                  ? const Color(0xFF7F7F7F).withValues(alpha: 0.15)
                                  : const Color(0xFFFCA5A5).withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(24),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                color: _isActivated
                                    ? const Color(0xFFA3A3A3).withValues(alpha: 0.3)
                                    : const Color(0xFFFEE2E2).withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        
                        // Solid Inner Button Card (Dissolves colors and shadows smoothly via AnimatedContainer)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 450),
                          curve: Curves.easeInOut,
                          width: 170,
                          height: 170,
                          decoration: BoxDecoration(
                            color: _isActivated ? const Color(0xFF262626) : const Color(0xFFEB6D70),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _isActivated
                                    ? Colors.black.withValues(alpha: 0.25)
                                    : const Color(0xFFEB6D70).withValues(alpha: 0.35),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              "SOS",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 44,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 4. Dial 112 Directly Shortcut (Enlarged)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _call112,
                    icon: const Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 24),
                    label: const Text(
                      "Hubungi Panggilan 112 Secara Langsung",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white, letterSpacing: 0.2),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCC2D30),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),

              // 5. Bottom Current Address Card
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Alamat Terkini Anda",
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Jl. Sudirman No. 12, Sudirman OST, Jakarta",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
