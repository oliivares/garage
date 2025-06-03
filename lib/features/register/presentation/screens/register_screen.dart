import 'package:app_garagex/features/register/presentation/bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_garagex/features/login/presentation/screens/login_screen.dart';
import 'package:app_garagex/l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _bloc = RegisterBloc();

  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isRegistering = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  Future<void> _handleRegister() async {
    setState(() => _isRegistering = true);

    final result = await _bloc.registerUser(
      name: _nameController.text.trim(),
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    setState(() => _isRegistering = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: result['success'] ? Colors.green : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      ),
    );

    if (result['success']) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      });
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    IconData? prefixIcon,
    bool isPassword = false,
    bool isVisible = false,
    VoidCallback? toggleVisibility,
  }) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      suffixIcon:
          isPassword
              ? IconButton(
                icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: toggleVisibility,
              )
              : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.createAccount),
          backgroundColor: Colors.deepOrangeAccent,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: _inputDecoration(
                  label: AppLocalizations.of(context)!.fullName,
                  prefixIcon: Icons.person,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _usernameController,
                decoration: _inputDecoration(
                  label: AppLocalizations.of(context)!.userName,
                  prefixIcon: Icons.account_circle,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: _inputDecoration(
                  label: AppLocalizations.of(context)!.email,
                  prefixIcon: Icons.email,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: _inputDecoration(
                  label: AppLocalizations.of(context)!.phone,
                  prefixIcon: Icons.phone,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: !_showPassword,
                decoration: _inputDecoration(
                  label: AppLocalizations.of(context)!.password,
                  prefixIcon: Icons.lock,
                  isPassword: true,
                  isVisible: _showPassword,
                  toggleVisibility: () {
                    setState(() => _showPassword = !_showPassword);
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: !_showConfirmPassword,
                decoration: _inputDecoration(
                  label: AppLocalizations.of(context)!.confirmPassword,
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  isVisible: _showConfirmPassword,
                  toggleVisibility: () {
                    setState(
                      () => _showConfirmPassword = !_showConfirmPassword,
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isRegistering ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      _isRegistering
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            "Registrarse",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.deepOrange,
                            ),
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
