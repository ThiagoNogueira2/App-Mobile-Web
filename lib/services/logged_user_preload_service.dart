import 'package:supabase_flutter/supabase_flutter.dart';
import 'advanced_cache_service.dart';
import 'cache_service.dart';

class LoggedUserPreloadService {
  static final LoggedUserPreloadService _instance =
      LoggedUserPreloadService._internal();
  factory LoggedUserPreloadService() => _instance;
  LoggedUserPreloadService._internal();

  final AdvancedCacheService _advancedCache = AdvancedCacheService();
  final CacheService _cacheService = CacheService();
  bool _isPreloading = false;

  // Pré-carrega todos os dados importantes para usuários logados
  Future<void> preloadLoggedUserData() async {
    if (_isPreloading) return;

    _isPreloading = true;

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      // Pré-carrega dados do usuário
      await _cacheService.getUserData(user.id);

      // Pré-carrega dados do curso
      await _advancedCache.getUserCourse();

      // Pré-carrega próxima aula
      await _advancedCache.getNextClass();

      // Pré-carrega agenda da semana atual
      final hoje = DateTime.now();
      final diaSemana = hoje.weekday.clamp(1, 5) - 1;
      await _advancedCache.getUserAgenda(diaSemana);

      // Pré-carrega agenda de outros dias da semana em background
      _preloadWeekAgendaInBackground();
    } catch (e) {
      print('Erro no pré-carregamento de dados do usuário logado: $e');
    } finally {
      _isPreloading = false;
    }
  }

  // Pré-carrega agenda da semana em background (não bloqueia)
  void _preloadWeekAgendaInBackground() {
    Future.microtask(() async {
      try {
        final user = Supabase.instance.client.auth.currentUser;
        if (user == null) return;

        // Pré-carrega agenda para todos os dias da semana
        for (int dia = 0; dia < 5; dia++) {
          await _advancedCache.getUserAgenda(dia);
          // Pequena pausa para não sobrecarregar
          await Future.delayed(const Duration(milliseconds: 100));
        }
      } catch (e) {
        print('Erro ao pré-carregar agenda da semana: $e');
      }
    });
  }

  // Pré-carrega dados específicos
  Future<void> preloadUserCourse() async {
    try {
      await _advancedCache.getUserCourse();
    } catch (e) {
      print('Erro ao pré-carregar dados do curso: $e');
    }
  }

  Future<void> preloadNextClass() async {
    try {
      await _advancedCache.getNextClass();
    } catch (e) {
      print('Erro ao pré-carregar próxima aula: $e');
    }
  }

  Future<void> preloadAgenda(int diaSemana) async {
    try {
      await _advancedCache.getUserAgenda(diaSemana);
    } catch (e) {
      print('Erro ao pré-carregar agenda: $e');
    }
  }

  // Verifica se está pré-carregando
  bool get isPreloading => _isPreloading;

  // Limpa todos os caches
  void clearAllCaches() {
    _advancedCache.clearAllAdvancedCache();
    _cacheService.clearUserCache();
  }
}
