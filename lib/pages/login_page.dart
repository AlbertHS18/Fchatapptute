import 'package:fchatapptute/auth/auth_service.dart';
import 'package:fchatapptute/components/my_button.dart';
import 'package:fchatapptute/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatelessWidget {
  // Email y Password controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  // Navegación a página de registro
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  // Método de Login
  Future<void> login(BuildContext context) async {
    final authService = AuthService();

    final email = _emailController.text.trim();
    final password = _pwController.text.trim();

    // Validación básica
    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog(context, 'Please fill in all fields');
      return;
    }

    // Intentar iniciar sesión
    try {
      await authService.signInWithEmailPassword(email, password);
      // Éxito: Aquí podrías navegar a otra página
    } on PlatformException catch (e) {
      _showErrorDialog(context, e.message ?? 'An unknown error occurred');
    } catch (e) {
      _showErrorDialog(context, 'Login failed. Please try again.');
    }
  }

  // Mostrar un diálogo de error
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Icon(
                Icons.message,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 50),
              // Welcome message
              Text(
                "Welcome back, you've been missed!",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 25),
              // Email TextField
              MyTextField(
                hintText: "Email",
                obscureText: false,
                controller: _emailController,
              ),
              const SizedBox(height: 10),
              // Password TextField
              MyTextField(
                hintText: "Password",
                obscureText: true,
                controller: _pwController,
              ),
              const SizedBox(height: 25),
              // Login Button
              MyButton(
                text: "Login",
                onTap: () => login(context),
              ),
              const SizedBox(height: 25),
              // Register Now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member? ",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      "Register now",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
