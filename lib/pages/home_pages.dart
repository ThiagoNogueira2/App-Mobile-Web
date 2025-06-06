import 'package:flutter/material.dart';
import 'package:projectflutter/pages/perfil_page.dart'; // Importação correta
import 'package:supabase_flutter/supabase_flutter.dart';

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
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
            ),
          );
        }
        final agendamentos = snapshot.data ?? [];
        return Column(
          children: [
            // Imagem decorativa no topo da agenda
            Container(
              width: double.infinity,
              height: 280,
              margin: const EdgeInsets.only(
                bottom: 32,
                left: 24,
                right: 24,
                top: 8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: const DecorationImage(
                  image: AssetImage('assets/images/perfil.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child:
                  agendamentos.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_available,
                              size: 80,
                              color: Colors.blue[200],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhuma aula para hoje',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              'Aproveite seu tempo livre!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount:
                            agendamentos.length > 2 ? 2 : agendamentos.length,
                        padding: const EdgeInsets.all(24),
                        itemBuilder: (context, idx) {
                          final ag = agendamentos[idx];
                          final sala =
                              ag['salas']?['numero_sala']?.toString() ?? '-';
                          final curso = ag['cursos']?['curso'] ?? '-';
                          final periodo = ag['cursos']?['periodo'] ?? '-';
                          final semestre = ag['cursos']?['semestre'] ?? '-';
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF3B82F6,
                                  ).withOpacity(0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header do card
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF3B82F6),
                                              Color(0xFF1E40AF),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.school,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          ag['aula_periodo'] ?? '-',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  // Informações em grid
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildInfoItem(
                                          Icons.access_time_rounded,
                                          'Início',
                                          ag['hora_inicio'] ?? '-',
                                          const Color(0xFF10B981),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: _buildInfoItem(
                                          Icons.schedule,
                                          'Fim',
                                          ag['hora_fim'] ?? '-',
                                          const Color(0xFFF59E0B),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildInfoItem(
                                          Icons.meeting_room_rounded,
                                          'Sala',
                                          sala,
                                          const Color(0xFF8B5CF6),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: _buildInfoItem(
                                          Icons.book_rounded,
                                          'Curso',
                                          curso,
                                          const Color(0xFF3B82F6),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // Informações adicionais
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
                                        Container(
                                          width: 1,
                                          height: 16,
                                          color: const Color(0xFFE2E8F0),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            'Semestre: $semestre',
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
                      ),
            ),
          ],
        );
      },
    );
  }

  // Adiciona o _buildInfoItem para uso local
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
    final pages = [buildHomePage(), buildAgendaPage(), const PerfilPage()];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body:
          _nomeUsuario == 'Carregando...'
              ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
                ),
              )
              : pages[_indiceAtual],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
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
          selectedItemColor: const Color(0xFF1976D2),
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header moderno com imagem de fundo cobrindo 100%
          Container(
            height: 280,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              image: const DecorationImage(
                image: AssetImage('assets/images/welcome.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Gradiente sobre a imagem
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xCC1976D2), // semi-transparente
                        Color(0xCC1565C0),
                        Color(0xCC0D47A1),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header com notificação
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Olá! 👋',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.notifications_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Nome do usuário
                        Text(
                          _nomeUsuario,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Semestre Outono 2025',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Avatar
                        Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                color: Colors.white,
                                size: 32,
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickAccessButton(
                  Icons.calendar_today_rounded,
                  'Agenda',
                  const Color(0xFF42A5F5),
                ),
                _buildQuickAccessButton(
                  Icons.book_rounded,
                  'Disciplinas',
                  const Color(0xFF66BB6A),
                ),
                _buildQuickAccessButton(
                  Icons.grade_rounded,
                  'Notas',
                  const Color(0xFFFF7043),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Cartão de próxima aula
          _buildProximaAulaCard(),

          const SizedBox(height: 32),

          // Seções
          _buildSectionHeader('Disciplinas da Semana', Icons.school_rounded),
          const SizedBox(height: 16),
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

          const SizedBox(height: 32),

          _buildSectionHeader('Avisos Recentes', Icons.campaign_rounded),
          const SizedBox(height: 16),
          _buildAvisoCard(
            'Palestra sobre Carreiras na Tecnologia',
            'Quinta-feira às 18h no auditório.',
          ),
          _buildAvisoCard(
            'Atualização no sistema acadêmico',
            'Entre os dias 10 e 12 o sistema ficará fora do ar para manutenção.',
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildQuickAccessButton(IconData icon, String label, Color color) {
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
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, size: 28, color: color),
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
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
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.event_available_rounded,
                      color: Colors.blue[600],
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sem aulas hoje',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Aproveite para descansar!',
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
        final disciplina = ag['aula_periodo'] ?? '-';
        final inicio = ag['hora_inicio'] ?? '-';
        final fim = ag['hora_fim'] ?? '-';
        final sala = ag['salas']?['numero_sala']?.toString() ?? '-';
        final curso = ag['cursos']?['curso'] ?? '-';
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'PRÓXIMA AULA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.meeting_room_rounded,
                            color: Color(0xFF1976D2),
                            size: 20,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            sala,
                            style: const TextStyle(
                              color: Color(0xFF1976D2),
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  disciplina,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildTimeChip(Icons.play_arrow_rounded, inicio),
                    const SizedBox(width: 12),
                    _buildTimeChip(Icons.stop_rounded, fim),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  curso,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimeChip(IconData icon, String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF1976D2), size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2C3E50),
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisciplinaCard(String titulo, String horario, String sala) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1976D2).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.book_rounded,
                      color: Color(0xFF1976D2),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titulo,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$horario • $sala',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey[400],
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvisoCard(String titulo, String descricao) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7043).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.campaign_rounded,
                      color: Color(0xFFFF7043),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titulo,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          descricao,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey[400],
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
