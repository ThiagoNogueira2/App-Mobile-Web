import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  Map<String, dynamic>? userData;
  bool carregando = true;
  bool editando = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cursoController = TextEditingController();
  final TextEditingController _semestreController = TextEditingController();
  final TextEditingController _periodoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    carregarDadosPerfil();
  }

  Future<void> carregarDadosPerfil() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    print('ID do usuário autenticado: \\${user?.id}');
    if (user == null) {
      setState(() {
        carregando = false;
        userData = null;
      });
      return;
    }
    try {
      final data =
          await supabase
              .from('users')
              .select('*')
              .eq('id', user.id)
              .maybeSingle();
      print('Resultado da consulta users: \\${data}');
      setState(() {
        userData = data;
        carregando = false;
      });
    } catch (e) {
      print('Erro ao buscar perfil: \\${e}');
      setState(() {
        carregando = false;
        userData = null;
      });
    }
  }

  void preencherControllers() {
    _nomeController.text = userData?['nome'] ?? '';
    _emailController.text = userData?['email'] ?? '';
    _cursoController.text = userData?['curso'] ?? '';
    _semestreController.text = userData?['semestre']?.toString() ?? '';
    _periodoController.text = userData?['periodo'] ?? '';
  }

  Future<void> atualizarPerfil() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) return;
    setState(() {
      carregando = true;
    });
    try {
      await supabase
          .from('users')
          .update({
            'nome': _nomeController.text.trim(),
            'email': _emailController.text.trim(),
            'curso': _cursoController.text.trim(),
            'semestre': _semestreController.text.trim(),
            'periodo': _periodoController.text.trim(),
          })
          .eq('id', user.id);
      await carregarDadosPerfil();
      setState(() {
        editando = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );
    } catch (e) {
      setState(() {
        carregando = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao atualizar perfil: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!editando && userData != null) preencherControllers();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Usuário'),
        backgroundColor: Colors.blue,
        actions: [
          if (!editando && userData != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  editando = true;
                });
              },
            ),
        ],
      ),
      body:
          carregando
              ? const Center(child: CircularProgressIndicator())
              : userData == null
              ? const Center(
                child: Text(
                  'Nenhum dado de perfil encontrado ou usuário não autenticado.',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child:
                      editando
                          ? Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.blueAccent,
                                    child: Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Card(
                                    elevation: 6,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 24,
                                        horizontal: 28,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildEditField(
                                            _nomeController,
                                            'Nome',
                                          ),
                                          _buildEditField(
                                            _emailController,
                                            'E-mail',
                                            email: true,
                                          ),
                                          _buildEditField(
                                            _cursoController,
                                            'Curso',
                                          ),
                                          _buildEditField(
                                            _semestreController,
                                            'Semestre',
                                            number: true,
                                          ),
                                          _buildEditField(
                                            _periodoController,
                                            'Período',
                                          ),
                                          const SizedBox(height: 24),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    editando = false;
                                                  });
                                                },
                                                child: const Text('Cancelar'),
                                              ),
                                              const SizedBox(width: 16),
                                              ElevatedButton(
                                                onPressed: () {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    atualizarPerfil();
                                                  }
                                                },
                                                child: const Text('Salvar'),
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
                          )
                          : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.blueAccent,
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Card(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 24,
                                    horizontal: 28,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildInfoRow(
                                        Icons.person,
                                        'Nome',
                                        userData?['nome'],
                                      ),
                                      _buildInfoRow(
                                        Icons.email,
                                        'E-mail',
                                        userData?['email'],
                                      ),
                                      _buildInfoRow(
                                        Icons.school,
                                        'Curso',
                                        userData?['curso'],
                                      ),
                                      _buildInfoRow(
                                        Icons.calendar_today,
                                        'Semestre',
                                        userData?['semestre']?.toString(),
                                      ),
                                      _buildInfoRow(
                                        Icons.access_time,
                                        'Período',
                                        userData?['periodo'],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                ),
              ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 10),
          Text('$label: ${value ?? '-'}', style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildEditField(
    TextEditingController controller,
    String label, {
    bool email = false,
    bool number = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType:
            number
                ? TextInputType.number
                : (email ? TextInputType.emailAddress : TextInputType.text),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Preencha o campo';
          if (email && !value.contains('@')) return 'E-mail inválido';
          if (number && int.tryParse(value) == null) return 'Somente números';
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
