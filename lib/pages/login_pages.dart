import 'package:flutter/material.dart';
import 'package:projectflutter/auth/auth_service.dart';
import 'package:projectflutter/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await authService.signInWithEmailPassword(email, password);
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
          
          // Imagem de fundo
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

                  // Título "Sign in"
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
                          text: "in",
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
                          const SizedBox(height: 180),

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

                          const SizedBox(height: 30),

                          // Campo Senha
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Forgot your password?",
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


                  // Botões

                  const SizedBox(height: 140), // espaço maior antes dos botões
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Sign Up - Verde
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
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

                      // Login - Preto

                      OutlinedButton(
                        onPressed: login,
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
                          child: Text("Login"),
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
