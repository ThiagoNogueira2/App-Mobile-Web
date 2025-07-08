import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/advanced_cache_service.dart';
import '../services/api_service.dart';
import '../widgets/skeleton_loading.dart';
import 'package:projectflutter/utils/app_colors.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  int _diaSemanaSelecionado = DateTime.now().weekday.clamp(1, 5) - 1;
  final _advancedCache = AdvancedCacheService();

  Future<List<Map<String, dynamic>>> _buscarAgendamentosPorDia(
    int diaSemana,
  ) async {
    final user = Supabase.instance.client.auth.currentUser;
    final cursoId = user?.userMetadata?['curso_id']?.toString();
    if (cursoId == null) return [];
    final hoje = DateTime.now();
    final data = hoje.subtract(Duration(days: hoje.weekday - 1 - diaSemana));
    return await ApiService.getAgendamentosPorDia(cursoId, data);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _buscarAgendamentosPorDia(_diaSemanaSelecionado),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              // Header skeleton
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
                  color: Colors.grey[200],
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF6366F1),
                    ),
                  ),
                ),
              ),
              // Skeleton para os dias da semana
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    5,
                    (index) => const SkeletonLoading(
                      width: 50,
                      height: 40,
                      borderRadius: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Skeleton para a lista de aulas
              Column(
                children: List.generate(
                  3,
                  (index) => const SkeletonCompactCard(height: 70),
                ),
              ),
            ],
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
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primaryDark,
                    AppColors.primaryLight,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0xFF2563EB,
                    ).withOpacity(0.18), // azul vivo
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
                        color: Colors.white.withOpacity(0.25),
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
                        color: Colors.white.withOpacity(0.18),
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
                        color:
                            isSelecionado
                                ? const Color(0xFF44A301) // verde
                                : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          if (isSelecionado)
                            BoxShadow(
                              color: const Color(0xFF44A301).withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                        ],
                        border: Border.all(
                          color:
                              isSelecionado
                                  ? const Color(0xFF44A301)
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
                              color:
                                  isSelecionado
                                      ? Colors.white
                                      : const Color(0xFF44A301), // verde
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
                              color:
                                  isSelecionado
                                      ? Colors.white
                                      : const Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              data.day.toString().padLeft(2, '0'),
                              style: TextStyle(
                                color:
                                    isSelecionado
                                        ? const Color(0xFF44A301)
                                        : const Color(0xFF64748B),
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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

  Widget _buildAgendaList(List<Map<String, dynamic>> agendamentos) {
    // Ordena pelo horário de início (hora_inicio) para garantir que o primeiro horário apareça primeiro
    agendamentos.sort((a, b) {
      final aTime = a['hora_inicio'] ?? '';
      final bTime = b['hora_inicio'] ?? '';
      return aTime.compareTo(bTime);
    });
    print('AGENDAMENTOS RECEBIDOS: $agendamentos');
    return ListView.builder(
      itemCount: agendamentos.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, idx) {
        final ag = agendamentos[idx];
        return Column(
          children: [
            // Remover Divider azul entre os cards, manter apenas o card
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white, // fundo sempre branco
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      ag['tipo_agendamento'] == 'E'
                          ? const Color(0xFFF59E0B) // amarelo
                          : ag['tipo_agendamento'] == 'M'
                          ? const Color(0xFFEF4444) // vermelho
                          : Color(0xFF44A301), // verde
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF64748B).withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: const Color(0xFF64748B).withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tipo do agendamento
                    if (ag['tipo_agendamento'] == 'E' &&
                        ag['nome_evento'] != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF59E0B),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Evento',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      ag['nome_evento'],
                                      style: const TextStyle(
                                        color: Color(0xFFB45309),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Removido o Row duplicado de sala e horários
                          ],
                        ),
                      )
                    else
                      Row(
                        children: [
                          Icon(
                            ag['tipo_agendamento'] == 'M'
                                ? Icons.assignment_turned_in_rounded
                                : Icons.class_,
                            color:
                                ag['tipo_agendamento'] == 'M'
                                    ? Color(0xFFEF4444)
                                    : Color(0xFF44A301),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            ag['tipo_agendamento'] == 'M' ? 'Prova' : 'Aula',
                            style: TextStyle(
                              color:
                                  ag['tipo_agendamento'] == 'M'
                                      ? Color(0xFFEF4444)
                                      : Color(0xFF44A301),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    // Primeira linha: SALA | INICIO | FIM (títulos)
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'SALA',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'INÍCIO',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              letterSpacing: 0.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'FIM',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              letterSpacing: 0.2,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    // Segunda linha: valores
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF2563EB,
                                  ).withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.meeting_room_rounded,
                                  color: Color(0xFF2563EB),
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                ag['salas']?['numero_sala']?.toString() ?? '-',
                                style: const TextStyle(
                                  color: Color(0xFF2563EB),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF22C55E,
                                  ).withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.schedule_rounded,
                                  color: Color(0xFF22C55E),
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                ag['hora_inicio'] ?? '--:--',
                                style: const TextStyle(
                                  color: Color(0xFF1E293B),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFF59E0B,
                                  ).withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.schedule_rounded,
                                  color: Color(0xFFF59E0B),
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                ag['hora_fim'] ?? '--:--',
                                style: const TextStyle(
                                  color: Color(0xFF1E293B),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // CURSO destacado
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withOpacity(0.07),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.book_rounded,
                            color: Color(0xFF2563EB),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              ag['cursos']?['curso'] ?? 'Curso não informado',
                              style: const TextStyle(
                                color: Color(0xFF1E293B),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Matéria e Professor em linha, ambos destacados
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF60A5FA).withOpacity(0.13),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.school_rounded,
                                  color: Color(0xFF2563EB),
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    ag['materias']?['nome'] ??
                                        'Matéria não informada',
                                    style: const TextStyle(
                                      color: Color(0xFF2563EB),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6366F1).withOpacity(0.13),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.person_rounded,
                                  color: Color(0xFF6366F1),
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    ag['professores']?['nome_professor'] ??
                                        'Professor não informado',
                                    style: const TextStyle(
                                      color: Color(0xFF6366F1),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
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
