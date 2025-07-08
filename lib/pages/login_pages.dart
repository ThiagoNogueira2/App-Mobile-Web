import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; //
import 'package:projectflutter/auth/auth_service.dart';
import 'package:projectflutter/pages/main_navigation.dart';
import 'package:projectflutter/pages/register_page.dart';
import 'package:projectflutter/utils/app_dimensions.dart';
import 'package:projectflutter/widgets/loading_overlay.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:projectflutter/utils/app_colors.dart';

class LoginPage extends StatefulWidget {
  final bool showSuccessMessage;
  const LoginPage({Key? key, this.showSuccessMessage = false})
    : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _emailError = false;
  bool _passwordError = false;
  bool _isLoggingIn = false;

  @override
  void initState() {
    super.initState();
    if (widget.showSuccessMessage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Conta criada! Agora faça o login."),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    }
  }

  void login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Validação rápida antes de fazer a requisição
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Preencha todos os campos.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isLoggingIn = true;
    });

    try {
      final response = await authService.signInWithEmailPassword(
        email,
        password,
      );

      if (Supabase.instance.client.auth.currentUser == null &&
          response.session != null) {
        await Supabase.instance.client.auth.setSession(
          response.session!.refreshToken!,
        );
      }

      setState(() {
        _emailError = false;
        _passwordError = false;
      });

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigation()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Erro ao efetuar login. Verifique suas credenciais.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );

      setState(() {
        _emailError = true;
        _passwordError = true;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingIn = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Stack(
        children: [
          // Troque o SVG pelo JPG
          SizedBox.expand(
            child: Image.asset(
              'assets/images/loginimg.jfif', // coloque o caminho do seu JPG aqui
              fit: BoxFit.cover,
            ),
          ),
          Container(color: Colors.black.withOpacity(0.7)),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium,
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppDimensions.blockHeight * 3),
                  Center(
                    child: RichText(
                      text: TextSpan(
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
                              color: Color(0xFF44A301),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          WidgetSpan(
                            child: Icon(
                              Icons.location_on,
                              color: Color.fromARGB(255, 255, 255, 255),
                              size: 42,
                            ),
                          ),
                          TextSpan(
                            text: "p",
                            style: TextStyle(
                              fontSize: 42,
                              color: Color(0xFF44A301),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppDimensions.blockHeight * 15),
                  Center(
                    child: RichText(
                      text: TextSpan(
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
                            text: "in",
                            style: TextStyle(
                              fontSize: 40,
                              color: Color(0xFF44A301),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: AppDimensions.screenWidth * 0.9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: AppDimensions.blockHeight * 20),
                          TextField(
                            controller: _emailController,
                            cursorColor: Colors.white,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: const TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      _emailError ? Colors.red : Colors.white,
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorText: _emailError ? 'Email inválido' : null,
                              errorStyle: const TextStyle(color: Colors.red),
                            ),
                          ),
                          SizedBox(height: AppDimensions.blockHeight * 3),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            cursorColor: Colors.white,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      _passwordError
                                          ? Colors.red
                                          : Colors.white,
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorText:
                                  _passwordError ? 'Senha inválida' : null,
                              errorStyle: const TextStyle(color: Colors.red),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Forgot your password?",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppDimensions.blockHeight * 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
                          backgroundColor: Color(0xFF44A301),
                          side: const BorderSide(color: Colors.green),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.blockWidth * 6,
                            vertical: AppDimensions.blockHeight * 1.5,
                          ),
                          child: const Text("Sign up"),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: _isLoggingIn ? null : login,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.blockWidth * 6,
                            vertical: AppDimensions.blockHeight * 1.5,
                          ),
                          child:
                              _isLoggingIn
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : const Text("Login"),
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
