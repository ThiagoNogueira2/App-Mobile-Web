import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _courseController = TextEditingController();
  final _semesterController = TextEditingController();
  final _periodController = TextEditingController();
  bool _isButtonDisabled = false;

  Future<void> _signUp() async {
    setState(() {
      _isButtonDisabled = true;
    });

    // Registra o usuário no Supabase
    final response = await Supabase.instance.client.auth.signUp(
      _emailController.text,
      _passwordController.text,
    );

    if (response.error != null) {
      // Verifica o erro do cadastro
      if (response.error!.message.contains('email rate limit exceeded')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Limite de tentativas atingido. Tente novamente mais tarde.',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao criar usuário: ${response.error!.message}'),
          ),
        );
      }
      setState(() {
        _isButtonDisabled = false;
      });
      return;
    }

    // Usuário criado com sucesso
    final user = response.user;

    if (user != null) {
      final userId = user.id;

      // Armazene os dados adicionais na tabela "users" no Supabase

      //Tabela users feita no supabase, criado no meu e-mail
      final insertResponse =
          await Supabase.instance.client.from('users').insert([
            {
              'user_id': userId,
              'course': _courseController.text,
              'semester': _semesterController.text,
              'period': _periodController.text,
            },
          ]).execute();

      if (insertResponse.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao salvar dados adicionais: ${insertResponse.error!.message}',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário registrado com sucesso!')),
        );
      }
    }

    setState(() {
      _isButtonDisabled = false;
    });
  }

  // tabelas de verificação criadas para coletar as informações no supabase
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Senha'),
            ),
            TextField(
              controller: _courseController,
              decoration: InputDecoration(labelText: 'Curso'),
            ),
            TextField(
              controller: _semesterController,
              decoration: InputDecoration(labelText: 'Semestre'),
            ),
            TextField(
              controller: _periodController,
              decoration: InputDecoration(labelText: 'Período'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isButtonDisabled ? null : _signUp,
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
