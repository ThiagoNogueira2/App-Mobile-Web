import 'dart:ui';
import 'package:flutter/material.dart';

class BuscarSalaPage extends StatefulWidget {
  const BuscarSalaPage({super.key});

  @override
  State<BuscarSalaPage> createState() => _BuscarSalaPageState();
}

class _BuscarSalaPageState extends State<BuscarSalaPage> {
  final List<Map<String, dynamic>> turmas = [
    {
      'nome': 'Engenharia de Software',
      'turma': 'A',
      'periodo': 'Noturno',
      'horario': 'Segunda a Sexta - 19:00 às 22:30',
      'aulas': [
        {'dia': 'Segunda', 'disciplina': 'Algoritmos', 'horario': '19:00'},
        {'dia': 'Terça', 'disciplina': 'Banco de Dados', 'horario': '19:00'},
        {
          'dia': 'Quarta',
          'disciplina': 'Engenharia de Software',
          'horario': '19:00',
        },
        {'dia': 'Quinta', 'disciplina': 'Redes', 'horario': '19:00'},
        {
          'dia': 'Sexta',
          'disciplina': 'Projeto Integrador',
          'horario': '19:00',
        },
      ],
    },
    {
      'nome': 'Psicologia Social',
      'turma': 'B',
      'periodo': 'Matutino',
      'horario': 'Segunda a Sexta - 08:00 às 11:30',
      'aulas': [
        {
          'dia': 'Segunda',
          'disciplina': 'Psicologia Geral',
          'horario': '08:00',
        },
        {'dia': 'Terça', 'disciplina': 'Psicologia Social', 'horario': '08:00'},
        {'dia': 'Quarta', 'disciplina': 'Neurociência', 'horario': '08:00'},
        {
          'dia': 'Quinta',
          'disciplina': 'Psicologia do Desenvolvimento',
          'horario': '08:00',
        },
        {
          'dia': 'Sexta',
          'disciplina': 'Ética Profissional',
          'horario': '08:00',
        },
      ],
    },
    {
      'nome': 'Filosofia Moderna',
      'turma': 'C',
      'periodo': 'Vespertino',
      'horario': 'Segunda a Sexta - 15:00 às 18:30',
      'aulas': [
        {
          'dia': 'Segunda',
          'disciplina': 'Filosofia Antiga',
          'horario': '15:00',
        },
        {'dia': 'Terça', 'disciplina': 'Filosofia Moderna', 'horario': '15:00'},
        {'dia': 'Quarta', 'disciplina': 'Lógica', 'horario': '15:00'},
        {'dia': 'Quinta', 'disciplina': 'Ética', 'horario': '15:00'},
        {'dia': 'Sexta', 'disciplina': 'Estética', 'horario': '15:00'},
      ],
    },
  ];

  String search = '';
  int _selectedIndex = 1; // Agenda como selecionado
  String _periodoSelecionado = 'Todos';

  List<String> get periodos => [
    'Todos',
    ...{for (var t in turmas) t['periodo']},
  ];

  void _onNavTap(int index) {
    if (index == 0) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else if (index == 2) {
      Navigator.of(context).pushReplacementNamed('/perfil');
    }
  }

  @override
  Widget build(BuildContext context) {
    final resultados =
        turmas.where((t) {
          final matchNome = t['nome'].toLowerCase().contains(
            search.toLowerCase(),
          );
          final matchPeriodo =
              _periodoSelecionado == 'Todos' ||
              t['periodo'] == _periodoSelecionado;
          return matchNome && matchPeriodo;
        }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // Banner com imagem escurecida e saudação
          Stack(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/ensalamento.jfif',
                    ), // Troque para sua imagem
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(32),
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                  child: Container(color: Colors.black.withOpacity(0.45)),
                ),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.8),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.blue),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              Positioned(
                left: 24,
                bottom: 24,
                child: Row(
                  children: [
                    const Icon(Icons.class_, color: Colors.white, size: 36),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Olá, estudante!',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Encontre sua turma',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Campo de busca e filtro
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(16),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar turma...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) => setState(() => search = value),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _periodoSelecionado,
                  borderRadius: BorderRadius.circular(12),
                  underline: const SizedBox(),
                  items:
                      periodos
                          .map(
                            (p) => DropdownMenuItem(value: p, child: Text(p)),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null)
                      setState(() => _periodoSelecionado = value);
                  },
                ),
              ],
            ),
          ),
          // Lista de turmas
          Expanded(
            child:
                resultados.isEmpty
                    ? const Center(
                      child: Text(
                        'Nenhuma turma encontrada.',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: resultados.length,
                      itemBuilder: (context, index) {
                        final turma = resultados[index];
                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => _buildAulasModal(context, turma),
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.55),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.blue.withOpacity(0.18),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.10),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                    horizontal: 20,
                                  ),
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.blue.shade50,
                                    child: const Icon(
                                      Icons.class_,
                                      color: Colors.blue,
                                      size: 32,
                                    ),
                                  ),
                                  title: Text(
                                    turma['nome'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                      letterSpacing: 0.2,
                                      color: Color(0xFF1A237E),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      'Turma: ${turma['turma']} • ${turma['periodo']}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF374151),
                                      ),
                                    ),
                                  ),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
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

  Widget _buildAulasModal(BuildContext context, Map<String, dynamic> turma) {
    final aulas = turma['aulas'] as List<dynamic>;
    final dias = ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta'];
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      maxChildSize: 0.85,
      minChildSize: 0.4,
      expand: false,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 20,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Text(
                turma['nome'],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                turma['horario'],
                style: const TextStyle(fontSize: 15, color: Colors.blueGrey),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: DefaultTabController(
                  length: dias.length,
                  child: Column(
                    children: [
                      TabBar(
                        isScrollable: true,
                        indicatorColor: Colors.blue,
                        labelColor: Colors.blue,
                        unselectedLabelColor: Colors.grey,
                        tabs: dias.map((d) => Tab(text: d)).toList(),
                      ),
                      Expanded(
                        child: TabBarView(
                          children:
                              dias.map((dia) {
                                final aulasDia =
                                    aulas
                                        .where((a) => a['dia'] == dia)
                                        .toList();
                                if (aulasDia.isEmpty) {
                                  return const Center(
                                    child: Text('Nenhuma aula neste dia.'),
                                  );
                                }
                                return ListView.builder(
                                  controller: controller,
                                  itemCount: aulasDia.length,
                                  itemBuilder: (_, idx) {
                                    final aula = aulasDia[idx];
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.book,
                                          color: Colors.indigo,
                                        ),
                                        title: Text(
                                          aula['disciplina'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Horário: ${aula['horario']}',
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
