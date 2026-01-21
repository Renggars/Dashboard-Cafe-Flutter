import 'package:cafe/core/constants/colors.dart';
import 'package:cafe/features/pos/data/services/auth_service.dart';
import 'package:cafe/features/presentation/pages/homePage/pos_page.dart';
import 'package:flutter/material.dart';
import 'package:cafe/injection.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email dan Password tidak boleh kosong"),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Memanggil AuthService melalui GetIt
    final result = await getIt<AuthService>().login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (result['success']) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PosPage()),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih bersih
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            // Lebar ideal untuk tablet agar terlihat kokoh
            constraints: const BoxConstraints(maxWidth: 550),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 60),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                // Bayangan lebih lembut dan menyebar untuk kesan premium di BG putih
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon Branding
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.coffee_rounded,
                        size: 64, color: AppColors.primary),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Masuk untuk mengelola Cafe Anda",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Email Input
                  _buildTextField(
                    controller: _emailController,
                    label: "Email Address",
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 24),

                  // Password Input
                  _buildTextField(
                    controller: _passwordController,
                    label: "Password",
                    icon: Icons.lock_outline_rounded,
                    isPassword: true,
                  ),

                  const SizedBox(height: 40),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 65,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "LOGIN KE SISTEM",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      style: const TextStyle(fontSize: 18),
      decoration: InputDecoration(
        hintText: label,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Icon(icon, color: Colors.blue.shade600, size: 24),
        ),
        suffixIcon: isPassword
            ? IconButton(
                padding: const EdgeInsets.only(right: 12),
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey.shade400,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              )
            : null,
        filled: true,
        fillColor: const Color(
            0xFFF9F9F9), // Warna input sedikit off-white agar terlihat beda dari kartu
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 22),
      ),
    );
  }
}
