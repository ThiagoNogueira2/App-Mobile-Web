import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BuscarSalaPage extends StatefulWidget {
  const BuscarSalaPage({super.key});

  @override
  State<BuscarSalaPage> createState() => _BuscarSalaPageState();
}

class _BuscarSalaPageState extends State<BuscarSalaPage> {
  final int _selectedIndex = 1;
  String _diaSelecionado = _diaSemanaHoje();
  static const diasSemana = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex'];

  static String _diaSemanaHoje() {
    final hoje = DateTime.now().weekday;
    switch (hoje) {
      case 1:
        return 'Seg';
      case 2:
        return 'Ter';
      case 3:
        return 'Qua';
      case 4:
        return 'Qui';
      case 5:
        return 'Sex';
      default:
        return 'Seg';
    }
  }

  bool isLoading = false;
  List<Map<String, dynamic>> agendamentos = [];

  Future<void> _carregarAgendamentosPorDia(String diaSemana) async {
    setState(() => isLoading = true);
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      if (user == null) {
        setState(() => agendamentos = []);
        return;
      }
      final userData =
          await supabase
              .from('users')
              .select('curso_id')
              .eq('id', user.id)
              .maybeSingle();
      final cursoId = userData?['curso_id'];
      if (cursoId == null) {
        setState(() => agendamentos = []);
        return;
      }
      // Descobre a data da próxima ocorrência do dia selecionado
      final hoje = DateTime.now();
      int targetWeekday = diasSemana.indexOf(diaSemana) + 1;
      int diff = (targetWeekday - hoje.weekday) % 7;
      final dataSelecionada = hoje.add(Duration(days: diff));
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
            cursos(id, curso, semestre, periodo),
            salas(id, numero_sala)
          ''')
          .eq('dia', diaStr)
          .eq('curso_id', cursoId)
          .order('hora_inicio');
      setState(() => agendamentos = List<Map<String, dynamic>>.from(response));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar agendamentos: $e'),
          backgroundColor: const Color(0xFF1E3A8A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      setState(() => agendamentos = []);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _carregarAgendamentosPorDia(_diaSelecionado);
  }

  void _onNavTap(int index) {
    if (index == 0) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else if (index == 2) {
      Navigator.of(context).pushReplacementNamed('/perfil');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Agenda de Aulas',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E3A8A),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Header com gradiente sutil
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFEBF4FF), Color(0xFFF8FAFC)],
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Seletor de dia da semana moderno
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        diasSemana.map((dia) {
                          final selecionado = _diaSelecionado == dia;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _diaSelecionado = dia;
                                });
                                _carregarAgendamentosPorDia(dia);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  gradient:
                                      selecionado
                                          ? const LinearGradient(
                                            colors: [
                                              Color(0xFF3B82F6),
                                              Color(0xFF1E40AF),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                          : null,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  dia,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        selecionado
                                            ? Colors.white
                                            : const Color(0xFF64748B),
                                    fontWeight:
                                        selecionado
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          // Lista de agendamentos
          Expanded(
            child:
                isLoading
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF3B82F6,
                                  ).withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF3B82F6),
                              ),
                              strokeWidth: 3,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Carregando aulas...',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                    : agendamentos.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEBF4FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.event_busy,
                              size: 48,
                              color: Color(0xFF3B82F6),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Nenhuma aula cadastrada',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'para este dia.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount:
                          agendamentos.length > 2 ? 2 : agendamentos.length,
                      padding: const EdgeInsets.all(20),
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
                                        borderRadius: BorderRadius.circular(12),
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
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onNavTap,
          selectedItemColor: const Color(0xFF3B82F6),
          unselectedItemColor: const Color(0xFF94A3B8),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule_rounded),
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
}
