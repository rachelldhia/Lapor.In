import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laporin/theme.dart';
import 'package:laporin/widgets/custom_button.dart';
import 'package:laporin/widgets/custom_text_field.dart';
import 'package:laporin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:laporin/features/auth/presentation/bloc/auth_event.dart';
import 'package:laporin/features/auth/presentation/bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final ScrollController _scrollController = ScrollController();
  double _imageHeight = 200.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final double offset = _scrollController.offset;
    setState(() {
      _imageHeight = (200.0 - offset).clamp(80.0, 200.0);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Account created for ${state.user.name}!'),
              ),
            );
            Navigator.pop(context);
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
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Top Illustration Area
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Center(
                              child: Image.asset(
                                'assets/images/vectorRegis.png',
                                height: _imageHeight,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          // Form Card with Glassmorphism
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Center(
                                        child: Text(
                                          "Register",
                                          style: AppTextStyles.heading1,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Center(
                                        child: Text(
                                          "Register untuk membuat akun",
                                          style: AppTextStyles.bodyText
                                              .copyWith(
                                                color: AppColors.textSecondary,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),

                                      CustomTextField(
                                        hintText: "Username",
                                        controller: _nameController,
                                      ),
                                      CustomTextField(
                                        hintText: "Email",
                                        controller: _emailController,
                                        keyboardType: TextInputType.emailAddress,
                                      ),
                                      CustomTextField(
                                        hintText: "Nomor Telepon",
                                        controller: _phoneController,
                                        keyboardType: TextInputType.phone,
                                      ),
                                      CustomTextField(
                                        hintText: "Password",
                                        isPassword: true,
                                        controller: _passwordController,
                                      ),
                                      CustomTextField(
                                        hintText: "Confirm Password",
                                        isPassword: true,
                                        controller: _confirmPasswordController,
                                      ),

                                      const SizedBox(height: 16),

                                      BlocBuilder<AuthBloc, AuthState>(
                                        builder: (context, state) {
                                          if (state is AuthLoading) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          return CustomButton(
                                            text: "Daftar",
                                            onPressed: () {
                                              if (_passwordController.text !=
                                                  _confirmPasswordController
                                                      .text) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Passwords do not match',
                                                    ),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                                return;
                                              }
                                              context.read<AuthBloc>().add(
                                                RegisterSubmitted(
                                                  name: _nameController.text,
                                                  email: _emailController.text,
                                                  password:
                                                      _passwordController.text,
                                                  phoneNumber:
                                                      _phoneController.text,
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),

                                      const SizedBox(height: 24),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Sudah memiliki akun? ",
                                            style: AppTextStyles.bodyText
                                                .copyWith(
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Masuk",
                                              style: AppTextStyles.bodyText
                                                  .copyWith(
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
