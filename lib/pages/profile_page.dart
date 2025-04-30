import 'package:flutter/material.dart';
import 'package:projectflutter/auth/auth_service.dart';
import 'package:projectflutter/pages/login_pages.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authService = AuthService();

  @override
  void initState() {
    super.initState();
    forceLogin();
  }

  void forceLogin() async {
    // Garante que o contexto esteja pronto antes da navegação
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await authService.signOut(); // Sempre desloga
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tela vazia enquanto redireciona
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
