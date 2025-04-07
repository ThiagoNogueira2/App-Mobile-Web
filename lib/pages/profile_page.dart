import 'package:flutter/material.dart';
import 'package:projectflutter/auth/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authService = AuthService();

  void logout() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = authService.getCurrentUser();

    final userData = authService.getCurrentUserData();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bem vindo!"),
        actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Email: ${currentUser?.email ?? ''}"),
            const SizedBox(height: 8),

            Text("Curso: ${userData?['curso'] ?? 'Não informado'}"),
            const SizedBox(height: 8),

            Text("Semestre: ${userData?['semestre'] ?? 'Não informado'}"),
            const SizedBox(height: 8),

            Text("Período: ${userData?['periodo'] ?? 'Não informado'}"),
          ],
        ),
      ),
    );
  }
}
