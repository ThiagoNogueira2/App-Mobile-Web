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

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _cursoController = TextEditingController();
  final _semestreController = TextEditingController();
  final _periodoController = TextEditingController();

  final bool _emailError = false;
  final bool _passwordError = false;
  final bool _confirmPasswordError = false;

  void signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final curso = _cursoController.text.trim();
    final semestreText = _semestreController.text.trim();
    final periodo = _periodoController.text.trim();

    // Validando se os campos estão preenchidos corretamente
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || curso.isEmpty || semestreText.isEmpty || periodo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos corretamente.")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("As senhas não coincidem")),
      );
      return;
    }

    int? semestre;
    try {
      semestre = int.parse(semestreText);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semestre precisa ser um número válido.")),
      );
      return;
    }

    // Chamando a função de registro
    try {
      final response = await authService.signUpWithEmailPassword(
        email,
        password,
        curso: curso,
        semestre: semestre,
        periodo: periodo,
      );

      final user = response.user ?? Supabase.instance.client.auth.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erro: usuário não retornado. Verifique se o e-mail exige confirmação."),
          ),
        );
        return;
      }

      // Registro bem-sucedido
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registro efetuado com sucesso!")),
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao cadastrar: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

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
            height: height,
            width: width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/faculdade1.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: height,
            width: width,
            color: Colors.black.withOpacity(0.4),
          ),
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.04),
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
                    SizedBox(height: height * 0.16),
                    Padding(
                      padding: EdgeInsets.only(left: width * 0.2),
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
                        width: width > 600 ? 400 : width * 0.9,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: height * 0.06),
                            _buildTextField(_emailController, 'Email', error: _emailError),
                            const SizedBox(height: 18),
                            _buildTextField(_passwordController, 'Password', obscure: true, error: _passwordError),
                            const SizedBox(height: 18),
                            _buildTextField(_confirmPasswordController, 'Confirm Password', obscure: true, error: _confirmPasswordError),
                            const SizedBox(height: 18),
                            _buildTextField(_cursoController, 'Curso'),
                            const SizedBox(height: 18),
                            _buildTextField(_semestreController, 'Semestre'),
                            const SizedBox(height: 18),
                            _buildTextField(_periodoController, 'Período'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildButton("Voltar", Colors.black, Colors.white, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        }),
                        _buildButton("Sign up", Colors.green, Colors.green, signUp),
                      ],
                    ),
                    SizedBox(height: height * 0.05),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool obscure = false, bool error = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: error ? Colors.red : Colors.white),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: error ? Colors.red : Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color bg, Color border, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: bg,
        side: BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Text(text),
      ),
    );
  }
}
