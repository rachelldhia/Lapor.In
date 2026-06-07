import 'dart:async';
import 'package:flutter/material.dart';

class CallingPage extends StatefulWidget {
  final String contactName;
  final String phoneNumber;
  final String? avatarUrl;

  const CallingPage({
    super.key,
    required this.contactName,
    required this.phoneNumber,
    this.avatarUrl,
  });

  @override
  State<CallingPage> createState() => _CallingPageState();
}

class _CallingPageState extends State<CallingPage> with SingleTickerProviderStateMixin {
  String _callStatus = "Menghubungi...";
  Timer? _statusTimer;
  Timer? _callDurationTimer;
  int _secondsElapsed = 0;
  bool get _isEmergencyService => widget.phoneNumber.trim().length <= 4;

  late AnimationController _avatarAnimationController;
  late Animation<double> _avatarPulseAnimation;

  @override
  void initState() {
    super.initState();
    _avatarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _avatarPulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _avatarAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Call status lifecycle simulation:
    // "Menghubungi..." (1.5s) -> "Berdering..." (2s) -> Active Timer
    _statusTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _callStatus = "Berdering...";
        });
        
        _statusTimer = Timer(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _callStatus = "00:00";
            });
            _startCallDurationTimer();
          }
        });
      }
    });
  }

  void _startCallDurationTimer() {
    _callDurationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
          final minutes = (_secondsElapsed ~/ 60).toString().padLeft(2, '0');
          final seconds = (_secondsElapsed % 60).toString().padLeft(2, '0');
          _callStatus = "$minutes:$seconds";
        });
      }
    });
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _callDurationTimer?.cancel();
    _avatarAnimationController.dispose();
    super.dispose();
  }

  void _endCall() {
    // Show quick closing overlay and pop
    setState(() {
      _callStatus = "Panggilan Berakhir";
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  String _getDefaultAvatarUrl() {
    final lowercaseName = widget.contactName.toLowerCase();
    final isFemale = lowercaseName.endsWith("ah") || 
                     lowercaseName.endsWith("i") || 
                     lowercaseName.endsWith("a") || 
                     lowercaseName.contains("siti") ||
                     lowercaseName.contains("dewi") ||
                     lowercaseName.contains("indah") ||
                     lowercaseName.contains("rini") ||
                     lowercaseName.contains("fani");
    final avatarId = (widget.contactName.hashCode % 90).abs();
    return isFemale 
        ? "https://randomuser.me/api/portraits/women/$avatarId.jpg" 
        : "https://randomuser.me/api/portraits/men/$avatarId.jpg";
  }

  @override
  Widget build(BuildContext context) {
    // WhatsApp style dark theme colors
    const Color whatsappDarkBg = Color(0xFF0F1B21);

    return Scaffold(
      backgroundColor: whatsappDarkBg,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Section - Encrypted Lock Notice & Mode
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_rounded, color: Colors.grey.shade500, size: 13),
                      const SizedBox(width: 6),
                      Text(
                        "Tersinkronisasi & Terenkripsi",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.contactName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _callStatus,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Mid Section - Large Pulsing Avatar
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer radar pulse
                  ScaleTransition(
                    scale: _avatarPulseAnimation,
                    child: Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  ScaleTransition(
                    scale: _avatarPulseAnimation,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Avatar Card
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: _isEmergencyService ? const Color(0xFFCC2D30) : Colors.white12,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: _isEmergencyService
                        ? Center(
                            child: Text(
                              widget.phoneNumber,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          )
                        : CircleAvatar(
                            radius: 55,
                            backgroundImage: NetworkImage(
                              widget.avatarUrl ?? _getDefaultAvatarUrl(),
                            ),
                          ),
                  ),
                ],
              ),
            ),

            // Bottom Section - Phone Control (Decline/Hang-up)
            Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: Column(
                children: [
                  // Hang Up Button (Phone Icon)
                  GestureDetector(
                    onTap: _endCall,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE53E3E),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.call_end_rounded,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),
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
}
