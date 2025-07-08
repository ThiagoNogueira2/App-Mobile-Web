import 'package:supabase_flutter/supabase_flutter.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  // Cache para cursos
  List<Map<String, dynamic>>? _cursosCache;
  DateTime? _cursosCacheTime;
  static const Duration _cacheValidity = Duration(minutes: 30);

  // Cache para dados do usuário
  Map<String, dynamic>? _userDataCache;
  String? _currentUserId;

  // Verifica se o cache de cursos ainda é válido
  bool get _isCursosCacheValid {
    if (_cursosCache == null || _cursosCacheTime == null) return false;
    return DateTime.now().difference(_cursosCacheTime!) < _cacheValidity;
  }

  // Busca cursos com cache
  Future<List<Map<String, dynamic>>> getCursos() async {
    if (_isCursosCacheValid) {
      return _cursosCache!;
    }

    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('cursos')
        .select('id, curso, semestre, periodo');

    _cursosCache = List<Map<String, dynamic>>.from(data);
    _cursosCacheTime = DateTime.now();

    return _cursosCache!;
  }

  // Busca dados do usuário com cache
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    if (_userDataCache != null && _currentUserId == userId) {
      return _userDataCache;
    }

    final supabase = Supabase.instance.client;
    try {
      final data = await supabase
          .from('users')
          .select('*')
          .eq('id', userId)
          .single();

      _userDataCache = data;
      _currentUserId = userId;
      return data;
    } catch (e) {
      print('Erro ao buscar dados do usuário: $e');
      return null;
    }
  }

  // Limpa o cache de dados do usuário
  void clearUserCache() {
    _userDataCache = null;
    _currentUserId = null;
  }

  // Limpa todo o cache
  void clearAllCache() {
    _cursosCache = null;
    _cursosCacheTime = null;
    _userDataCache = null;
    _currentUserId = null;
  }

  // Força atualização do cache de cursos
  Future<void> refreshCursosCache() async {
    _cursosCache = null;
    _cursosCacheTime = null;
    await getCursos();
  }
} 