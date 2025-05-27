import 'package:flutter/material.dart';
import 'package:projectflutter/pages/profile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'buscarsala_page.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  int _indiceAtual = 0;
  String _nomeUsuario = 'Carregando...';

  @override
  void initState() {
    super.initState();
    _carregarNomeUsuario();
  }

  Future<void> _carregarNomeUsuario() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      setState(() {
        _nomeUsuario = 'Visitante';
      });
      return;
    }

    try {
      final data =
          await supabase.from('users').select('*').eq('id', user.id).single();

      print('Dados do usuário recebidos: $data');

      if (data != null && data['nome'] != null) {
        setState(() {
          _nomeUsuario = data['nome'];
        });
      } else {
        setState(() {
          _nomeUsuario = 'Usuário';
        });
      }
    } catch (e) {
      print('Erro ao buscar nome do usuário: $e');
      setState(() {
        _nomeUsuario = 'Usuário';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Construir as páginas dinamicamente para garantir atualização do nome
    final pages = [
      buildHomePage(),
      buildAgendaPage(),

      // buildPerfilPage(), // Faltando o perfil aqui!
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body:
          _nomeUsuario == 'Carregando...'
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: pages[_indiceAtual],
              ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BuscarSalaPage()),
            );
          } else {
            setState(() {
              _indiceAtual = index;
            });
          }
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget buildHomePage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Stack(
            children: [
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/imgcarrosel.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Positioned(
                top: 30,
                right: 20,
                child: Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const Positioned(
                bottom: 20,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Boas-vindas com nome dinâmico
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bem-vindo(a),',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _nomeUsuario,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Chip(
                        label: Text('Semestre Outono 2025'),
                        backgroundColor: Colors.grey,
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const CircleAvatar(radius: 25),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Ícones de Acesso Rápido
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconButton(Icons.calendar_today, 'Agenda'),
                _buildIconButton(Icons.book, 'Disciplinas'),
                _buildIconButton(Icons.grade, 'Notas'),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Cartão de próxima aula
          _buildProximaAulaCard(),

          const SizedBox(height: 30),

          _buildSectionHeader('Disciplinas da Semana', Icons.school),
          _buildDisciplinaCard(
            'Psicologia Social',
            'Segunda - 08:00',
            'Sala 101',
          ),
          _buildDisciplinaCard(
            'Engenharia de Software',
            'Terça - 13:00',
            'Sala 305',
          ),
          _buildDisciplinaCard(
            'Filosofia Moderna',
            'Quarta - 15:00',
            'Sala 202',
          ),

          const SizedBox(height: 30),

          _buildSectionHeader('Avisos Recentes', Icons.announcement),
          _buildAvisoCard(
            'Palestra sobre Carreiras na Tecnologia',
            'Quinta-feira às 18h no auditório.',
          ),
          _buildAvisoCard(
            'Atualização no sistema acadêmico',
            'Entre os dias 10 e 12 o sistema ficará fora do ar para manutenção.',
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget buildAgendaPage() {
    // Apenas retorna um container vazio, pois a navegação será feita pelo onTap do BottomNavigationBar
    return const SizedBox.shrink();
  }

  Widget _buildIconButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white,
          child: Icon(icon, size: 30, color: Colors.blue),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget _buildProximaAulaCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 202, 206, 5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PRÓXIMA AULA', style: TextStyle(color: Colors.white70)),
                SizedBox(height: 8),
                Text(
                  'Algoritmos e Lógica',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '11:00 • Sala 201',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
            Text(
              '20 min',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDisciplinaCard(String titulo, String horario, String sala) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: const Icon(Icons.book, color: Colors.indigo),
          title: Text(titulo),
          subtitle: Text('$horario • $sala'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {},
        ),
      ),
    );
  }

  Widget _buildAvisoCard(String titulo, String descricao) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          leading: const Icon(Icons.announcement, color: Colors.amber),
          title: Text(titulo),
          subtitle: Text(descricao),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
      ),
    );
  }
}
