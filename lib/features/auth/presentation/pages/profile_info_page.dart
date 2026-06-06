import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laporin/theme.dart';
import 'package:laporin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:laporin/features/auth/presentation/bloc/auth_state.dart';
import 'package:laporin/widgets/custom_button.dart';
import 'edit_profile_page.dart';

class ProfileInfoPage extends StatelessWidget {
  const ProfileInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Informasi Profil",
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
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              String name = "Eve";
              String email = "evelyn@gmail.com";
              String phoneNumber = "+628123456789";
              String? avatarPath;

              if (state is AuthAuthenticated) {
                name = state.user.name;
                email = state.user.email;
                phoneNumber = state.user.phoneNumber ?? "+628123456789";
                avatarPath = state.user.avatarPath;
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // Profile Avatar
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 54,
                              backgroundImage: (avatarPath != null &&
                                      avatarPath.isNotEmpty &&
                                      !avatarPath.startsWith('http'))
                                  ? FileImage(File(avatarPath))
                                  : NetworkImage(avatarPath ??
                                          'https://i.pravatar.cc/150?u=eve')
                                      as ImageProvider,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFFCC2D30),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Information details card using Glassmorphism
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoItem(
                                Icons.person_rounded,
                                "Username / Nama",
                                name,
                              ),
                              const Divider(height: 24, color: Colors.black12),
                              _buildInfoItem(
                                Icons.email_rounded,
                                "Email",
                                email,
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.check_circle_rounded, color: Colors.green, size: 12),
                                      SizedBox(width: 4),
                                      Text(
                                        "Terverifikasi",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(height: 24, color: Colors.black12),
                              _buildInfoItem(
                                Icons.phone_android_rounded,
                                "Nomor Telepon",
                                phoneNumber,
                              ),
                              const Divider(height: 24, color: Colors.black12),
                              _buildInfoItem(
                                Icons.lock_rounded,
                                "Kata Sandi",
                                "••••••••",
                                trailing: TextButton(
                                  onPressed: () {
                                    _showChangePasswordDialog(context);
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(40, 30),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    "Ubah",
                                    style: TextStyle(
                                      color: Color(0xFFCC2D30),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Navigation to edit profile page
                    CustomButton(
                      text: "Ubah Profil",
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const EditProfilePage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    bool obscureOld = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: AlertDialog(
                backgroundColor: Colors.white.withValues(alpha: 0.9),
                surfaceTintColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
                ),
                title: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCC2D30).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_reset_rounded,
                        color: Color(0xFFCC2D30),
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Ubah Kata Sandi",
                      style: AppTextStyles.heading1.copyWith(fontSize: 18),
                    ),
                  ],
                ),
                content: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: oldPasswordController,
                          obscureText: obscureOld,
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            labelText: "Kata Sandi Lama",
                            labelStyle: const TextStyle(fontSize: 12),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCC2D30)),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureOld ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                size: 18,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscureOld = !obscureOld;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Masukkan kata sandi lama";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: newPasswordController,
                          obscureText: obscureNew,
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            labelText: "Kata Sandi Baru",
                            labelStyle: const TextStyle(fontSize: 12),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCC2D30)),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureNew ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                size: 18,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscureNew = !obscureNew;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Masukkan kata sandi baru";
                            }
                            if (value.length < 6) {
                              return "Minimal 6 karakter";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: obscureConfirm,
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            labelText: "Konfirmasi Kata Sandi Baru",
                            labelStyle: const TextStyle(fontSize: 12),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCC2D30)),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureConfirm ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                size: 18,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscureConfirm = !obscureConfirm;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Konfirmasi kata sandi baru";
                            }
                            if (value != newPasswordController.text) {
                              return "Kata sandi tidak cocok";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                actionsAlignment: MainAxisAlignment.spaceEvenly,
                actions: [
                  TextButton(
                    onPressed: () {
                      oldPasswordController.dispose();
                      newPasswordController.dispose();
                      confirmPasswordController.dispose();
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text(
                      "Batal",
                      style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCC2D30),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;

                      oldPasswordController.dispose();
                      newPasswordController.dispose();
                      confirmPasswordController.dispose();
                      Navigator.of(dialogContext).pop();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Kata sandi berhasil diubah!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: const Text("Simpan"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value, {Widget? trailing}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFCC2D30).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFCC2D30),
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}
