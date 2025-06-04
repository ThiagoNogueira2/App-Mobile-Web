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
      final userData = await supabase
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
        SnackBar(content: Text('Erro ao carregar agendamentos: $e')),
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
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          const SizedBox(height: 32),
          // Seletor de dia da semana
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: diasSemana.map((dia) {
                final selecionado = _diaSelecionado == dia;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ChoiceChip(
                    label: Text(dia),
                    selected: selecionado,
                    selectedColor: Colors.blue,
                    labelStyle: TextStyle(
                      color: selecionado ? Colors.white : Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: Colors.white,
                    onSelected: (v) {
                      setState(() {
                        _diaSelecionado = dia;
                      });
                      _carregarAgendamentosPorDia(dia);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          // Lista de agendamentos
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : agendamentos.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma aula cadastrada para este dia.',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: agendamentos.length > 2 ? 2 : agendamentos.length,
                        padding: const EdgeInsets.symmetric(
                          vertical: 24,
                          horizontal: 16,
                        ),
                        itemBuilder: (context, idx) {
                          final ag = agendamentos[idx];
                          final sala = ag['salas']?['numero_sala']?.toString() ?? '-';
                          final curso = ag['cursos']?['curso'] ?? '-';
                          final periodo = ag['cursos']?['periodo'] ?? '-';
                          final semestre = ag['cursos']?['semestre'] ?? '-';
                          return Card(
                            margin: const EdgeInsets.only(bottom: 20),
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
                      ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
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
}
