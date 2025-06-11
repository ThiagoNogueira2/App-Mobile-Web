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
    if (user == null) {
      setState(() {
        carregando = false;
        userData = null;
      });
      return;
    }
    try {
      // Busca o usuário e faz join com cursos
      final data =
          await supabase
              .from('users')
              .select('*, cursos:curso_id(id, curso, semestre, periodo)')
              .eq('id', user.id)
              .maybeSingle();
      setState(() {
        userData = data;
        carregando = false;
      });
    } catch (e) {
      setState(() {
        carregando = false;
        userData = null;
      });
    }
  }

  void preencherControllers() {
    _nomeController.text = userData?['nome'] ?? '';
    _emailController.text = userData?['email'] ?? '';
    _cursoController.text = userData?['cursos']?['curso'] ?? '';
    _semestreController.text =
        userData?['cursos']?['semestre']?.toString() ?? '';
    _periodoController.text = userData?['cursos']?['periodo']?.toString() ?? '';
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
          })
          .eq('id', user.id);
      await carregarDadosPerfil();
      setState(() {
        editando = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Perfil atualizado com sucesso!'),
            ],
          ),
          backgroundColor: const Color(0xFF22C55E),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (e) {
      setState(() {
        carregando = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text('Erro ao atualizar perfil: $e')),
            ],
          ),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!editando && userData != null) preencherControllers();
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: CustomScrollView(
        slivers: [
          // Header com gradiente similar à página inicial
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF22C55E), // verde vivo
                      Color(0xFF16A34A), // verde escuro
                      Color(0xFF4ADE80), // verde claro
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Elementos decorativos
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -30,
                      left: -30,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Conteúdo do header
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                        child: Column(
                          children: [
                            // Avatar
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              userData?['nome'] ?? 'Usuário',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              userData?['cursos']?['curso'] ??
                                  'Curso não informado',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              if (!editando && userData != null)
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.edit_rounded, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        editando = true;
                      });
                    },
                  ),
                ),
            ],
          ),

          // Conteúdo principal
          SliverToBoxAdapter(
            child:
                carregando
                    ? Container(
                      height: 400,
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF22C55E),
                          ),
                          strokeWidth: 3,
                        ),
                      ),
                    )
                    : userData == null
                    ? Center(
                      child: Container(
                        margin: const EdgeInsets.all(24),
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6366F1).withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.person_off_rounded,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhum dado de perfil encontrado',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Usuário não autenticado',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                    : Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Card principal
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF6366F1,
                                  ).withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child:
                                  editando
                                      ? _buildEditMode()
                                      : _buildViewMode(),
                            ),
                          ),

                          // Botão de logout
                          if (!editando)
                            Container(
                              margin: const EdgeInsets.only(top: 24),
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  await Supabase.instance.client.auth.signOut();
                                  Navigator.of(
                                    context,
                                  ).pushReplacementNamed('/login');
                                },
                                icon: const Icon(Icons.logout_rounded),
                                label: const Text('Sair da Conta'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red[600],
                                  side: BorderSide(color: Colors.red[300]!),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              'Informações Pessoais',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildInfoCard(Icons.person_rounded, 'Nome', userData?['nome']),
        _buildInfoCard(Icons.email_rounded, 'E-mail', userData?['email']),

        const SizedBox(height: 32),

        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF16A34A), Color(0xFF4ADE80)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.school_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              'Informações Acadêmicas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildInfoCard(
          Icons.school_rounded,
          'Curso',
          userData?['cursos']?['curso'],
        ),
        _buildInfoCard(
          Icons.calendar_today_rounded,
          'Semestre',
          userData?['cursos']?['semestre']?.toString(),
        ),
        _buildInfoCard(
          Icons.access_time_rounded,
          'Período',
          userData?['cursos']?['periodo'],
        ),
      ],
    );
  }

  Widget _buildEditMode() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Editar Perfil',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildEditField(_nomeController, 'Nome', Icons.person_rounded),
          _buildEditField(
            _emailController,
            'E-mail',
            Icons.email_rounded,
            email: true,
          ),
          const SizedBox(height: 16),
          const Text(
            'Informações Acadêmicas (Somente leitura)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16),
          _buildEditField(
            _cursoController,
            'Curso',
            Icons.school_rounded,
            readOnly: true,
          ),
          _buildEditField(
            _semestreController,
            'Semestre',
            Icons.calendar_today_rounded,
            readOnly: true,
          ),
          _buildEditField(
            _periodoController,
            'Período',
            Icons.access_time_rounded,
            readOnly: true,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      editando = false;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFF64748B)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        atualizarPerfil();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Salvar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, dynamic value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF22C55E).withOpacity(0.1),
                  const Color(0xFF16A34A).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF22C55E), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value?.toString() ?? 'Não informado',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool email = false,
    bool number = false,
    bool readOnly = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType:
            number
                ? TextInputType.number
                : (email ? TextInputType.emailAddress : TextInputType.text),
        validator:
            readOnly
                ? null
                : (value) {
                  if (value == null || value.isEmpty) return 'Preencha o campo';
                  if (email && !value.contains('@')) return 'E-mail inválido';
                  if (number && int.tryParse(value) == null)
                    return 'Somente números';
                  return null;
                },
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: readOnly ? const Color(0xFF64748B) : const Color(0xFF1E293B),
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: readOnly ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient:
                  readOnly
                      ? LinearGradient(
                        colors: [
                          const Color(0xFF94A3B8).withOpacity(0.1),
                          const Color(0xFF94A3B8).withOpacity(0.1),
                        ],
                      )
                      : const LinearGradient(
                        colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                      ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: readOnly ? const Color(0xFF94A3B8) : Colors.white,
              size: 20,
            ),
          ),
          filled: true,
          fillColor:
              readOnly ? const Color(0xFFF1F5F9) : const Color(0xFFF8FAFC),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color:
                  readOnly ? const Color(0xFFBBF7D0) : const Color(0xFFDCFCE7),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color:
                  readOnly ? const Color(0xFFBBF7D0) : const Color(0xFFDCFCE7),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF22C55E), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
