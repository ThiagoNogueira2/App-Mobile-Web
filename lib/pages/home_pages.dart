import 'package:flutter/material.dart';
import 'package:projectflutter/pages/profile_page.dart';
import 'package:projectflutter/pages/perfil_page.dart'; // Importação correta
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
      if (mounted) {
        setState(() {
          _nomeUsuario = 'Visitante';
        });
      }
      return;
    }

    try {
      final data =
          await supabase.from('users').select('*').eq('id', user.id).single();

      print('Dados do usuário recebidos: $data');

      if (mounted) {
        if (data['nome'] != null) {
          setState(() {
            _nomeUsuario = data['nome'];
          });
        } else {
          setState(() {
            _nomeUsuario = 'Usuário';
          });
        }
      }
    } catch (e) {
      print('Erro ao buscar nome do usuário: $e');
      if (mounted) {
        setState(() {
          _nomeUsuario = 'Usuário';
        });
      }
    }
  }

  Future<List<Map<String, dynamic>>> _buscarAgendamentosHoje() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) return [];
    final userData = await supabase
        .from('users')
        .select('curso_id')
        .eq('id', user.id)
        .maybeSingle();
    final cursoId = userData?['curso_id'];
    if (cursoId == null) return [];
    final hoje = DateTime.now();
    final diaStr =
        '${hoje.year.toString().padLeft(4, '0')}-${hoje.month.toString().padLeft(2, '0')}-${hoje.day.toString().padLeft(2, '0')}';
    final response = await supabase
        .from('agendamento')
        .select('''
          id,
          dia,
          aula_periodo,
          hora_inicio,
          hora_fim,
          cursos(id, curso, semestre, periodo),
          salas(id, numero_sala)
        ''')
        .eq('dia', diaStr)
        .eq('curso_id', cursoId)
        .order('hora_inicio');
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> _buscarProximaAulaHoje() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) return null;
    final userData = await supabase
        .from('users')
        .select('curso_id')
        .eq('id', user.id)
        .maybeSingle();
    final cursoId = userData?['curso_id'];
    if (cursoId == null) return null;
    final hoje = DateTime.now();
    final diaStr =
        '${hoje.year.toString().padLeft(4, '0')}-${hoje.month.toString().padLeft(2, '0')}-${hoje.day.toString().padLeft(2, '0')}';
    final response = await supabase
        .from('agendamento')
        .select('''
          id,
          aula_periodo,
          hora_inicio,
          hora_fim,
          cursos(id, curso, semestre, periodo),
          salas(id, numero_sala)
        ''')
        .eq('dia', diaStr)
        .eq('curso_id', cursoId)
        .order('hora_inicio', ascending: true)
        .limit(1);
    if (response.isNotEmpty) {
      return response[0];
    }
    return null;
  }

  Widget buildAgendaPage() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _buscarAgendamentosHoje(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final agendamentos = snapshot.data ?? [];
        if (agendamentos.isEmpty) {
          return const Center(
            child: Text(
              'Nenhuma aula cadastrada para hoje.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }
        return ListView.builder(
          itemCount: agendamentos.length > 2 ? 2 : agendamentos.length,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          itemBuilder: (context, idx) {
            final ag = agendamentos[idx];
            final sala = ag['salas']?['numero_sala']?.toString() ?? '-';
            final curso = ag['cursos']?['curso'] ?? '-';
            final periodo = ag['cursos']?['periodo'] ?? '-';
            final semestre = ag['cursos']?['semestre'] ?? '-';
            return Card(
              margin: const EdgeInsets.only(bottom: 24),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ag['aula_periodo'] ?? '-',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text('Início: ${ag['hora_inicio'] ?? '-'}'),
                        const SizedBox(width: 16),
                        Text('Fim: ${ag['hora_fim'] ?? '-'}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.meeting_room, color: Colors.green),
                        const SizedBox(width: 8),
                        Text('Sala: $sala'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.school, color: Colors.deepPurple),
                        const SizedBox(width: 8),
                        Text('Curso: $curso'),
                        const SizedBox(width: 16),
                        Text('Período: $periodo'),
                        const SizedBox(width: 16),
                        Text('Semestre: $semestre'),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [buildHomePage(), buildAgendaPage(), const PerfilPage()];

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
          setState(() {
            _indiceAtual = index;
          });
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
    return FutureBuilder<Map<String, dynamic>?>(
      future: _buscarProximaAulaHoje(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 110,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
          );
        }
        final ag = snapshot.data;
        if (ag == null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 202, 206, 5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.white70),
                  SizedBox(width: 12),
                  Text(
                    'Nenhuma aula agendada para hoje.',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        }
        final disciplina = ag['aula_periodo'] ?? '-';
        final inicio = ag['hora_inicio'] ?? '-';
        final fim = ag['hora_fim'] ?? '-';
        final sala = ag['salas']?['numero_sala']?.toString() ?? '-';
        final curso = ag['cursos']?['curso'] ?? '-';
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 202, 206, 5),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.yellow.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('PRÓXIMA AULA', style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 8),
                      Text(
                        disciplina,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.white, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            'Início: ',
                            style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            inicio,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Fim: ',
                            style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            fim,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.school, color: Colors.white, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            curso,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow.withOpacity(0.18),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.meeting_room, color: Color(0xFFcace05), size: 28),
                      const SizedBox(height: 4),
                      Text(
                        'Sala',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        sala,
                        style: const TextStyle(
                          color: Color(0xFFcace05),
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
