import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:laporin/features/home/presentation/pages/main_page.dart';
import 'package:laporin/theme.dart';
import 'package:laporin/widgets/custom_button.dart';
import 'package:laporin/widgets/custom_text_field.dart';
import 'package:laporin/widgets/social_button.dart';
import 'package:laporin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:laporin/features/auth/presentation/bloc/auth_event.dart';
import 'package:laporin/features/auth/presentation/bloc/auth_state.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();
    String? emailError;

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
                      "Lupa Kata Sandi",
                      style: AppTextStyles.heading1.copyWith(fontSize: 18),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Masukkan alamat email Anda untuk menerima tautan pemulihan kata sandi.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Email Anda",
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                        errorText: emailError,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFCC2D30), width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red, width: 1.5),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                      onChanged: (val) {
                        if (emailError != null) {
                          setState(() {
                            emailError = null;
                          });
                        }
                      },
                    ),
                  ],
                ),
                actionsAlignment: MainAxisAlignment.spaceEvenly,
                actions: [
                  TextButton(
                    onPressed: () {
                      emailController.dispose();
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
                      final email = emailController.text.trim();
                      if (email.isEmpty) {
                        setState(() {
                          emailError = "Email tidak boleh kosong";
                        });
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
                        setState(() {
                          emailError = "Format email tidak valid";
                        });
                      } else {
                        emailController.dispose();
                        Navigator.of(dialogContext).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Link reset kata sandi telah dikirim ke email Anda!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    child: const Text("Kirim"),
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
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Container(
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Top Illustration Area
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Center(
                              child: Column(
                                children: [
                                  Container(
                                    height: 180,
                                    width: 500,
                                    decoration: BoxDecoration(shape: BoxShape.circle),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/images/vectorLogin.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Form Card with Glassmorphism
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  padding: const EdgeInsets.all(32),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Center(
                                        child: Text(
                                          "Login",
                                          style: AppTextStyles.heading1,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Center(
                                        child: Text(
                                          "Login untuk masuk ke aplikasi",
                                          style: AppTextStyles.bodyText.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 32),

                                      CustomTextField(
                                        hintText: "Username",
                                        controller: _usernameController,
                                      ),
                                      CustomTextField(
                                        hintText: "Password",
                                        isPassword: true,
                                        controller: _passwordController,
                                      ),

                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () => _showForgotPasswordDialog(context),
                                          child: Text(
                                            "Lupa Kata Sandi?",
                                            style: AppTextStyles.caption.copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      BlocBuilder<AuthBloc, AuthState>(
                                        builder: (context, state) {
                                          if (state is AuthLoading) {
                                            return const Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          }
                                          return CustomButton(
                                            text: "Masuk",
                                            onPressed: () {
                                              context.read<AuthBloc>().add(
                                                LoginSubmitted(
                                                  username: _usernameController.text,
                                                  password: _passwordController.text,
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),

                                      const SizedBox(height: 24),

                                      Row(
                                        children: [
                                          const Expanded(
                                            child: Divider(
                                              color: Color(0xFFE0E0E0),
                                              thickness: 1,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            child: Text(
                                              "Atau masuk dengan",
                                              style: AppTextStyles.caption,
                                            ),
                                          ),
                                          const Expanded(
                                            child: Divider(
                                              color: Color(0xFFE0E0E0),
                                              thickness: 1,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 24),

                                      Row(
                                        children: [
                                          SocialButton(
                                            text: "Google",
                                            icon: Image.asset(
                                              'assets/icons/Google.png',
                                              width: 18,
                                              height: 18,
                                            ),
                                            onPressed: () {},
                                          ),
                                          const SizedBox(width: 16),
                                          SocialButton(
                                            text: "Facebook",
                                            icon: const FaIcon(
                                              FontAwesomeIcons.facebook,
                                              color: Color(0xFF1877F2),
                                              size: 18,
                                            ),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Belum memiliki akun? ",
                                            style: AppTextStyles.bodyText.copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const RegisterPage(),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "Daftar",
                                              style: AppTextStyles.bodyText.copyWith(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
