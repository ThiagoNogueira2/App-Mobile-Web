import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  String nome = '';
  String email = '';
  String curso = '';
  String semestre = '';
  String periodo = '';
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarDadosPerfil();
  }

  Future<void> carregarDadosPerfil() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final data =
        await supabase
            .from('users')
            .select('nome, email, curso, semestre, periodo')
            .eq('id', user.id) // ou 'uid' se sua tabela usar 'uid'
            .single();

    setState(() {
      nome = data['nome'] ?? '';
      email = data['email'] ?? '';
      curso = data['curso'] ?? '';
      semestre = data['semestre']?.toString() ?? '';
      periodo = data['periodo'] ?? '';
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil'), backgroundColor: Colors.blue),
      body:
          carregando
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blueAccent,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text('Nome: $nome', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 12),
                    Text(
                      'E-mail: $email',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    Text('Curso: $curso', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 12),
                    Text(
                      'Semestre: $semestre',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Período: $periodo',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
    );
  }
}
