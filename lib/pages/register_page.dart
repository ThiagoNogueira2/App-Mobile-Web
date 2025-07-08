import 'package:flutter/material.dart';
import 'package:projectflutter/auth/auth_service.dart';
import 'package:projectflutter/pages/login_pages.dart';
import 'package:projectflutter/utils/app_dimensions.dart';
import 'package:projectflutter/services/cache_service.dart';
import 'package:projectflutter/widgets/loading_overlay.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:projectflutter/utils/app_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authService = AuthService();
  final _cacheService = CacheService();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  List<Map<String, dynamic>> _cursos = [];
  int? _cursoSelecionadoId;
  bool _carregandoCursos = true;
  bool _isSigningUp = false;

  @override
  void initState() {
    super.initState();
    _buscarCursos();
  }

  // Função para converter número do período para nome
  String _obterNomePeriodo(int? periodo) {
    switch (periodo) {
      case 1:
        return 'Matutino';
      case 2:
        return 'Vespertino';
      case 3:
        return 'Noturno';
      default:
        return 'Não informado';
    }
  }

  Future<void> _buscarCursos() async {
    try {
      final cursos = await _cacheService.getCursos();
      if (mounted) {
        setState(() {
          _cursos = cursos;
          _carregandoCursos = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _carregandoCursos = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erro ao carregar cursos: $e")));
      }
    }
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

    setState(() {
      _isSigningUp = true;
    });

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
          MaterialPageRoute(
            builder: (context) => const LoginPage(showSuccessMessage: true),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao cadastrar: $e")));
    } finally {
      if (mounted) {
        setState(() {
          _isSigningUp = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);

    final cursoSelecionado = _cursos.firstWhere(
      (c) => c['id'] == _cursoSelecionadoId,
      orElse: () => {},
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Stack(
        children: [
          // Imagem de fundo
          SizedBox.expand(
            child: Image.asset(
              'assets/images/loginimg.jfif',
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
                  SizedBox(height: AppDimensions.blockHeight * 10),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RichText(
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
                                text: "up",
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Color(0xFF44A301),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Center(
                    child: SizedBox(
                      width: AppDimensions.screenWidth * 0.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: AppDimensions.blockHeight * 12),
                          _buildTextField(_nomeController, "Nome"),
                          SizedBox(height: AppDimensions.blockHeight * 3),
                          _buildTextField(_emailController, 'Email'),
                          SizedBox(height: AppDimensions.blockHeight * 3),
                          _buildTextField(
                            _passwordController,
                            'Password',
                            obscure: true,
                          ),
                          SizedBox(height: AppDimensions.blockHeight * 3),
                          _buildTextField(
                            _confirmPasswordController,
                            'Confirm Password',
                            obscure: true,
                          ),
                          SizedBox(height: AppDimensions.blockHeight * 3),
                          _carregandoCursos
                              ? const Center(child: CircularProgressIndicator())
                              : Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: DropdownButtonFormField<int>(
                                      value: _cursoSelecionadoId,
                                      items:
                                          _cursos
                                              .map(
                                                (curso) =>
                                                    DropdownMenuItem<int>(
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
                                      selectedItemBuilder: (
                                        BuildContext context,
                                      ) {
                                        return _cursos.map<Widget>((curso) {
                                          return Text(
                                            curso['curso'] ??
                                                curso['nome'] ??
                                                '',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          );
                                        }).toList();
                                      },
                                      decoration: const InputDecoration(
                                        labelText: 'Curso',
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        hintStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      dropdownColor: Colors.white,
                                      iconEnabledColor: Colors.white,
                                      iconDisabledColor: Colors.grey,
                                      isExpanded: true,
                                    ),
                                  ),
                                  if (cursoSelecionado.isNotEmpty) ...[
                                    const SizedBox(width: 12),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Semestre: ${cursoSelecionado['semestre'] ?? '-'}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Período: ${_obterNomePeriodo(cursoSelecionado['periodo'])}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min, // <- isso resolve!
                    children: [
                      SizedBox(height: AppDimensions.blockHeight * 7),
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
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.blockWidth * 4,
                                vertical: AppDimensions.blockHeight * 1.5,
                              ),
                              child: const Text("Voltar"),
                            ),
                          ),
                          OutlinedButton(
                            onPressed: _isSigningUp ? null : signUp,
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
                                horizontal: AppDimensions.blockWidth * 4,
                                vertical: AppDimensions.blockHeight * 1.5,
                              ),
                              child:
                                  _isSigningUp
                                      ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                      : const Text("Sign up"),
                            ),
                          ),
                        ],
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

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
