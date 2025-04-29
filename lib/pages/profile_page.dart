import 'package:flutter/material.dart';
import 'package:projectflutter/auth/auth_service.dart';
import 'package:projectflutter/pages/login_pages.dart'; // Adicione essa importação

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authService = AuthService();

  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    final data = await authService.getCurrentUserData();
    setState(() {
      userData = data;
    });
  }

  void logout() async {
    await authService.signOut();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = authService.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bem vindo!"),
        actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.logout)),
        ],
      ),

      // aqui é para ser nossa tela de config
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Email: ${currentUser?.email ?? 'Carregando...'}"),
            const SizedBox(height: 8),
            Text("Curso: ${userData?['curso'] ?? 'Carregando...'}"),
            const SizedBox(height: 8),
            Text("Semestre: ${userData?['semestre'] ?? 'Carregando...'}"),
            const SizedBox(height: 8),
            Text("Período: ${userData?['periodo'] ?? 'Carregando...'}"),
          ],
        ),
      ),
    );
  }
}
