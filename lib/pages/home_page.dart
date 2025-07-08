import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/home_header.dart';
import '../widgets/quick_access_buttons.dart';
import '../widgets/next_class_card.dart';
import '../widgets/carousel_news.dart';
import '../widgets/important_notices.dart';
import '../widgets/news_modal.dart';
import '../data/news_data.dart';
import '../services/cache_service.dart';
import '../services/advanced_cache_service.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onAgendaTap;

  const HomePage({super.key, required this.onAgendaTap});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _nomeUsuario = 'Carregando...';
  final _cacheService = CacheService();
  final _advancedCacheService = AdvancedCacheService();
  // Substituir bools por listas
  List<Map<String, dynamic>> _eventosHoje = [];
  List<Map<String, dynamic>> _provasHoje = [];

  @override
  void initState() {
    super.initState();
    _carregarNomeUsuario();
    _checarNotificacoes();
  }

  Future<void> _carregarNomeUsuario() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      if (mounted) {
        setState(() {
          _nomeUsuario = 'Visitante';
        });
      }
      return;
    }

    try {
      final userData = await _cacheService.getUserData(user.id);

      if (mounted) {
        if (userData != null && userData['nome'] != null) {
          setState(() {
            _nomeUsuario = userData['nome'];
          });
        } else {
          setState(() {
            _nomeUsuario = 'Usuário';
          });
        }
      }
    } catch (e) {
      print('Erro ao buscar nome do usuário: $e');
      if (mounted) {
        setState(() {
          _nomeUsuario = 'Usuário';
        });
      }
    }
  }

  Future<void> _checarNotificacoes() async {
    final hoje = DateTime.now();
    final diaSemana = hoje.weekday - 1; // 0 = segunda, 6 = domingo
    final agenda = await _advancedCacheService.getUserAgenda(diaSemana);
    List<Map<String, dynamic>> eventos = [];
    List<Map<String, dynamic>> provas = [];
    for (final ag in agenda) {
      if (ag['tipo_agendamento'] == 'E') eventos.add(ag);
      if (ag['tipo_agendamento'] == 'M') provas.add(ag);
    }
    setState(() {
      _eventosHoje = eventos;
      _provasHoje = provas;
    });
  }

  void _mostrarModalNoticia(Map<String, dynamic> noticia) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewsModal(noticia: noticia);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final noticias = NewsData.getNoticias();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Hero com gradiente moderno
          HomeHeader(
            nomeUsuario: _nomeUsuario,
            notificacaoEvento: _eventosHoje.isNotEmpty,
            notificacaoProva: _provasHoje.isNotEmpty,
            eventosHoje: _eventosHoje,
            provasHoje: _provasHoje,
          ),

          const SizedBox(height: 32),

          // Ícones de Acesso Rápido
          QuickAccessButtons(onAgendaTap: widget.onAgendaTap),

          const SizedBox(height: 32),

          // Card da próxima aula
          const NextClassCard(),

          const SizedBox(height: 32),

          // Carrossel nativo de notícias
          CarouselNews(noticias: noticias, onNewsTap: _mostrarModalNoticia),

          const SizedBox(height: 32),

          // Seção de avisos importantes
          const ImportantNotices(),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
