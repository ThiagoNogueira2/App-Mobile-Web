import 'package:flutter/material.dart';
import 'package:projectflutter/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authService = AuthService();

  // Text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _cursoController = TextEditingController();
  final _semestreController = TextEditingController();
  final _periodoController = TextEditingController();

  void signUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final curso = _cursoController.text;
    final semestre = _semestreController.text;
    final periodo = _periodoController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    try {
      await authService.signUpWithEmailPassword(
        email,
        password,
        curso: curso,
        semestre: semestre,
        periodo: periodo,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 50),
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: "Email"),
          ),

          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: "Password"),
            obscureText: true,
          ),

          TextField(
            controller: _confirmPasswordController,
            decoration: const InputDecoration(labelText: "Confirm Password"),
            obscureText: true,
          ),

          TextField(
            controller: _cursoController,
            decoration: const InputDecoration(labelText: "Curso"),
          ),

          TextField(
            controller: _semestreController,
            decoration: const InputDecoration(labelText: "Semestre"),
          ),
          TextField(
            controller: _periodoController,
            decoration: const InputDecoration(labelText: "Período"),
          ),

          const SizedBox(height: 12),

          ElevatedButton(onPressed: signUp, child: const Text("Sign Up")),
        ],
      ),
    );
  }
}
