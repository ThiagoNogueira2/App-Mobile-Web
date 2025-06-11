import 'package:flutter/material.dart';
import 'package:projectflutter/auth/auth_service.dart';
import 'package:projectflutter/pages/login_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authService = AuthService();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  List<Map<String, dynamic>> _cursos = [];
  int? _cursoSelecionadoId;
  bool _carregandoCursos = true;

  @override
  void initState() {
    super.initState();
    _buscarCursos();
  }

  Future<void> _buscarCursos() async {
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('cursos')
        .select('id, curso, semestre, periodo');
    setState(() {
      _cursos = List<Map<String, dynamic>>.from(data);
      _carregandoCursos = false;
    });
  }

  void signUp() async {
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final cursoId = _cursoSelecionadoId;

    final emailValid = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email);

    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        cursoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos corretamente.")),
      );
      return;
    }

    if (!emailValid) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Use um e-mail válido.")));
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Digite a mesma senha.")));
      return;
    }

    try {
      // Busca o nome do curso selecionado para salvar no metadata do Auth
      final curso = _cursos.firstWhere((c) => c['id'] == cursoId);
      final cursoNome = curso['curso'] ?? curso['nome'] ?? '';
      final response = await authService.signUpWithEmailPassword(
        email,
        password,
        nome: nome,
        curso: cursoNome,
        cursoId: cursoId,
      );

      final user = response.user ?? Supabase.instance.client.auth.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Erro: usuário não retornado. Verifique se o e-mail exige confirmação.",
            ),
          ),
        );
        return;
      }

      final supabase = Supabase.instance.client;

      // INSIRA O USUÁRIO NA TABELA USERS COM O CURSO_ID
      await supabase
          .from('users')
          .update({'nome': nome, 'email': email, 'curso_id': cursoId})
          .eq('id', user.id);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao cadastrar: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    final cursoSelecionado = _cursos.firstWhere(
      (c) => c['id'] == _cursoSelecionadoId,
      orElse: () => {},
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/faculdade1.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.4)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Center(
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Campus",
                              style: TextStyle(
                                fontSize: 42,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "M",
                              style: TextStyle(
                                fontSize: 42,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            WidgetSpan(
                              child: Icon(
                                Icons.location_on,
                                color: Colors.green,
                                size: 42,
                              ),
                            ),
                            TextSpan(
                              text: "p",
                              style: TextStyle(
                                fontSize: 42,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                    Padding(
                      padding:
                          largura < 500
                              ? EdgeInsets.zero
                              : const EdgeInsets.only(left: 85),
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Sign ",
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "up",
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: largura < 500 ? largura * 0.98 : 400,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 18),
                            _buildTextField(_nomeController, "Nome"),
                            const SizedBox(height: 18),
                            _buildTextField(_emailController, 'Email'),
                            const SizedBox(height: 18),
                            _buildTextField(
                              _passwordController,
                              'Password',
                              obscure: true,
                            ),
                            const SizedBox(height: 18),
                            _buildTextField(
                              _confirmPasswordController,
                              'Confirm Password',
                              obscure: true,
                            ),
                            const SizedBox(height: 18),
                            _carregandoCursos
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : DropdownButtonFormField<int>(
                                  value: _cursoSelecionadoId,
                                  items:
                                      _cursos
                                          .map(
                                            (curso) => DropdownMenuItem<int>(
                                              value: curso['id'],
                                              child: Text(
                                                curso['curso'] ??
                                                    curso['nome'] ??
                                                    '',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _cursoSelecionadoId = value;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Curso',
                                    labelStyle: TextStyle(color: Colors.white),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                  dropdownColor: Colors.white,
                                ),
                            if (cursoSelecionado.isNotEmpty) ...[
                              const SizedBox(height: 18),
                              Text(
                                'Semestre:  ${cursoSelecionado['semestre'] ?? '-'}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Período:  ${cursoSelecionado['periodo']?.toString() ?? '-'}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black,
                            side: const BorderSide(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            child: Text("Voltar"),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: signUp,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                            side: const BorderSide(color: Colors.green),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            child: Text("Sign up"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
    );
  }
}
