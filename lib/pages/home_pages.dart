import 'dart:async'; // Adicione este import
import 'package:flutter/material.dart';
import 'package:projectflutter/pages/perfil_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  int _indiceAtual = 0;
  String _nomeUsuario = 'Carregando...';
  late final PageController _carrosselController;
  Timer? _carrosselTimer;

  // Novo estado para o dia selecionado (0=Seg, 1=Ter, ..., 4=Sex)
  int _diaSemanaSelecionado = DateTime.now().weekday.clamp(1, 5) - 1;

  @override
  void initState() {
    super.initState();
    _carregarNomeUsuario();
    _carrosselController = PageController(viewportFraction: 0.85);

    // Timer para auto-scroll do carrossel
    _carrosselTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;
      if (!_carrosselController.hasClients) return; // <-- Adicione esta linha!
      final noticiasLength = 3; // Atualize se mudar a quantidade de notícias
      int nextPage = _carrosselController.page?.round() ?? 0;
      nextPage = (nextPage + 1) % noticiasLength;
      _carrosselController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _carrosselTimer?.cancel(); // Cancele o timer
    _carrosselController.dispose(); // Libere o controller
    super.dispose();
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
    final userData =
        await supabase
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

    print('Agendamentos HOJE ($diaStr):');
    for (var item in response) {
      print(item);
    }

    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> _buscarProximaAulaHoje() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) return null;
    final userData =
        await supabase
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
          salas(id, numero_sala),
          materias(id, nome),
          professores(id, nome_professor)
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

  Future<List<Map<String, dynamic>>> _buscarAgendamentosPorDia(
    int diaSemana,
  ) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) return [];
    final userData =
        await supabase
            .from('users')
            .select('curso_id')
            .eq('id', user.id)
            .maybeSingle();
    final cursoId = userData?['curso_id'];
    if (cursoId == null) return [];

    // Calcula a data da semana referente ao dia selecionado
    final hoje = DateTime.now();
    final segunda = hoje.subtract(Duration(days: hoje.weekday - 1));
    final dataSelecionada = segunda.add(Duration(days: diaSemana));
    final diaStr =
        '${dataSelecionada.year.toString().padLeft(4, '0')}-${dataSelecionada.month.toString().padLeft(2, '0')}-${dataSelecionada.day.toString().padLeft(2, '0')}';

    final response = await supabase
        .from('agendamento')
        .select('''
          id,
          dia,
          aula_periodo,
          hora_inicio,
          hora_fim,
          periodo,
          cursos(id, curso),
          salas(id, numero_sala),
          materias(id, nome),
          professores(id, nome_professor)
        ''')
        .eq('dia', diaStr)
        .eq('curso_id', cursoId)
        .order('hora_inicio');
    return List<Map<String, dynamic>>.from(response);
  }

  Widget buildAgendaPage() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _buscarAgendamentosPorDia(_diaSemanaSelecionado), // <-- CERTO!
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
            ),
          );
        }
        final agendamentos = snapshot.data ?? [];
        return Column(
          children: [
            // Header da agenda com imagem
            Container(
              width: double.infinity,
              height: 240,
              margin: const EdgeInsets.only(
                bottom: 24,
                left: 16,
                right: 16,
                top: 8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2563EB), // azul vivo
                    Color(0xFF1D4ED8), // azul escuro
                    Color(0xFF60A5FA), // azul claro
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withOpacity(0.18), // azul vivo
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Padrão decorativo
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    left: -30,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Conteúdo
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.calendar_today_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Text(
                                'Minha Agenda',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            'Hoje, ${_formatarDataHoje()}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${agendamentos.length} aula${agendamentos.length != 1 ? 's' : ''} agendada${agendamentos.length != 1 ? 's' : ''}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Linha dos dias da semana (segunda a sexta)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (idx) {
                  final nomes = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex'];
                  final diasNum = [1, 2, 3, 4, 5];
                  final hoje = DateTime.now();
                  final data = hoje.subtract(
                    Duration(days: hoje.weekday - 1 - idx),
                  );
                  final isSelecionado = idx == _diaSemanaSelecionado;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _diaSemanaSelecionado = idx;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 0,
                      ),
                      width: 54,
                      decoration: BoxDecoration(
                        color: isSelecionado
                            ? const Color(0xFF2563EB) // azul vivo
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          if (isSelecionado)
                            BoxShadow(
                              color: const Color(0xFF2563EB).withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                        ],
                        border: Border.all(
                          color: isSelecionado
                              ? const Color(0xFF2563EB)
                              : const Color(0xFFE5E7EB),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            nomes[idx],
                            style: TextStyle(
                              color: isSelecionado
                                  ? Colors.white
                                  : const Color(0xFF2563EB), // azul vivo
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 28,
                            height: 28,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelecionado
                                  ? Colors.white
                                  : const Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              data.day.toString().padLeft(2, '0'),
                              style: TextStyle(
                                color: isSelecionado
                                    ? const Color(0xFF2563EB)
                                    : const Color(0xFF64748B),
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                     );
                  }),
              ),
            ),
            Expanded(
              child:
                  agendamentos.isEmpty
                      ? const SizedBox.shrink() // Não mostra nada se não houver aula
                      : _buildAgendaList(agendamentos),
            ),
          ],
        );
      },
    );
  }

  // Widget auxiliar para o dia da semana
  Widget _buildDiaSemana(String letra, String nome, bool isSelecionado) {
    final hoje = DateTime.now();
    final dias = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex'];
    final idxHoje = hoje.weekday - 1; // segunda = 0
    final idx = dias.indexOf(nome);
    final bool isHoje = idx == idxHoje;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelecionado ? const Color(0xFF2563EB) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (isSelecionado)
              BoxShadow(
                color: const Color(0xFF2563EB).withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
          border: Border.all(
            color: isSelecionado
                ? const Color(0xFF2563EB)
                : const Color(0xFFE5E7EB),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Text(
              letra,
              style: TextStyle(
                color: isSelecionado ? Colors.white : const Color(0xFF2563EB),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              nome,
              style: TextStyle(
                color: isSelecionado ? Colors.white : const Color(0xFF64748B),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyAgenda() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.1),
                  Colors.purple.withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_available_rounded,
              size: 80,
              color: Colors.blue[300],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Nenhuma aula hoje',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Aproveite seu tempo livre para estudar\nou relaxar!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgendaList(List<Map<String, dynamic>> agendamentos) {
    return ListView.builder(
      itemCount: agendamentos.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, idx) {
        final ag = agendamentos[idx];
        final sala = ag['salas']?['numero_sala']?.toString() ?? '-';
        final curso = ag['cursos']?['curso'] ?? '-';
        final materia = ag['materias']?['nome'] ?? '-';
        final professor = ag['professores']?['nome_professor'] ?? '-';
        final periodo = ag['periodo']?.toString() ?? '-';

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            // Adicione a borda circular azul clara
            border: Border.all(
              color: const Color(0xFF60A5FA), // azul claro
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Círculo decorativo azul claro atrás do ícone
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0ECFF), // azul bem claro
                            shape: BoxShape.circle,
                          ),
                        ),
                        // Ícone com gradiente azul
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2563EB), Color(0xFF60A5FA)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.school_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        materia,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.person_rounded,
                      color: Color(0xFF2563EB),
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      professor,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        Icons.access_time_rounded,
                        'Início',
                        ag['hora_inicio'] ?? '-',
                        const Color(0xFF2563EB), // azul vivo
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoItem(
                        Icons.schedule_rounded,
                        'Fim',
                        ag['hora_fim'] ?? '-',
                        const Color(0xFF60A5FA), // azul claro
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        Icons.meeting_room_rounded,
                        'Sala',
                        sala,
                        const Color(0xFF6366F1), // azul roxo
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoItem(
                        Icons.book_rounded,
                        'Curso',
                        curso,
                        const Color(0xFF1D4ED8), // azul escuro
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Período: $periodo',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
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

  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildHomePage(),
      buildAgendaPage(),
      const PerfilPage(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body:
          _nomeUsuario == 'Carregando...'
              ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                ),
              )
              : pages[_indiceAtual],
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

  Widget buildHomePage() {
    final noticias = [
      {
        'img':
            'assets/images/semanacademica.jfif',
        'title': 'Semana Acadêmica',
        'desc': 'Participe das palestras e workshops de 12 a 16 de junho!',
      },
      {
        'img':
            'assets/images/cantina.jfif',
        'title': 'Novo Restaurante Universitário',
        'desc': 'Inauguração nesta sexta-feira, às 11h.',
      },
      {
        'img':
            'assets/images/edital.jfif',
        'title': 'Edital de Bolsas',
        'desc': 'Inscrições abertas até 20/06 para bolsas de pesquisa.',
      },
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Hero com gradiente moderno
          Container(
            height: 320,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2563EB), // azul vivo
                  Color(0xFF1D4ED8), // azul escuro
                  Color(0xFF60A5FA), // azul claro
                ],
              ),
            ),
            child: Stack(
              children: [
                // Elementos decorativos
                Positioned(
                  top: -100,
                  right: -50,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -80,
                  left: -40,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Conteúdo principal
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cabeçalho com notificação
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Olá! 👋',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _nomeUsuario,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.notifications_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Badge do semestre
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.calendar_month_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Semestre Outono 2025',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // Status/Localização
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.location_on_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Campus Principal',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Universidade Federal',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Ícones de Acesso Rápido
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: _buildQuickAccessButton(
                    Icons.calendar_today_rounded,
                    'Próximas\nAulas',
                    const Color(0xFF2563EB), // azul vivo
                    () {
                      setState(() {
                        _indiceAtual = 1;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildQuickAccessButton(
                    Icons.meeting_room_rounded,
                    'Localizar\nSala',
                    const Color(0xFF10B981),
                    () {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildQuickAccessButton(
                    Icons.map_rounded,
                    'Mapa do\nCampus',
                    const Color(0xFFF59E0B),
                    () {},
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Card da próxima aula
          _buildProximaAulaCard(),

          const SizedBox(height: 32),

          // Carrossel nativo de notícias
          SizedBox(
            height: 180,
            child: PageView.builder(
              itemCount: noticias.length,
              controller: _carrosselController, // Use o controller de instância
              itemBuilder: (context, index) {
                final noticia = noticias[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(noticia['img']!, fit: BoxFit.cover),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          bottom: 28,
                          right: 16,
                          child: Text(
                            noticia['title']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(color: Colors.black54, blurRadius: 8),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          bottom: 10,
                          right: 16,
                          child: Text(
                            noticia['desc']!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 32),

          // Seção de avisos importantes
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7043).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.campaign_rounded,
                        color: Color(0xFFFF7043),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Avisos Importantes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildAvisoCard(
                  'Sistema de Salas Atualizado',
                  'Novas funcionalidades de localização disponíveis.',
                  Icons.system_update_rounded,
                  const Color(0xFF2563EB),
                ),
                _buildAvisoCard(
                  'Manutenção Programada',
                  'Domingo das 2h às 6h - Sistema indisponível.',
                  Icons.build_rounded,
                  const Color(0xFFF59E0B),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildQuickAccessButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, size: 28, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      )
       );
  }

  Widget _buildProximaAulaCard() {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _buscarProximaAulaHoje(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF22C55E)),
                ),
              ),
            ),
          );
        }

        final ag = snapshot.data;
        if (ag == null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue[100]!, Colors.blue[50]!],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.event_available_rounded,
                      color: Colors.blue[600],
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sem aulas hoje! 🎉',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Aproveite para descansar ou estudar em casa.',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Se existe próxima aula, exibe o card com as informações
        final sala = ag['salas']?['numero_sala']?.toString() ?? '-';
        final curso = ag['cursos']?['curso'] ?? '-';
        final periodo = ag['cursos']?['periodo'] ?? '-';
        final semestre = ag['cursos']?['semestre'] ?? '-';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFDBEAFE), Color(0xFF60A5FA)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB).withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: Color(0xFF2563EB),
                    size: 40,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ag['aula_periodo'] ?? '-',
                        style: const TextStyle(
                          color: Color(0xFF1E293B),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Início: ${ag['hora_inicio'] ?? '-'}  |  Fim: ${ag['hora_fim'] ?? '-'}',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sala: $sala  •  Curso: $curso',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Período: $periodo  •  Semestre: $semestre',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
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

  Widget _buildAvisoCard(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16),
          ),
        ],
      ),
    );
  }

  String _formatarDataHoje() {
    final hoje = DateTime.now();
    final diasDaSemana = [
      'Domingo',
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado',
    ];
    final diaDaSemana = diasDaSemana[hoje.weekday % 7];
    final dia = hoje.day.toString().padLeft(2, '0');
    final mes = hoje.month.toString().padLeft(2, '0');
    final ano = hoje.year;

    return '$diaDaSemana, $dia/$mes/$ano';
  }
}