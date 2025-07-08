import 'package:supabase_flutter/supabase_flutter.dart';
import 'cache_service.dart';

class PreloadService {
  static final PreloadService _instance = PreloadService._internal();
  factory PreloadService() => _instance;
  PreloadService._internal();

  final CacheService _cacheService = CacheService();
  bool _isPreloading = false;

  // Pré-carrega dados importantes em background
  Future<void> preloadData() async {
    if (_isPreloading) return;
    
    _isPreloading = true;
    
    try {
      // Pré-carrega cursos em background
      await _cacheService.getCursos();
      
      // Pré-carrega dados do usuário se estiver logado
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        await _cacheService.getUserData(user.id);
      }
    } catch (e) {
      print('Erro no pré-carregamento: $e');
    } finally {
      _isPreloading = false;
    }
  }

  // Pré-carrega dados específicos do usuário
  Future<void> preloadUserData(String userId) async {
    try {
      await _cacheService.getUserData(userId);
    } catch (e) {
      print('Erro ao pré-carregar dados do usuário: $e');
    }
  }

  // Verifica se está pré-carregando
  bool get isPreloading => _isPreloading;
} 