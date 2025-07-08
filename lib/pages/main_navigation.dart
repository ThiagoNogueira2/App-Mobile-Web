import 'package:flutter/material.dart';
import 'package:projectflutter/pages/perfil_page.dart';
import 'package:projectflutter/pages/home_page.dart';
import 'package:projectflutter/pages/agenda_page.dart';
import 'package:projectflutter/services/logged_user_preload_service.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _indiceAtual = 0;
  final _loggedUserPreload = LoggedUserPreloadService();

  @override
  void initState() {
    super.initState();
    // Inicia pré-carregamento de dados do usuário logado
    _loggedUserPreload.preloadLoggedUserData();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        onAgendaTap: () {
          setState(() {
            _indiceAtual = 1;
          });
        },
      ),
      const AgendaPage(),
      const PerfilPage(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: pages[_indiceAtual],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _indiceAtual,
          onTap: (index) {
            setState(() {
              _indiceAtual = index;
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF2563EB), // azul vivo
          unselectedItemColor: Colors.grey[400],
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_rounded),
              label: 'Agenda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
} 