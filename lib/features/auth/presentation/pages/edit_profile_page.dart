import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laporin/theme.dart';
import 'package:laporin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:laporin/features/auth/presentation/bloc/auth_event.dart';
import 'package:laporin/features/auth/presentation/bloc/auth_state.dart';
import 'package:laporin/widgets/custom_button.dart';
import 'package:laporin/widgets/custom_text_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  String _originalEmail = "evelyn@gmail.com";
  String? _avatarPath;

  @override
  void initState() {
    super.initState();
    final state = context.read<AuthBloc>().state;
    String initialName = "Eve";
    String initialEmail = "evelyn@gmail.com";
    String initialPhone = "+628123456789";
    String? initialAvatar;

    if (state is AuthAuthenticated) {
      initialName = state.user.name;
      initialEmail = state.user.email;
      initialPhone = state.user.phoneNumber ?? "+628123456789";
      initialAvatar = state.user.avatarPath;
    }

    _originalEmail = initialEmail;
    _avatarPath = initialAvatar;
    _nameController = TextEditingController(text: initialName);
    _emailController = TextEditingController(text: initialEmail);
    _phoneController = TextEditingController(text: initialPhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatarImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _avatarPath = image.path;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal mengambil gambar: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showGalleryPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
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
                    Icons.photo_library_rounded,
                    color: Color(0xFFCC2D30),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Persetujuan Akses",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading1.copyWith(fontSize: 18),
                ),
              ],
            ),
            content: Text(
              "Lapor.In membutuhkan persetujuan Anda untuk mengakses galeri foto perangkat guna memilih foto profil baru.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.5),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: Text(
                  "Tolak",
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
                  Navigator.of(dialogContext).pop();
                  _pickAvatarImage();
                },
                child: const Text("Setuju"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    final newEmail = _emailController.text.trim();
    if (newEmail != _originalEmail) {
      // Email changed, trigger OTP verification dialog
      _showOtpVerificationDialog(newEmail);
    } else {
      // Email unchanged, save immediately
      _performUpdate();
    }
  }

  void _performUpdate() {
    context.read<AuthBloc>().add(
      ProfileUpdated(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        avatarPath: _avatarPath,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profil berhasil diperbarui!"),
        backgroundColor: Colors.green,
      ),
    );

    // Pop edit page
    Navigator.of(context).pop();
  }

  void _showOtpVerificationDialog(String targetEmail) {
    final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
    final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
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
                    Icons.mark_email_unread_rounded,
                    color: Color(0xFFCC2D30),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Verifikasi Email Baru",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading1.copyWith(fontSize: 18),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.5),
                    children: [
                      const TextSpan(text: "Kami telah mengirimkan 6 digit kode OTP ke "),
                      TextSpan(
                        text: targetEmail,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const TextSpan(text: ". Masukkan kode tersebut untuk memverifikasi perubahan email."),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // 6 OTP Input Boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 40,
                      height: 48,
                      child: TextField(
                        controller: otpControllers[index],
                        focusNode: focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFCC2D30)),
                        decoration: InputDecoration(
                          counterText: "",
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFCC2D30), width: 2),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            focusNodes[index + 1].requestFocus();
                          } else if (value.isEmpty && index > 0) {
                            focusNodes[index - 1].requestFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              TextButton(
                onPressed: () {
                  for (var controller in otpControllers) {
                    controller.dispose();
                  }
                  for (var node in focusNodes) {
                    node.dispose();
                  }
                  Navigator.of(context).pop();
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
                  String otp = otpControllers.map((c) => c.text).join();
                  if (otp.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Silakan masukkan 6 digit kode OTP."),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // Verify mock OTP (allow any 6 digit code)
                  for (var controller in otpControllers) {
                    controller.dispose();
                  }
                  for (var node in focusNodes) {
                    node.dispose();
                  }

                  Navigator.of(context).pop(); // Close Dialog
                  _performUpdate(); // Perform actual profile update
                },
                child: const Text("Verifikasi"),
              ),
            ],
          ),
        );
      },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Ubah Profil",
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Edit avatar area
                  Center(
                    child: GestureDetector(
                      onTap: () => _showGalleryPermissionDialog(context),
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
                              backgroundImage: (_avatarPath != null &&
                                      _avatarPath!.isNotEmpty &&
                                      !_avatarPath!.startsWith('http'))
                                  ? FileImage(File(_avatarPath!))
                                  : NetworkImage(_avatarPath ??
                                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=150')
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
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Fields wrapper in Glassmorphism Card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            CustomTextField(
                              hintText: "Username / Nama",
                              controller: _nameController,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              hintText: "Email",
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              hintText: "Nomor Telepon",
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 16),
                            const Divider(height: 1, color: Colors.black12),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () {
                                _showChangePasswordDialog(context);
                              },
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFCC2D30).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.lock_rounded,
                                      color: Color(0xFFCC2D30),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Kata Sandi",
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "••••••••",
                                          style: AppTextStyles.bodyMedium.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Text(
                                    "Ubah",
                                    style: TextStyle(
                                      color: Color(0xFFCC2D30),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  CustomButton(
                    text: "Simpan",
                    onPressed: _saveProfile,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
