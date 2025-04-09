import 'package:flutter/material.dart';
import 'package:projectflutter/auth/auth_service.dart';
import 'package:projectflutter/pages/login_pages.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authService = AuthService();

  // Text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _cursoController = TextEditingController();
  final _semestreController = TextEditingController();
  final _periodoController = TextEditingController();

  void signUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final curso = _cursoController.text;
    final semestre = _semestreController.text;
    final periodo = _periodoController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    try {
      await authService.signUpWithEmailPassword(
        email,
        password,
        curso: curso,
        semestre: semestre,
        periodo: periodo,
      );
      if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(), // substitua por sua tela principal
        ),
      );
    }
  
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.maybeOf(
          context,
        )?.showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                image: AssetImage('assets/images/faculdade.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Camada escura por cima da imagem
          Container(color: Colors.black.withOpacity(0.4)),

          // Conteúdo
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),

                  // Logo
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

                  const SizedBox(height: 90),

                  // Título "Sign up"
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Sign ",
                              style: TextStyle(
                                fontSize: 38,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        TextSpan(
                          text: "up",
                          style: TextStyle(
                            fontSize: 38,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Center(
                    child: SizedBox(
                      width: 400,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 60),

                          // Campo Email
                          TextField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            ),
                          ),

                          // Campo Senha
                          const SizedBox(height: 18),
                          TextField(
                            controller: _passwordController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            ),
                          ),

                          //Campo Confirmar Senha
                          const SizedBox(height: 18),
                          TextField(
                            controller: _confirmPasswordController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: "Confirm Password",
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            ),
                          ),

                          //Campo Curso
                          const SizedBox(height: 18),
                          TextField(
                            controller: _cursoController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: "Curso",
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            ),
                          ),

                          //Campo Semestre
                          const SizedBox(height: 18),
                          TextField(
                            controller: _semestreController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: "Semestre",
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            ),
                          ),

                          //Campo Período
                          const SizedBox(height: 18),
                          TextField(
                            controller: _periodoController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: "Período",
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 35), // espaço maior antes dos botões
                  // Botões
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Sign Up - Verde
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
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

                      // Sign up
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
        ],
      ),
    );
  }
}
