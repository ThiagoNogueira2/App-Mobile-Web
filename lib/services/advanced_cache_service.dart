import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'cache_service.dart';

class AdvancedCacheService {
  static final AdvancedCacheService _instance =
      AdvancedCacheService._internal();
  factory AdvancedCacheService() => _instance;
  AdvancedCacheService._internal();

  final CacheService _cacheService = CacheService();
  CacheService get cacheService => _cacheService;

  // Cache para dados específicos do usuário logado
  Map<String, dynamic>? _userAgendaCache;
  Map<String, dynamic>? _nextClassCache;
  Map<String, dynamic>? _userCourseCache;
  DateTime? _agendaCacheTime;
  DateTime? _nextClassCacheTime;
  DateTime? _courseCacheTime;

  // Validade dos caches (5 minutos para dados dinâmicos)
  static const Duration _agendaCacheValidity = Duration(minutes: 5);
  static const Duration _nextClassCacheValidity = Duration(minutes: 2);
  static const Duration _courseCacheValidity = Duration(minutes: 30);

  // Verifica se o cache de agenda ainda é válido
  bool get _isAgendaCacheValid {
    if (_userAgendaCache == null || _agendaCacheTime == null) return false;
    return DateTime.now().difference(_agendaCacheTime!) < _agendaCacheValidity;
  }

  // Verifica se o cache da próxima aula ainda é válido
  bool get _isNextClassCacheValid {
    if (_nextClassCache == null || _nextClassCacheTime == null) return false;
    return DateTime.now().difference(_nextClassCacheTime!) <
        _nextClassCacheValidity;
  }

  // Verifica se o cache do curso ainda é válido
  bool get _isCourseCacheValid {
    if (_userCourseCache == null || _courseCacheTime == null) return false;
    return DateTime.now().difference(_courseCacheTime!) < _courseCacheValidity;
  }

  // Busca agenda do usuário com cache
  Future<List<Map<String, dynamic>>> getUserAgenda(int diaSemana) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return [];

    final cacheKey = '${user.id}_agenda_$diaSemana';

    if (_isAgendaCacheValid && _userAgendaCache!.containsKey(cacheKey)) {
      return List<Map<String, dynamic>>.from(_userAgendaCache![cacheKey]);
    }

    try {
      final agenda = await _fetchAgendaFromDatabase(user.id, diaSemana);

      if (_userAgendaCache == null) {
        _userAgendaCache = {};
        _agendaCacheTime = DateTime.now();
      }

      _userAgendaCache![cacheKey] = agenda;
      return agenda;
    } catch (e) {
      print('Erro ao buscar agenda: $e');
      return [];
    }
  }

  // Busca próxima aula com cache
  Future<Map<String, dynamic>?> getNextClass() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return null;

    if (_isNextClassCacheValid && _nextClassCache!.containsKey(user.id)) {
      return _nextClassCache![user.id];
    }

    try {
      final nextClass = await _fetchNextClassFromDatabase(user.id);

      if (_nextClassCache == null) {
        _nextClassCache = {};
        _nextClassCacheTime = DateTime.now();
      }

      _nextClassCache![user.id] = nextClass;
      return nextClass;
    } catch (e) {
      print('Erro ao buscar próxima aula: $e');
      return null;
    }
  }

  // Busca dados do curso do usuário com cache
  Future<Map<String, dynamic>?> getUserCourse() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return null;

    if (_isCourseCacheValid && _userCourseCache!.containsKey(user.id)) {
      return _userCourseCache![user.id];
    }

    try {
      final userData = await _cacheService.getUserData(user.id);
      if (userData == null || userData['curso_id'] == null) return null;

      final supabase = Supabase.instance.client;
      final courseData =
          await supabase
              .from('cursos')
              .select('*')
              .eq('id', userData['curso_id'])
              .single();

      if (_userCourseCache == null) {
        _userCourseCache = {};
        _courseCacheTime = DateTime.now();
      }

      _userCourseCache![user.id] = courseData;
      return courseData;
    } catch (e) {
      print('Erro ao buscar dados do curso: $e');
      return null;
    }
  }

  // Busca agenda do banco de dados
  Future<List<Map<String, dynamic>>> _fetchAgendaFromDatabase(
    String userId,
    int diaSemana,
  ) async {
    final supabase = Supabase.instance.client;

    // Busca curso_id do usuário
    final userData = await _cacheService.getUserData(userId);
    final cursoId = userData?['curso_id'];
    if (cursoId == null) return [];

    // Calcula a data do dia selecionado
    final hoje = DateTime.now();
    final segunda = hoje.subtract(Duration(days: hoje.weekday - 1));
    final dataSelecionada = segunda.add(Duration(days: diaSemana));
    final diaStr =
        '${dataSelecionada.year.toString().padLeft(4, '0')}-${dataSelecionada.month.toString().padLeft(2, '0')}-${dataSelecionada.day.toString().padLeft(2, '0')}';

    // Busca agendamentos
    final response = await supabase
        .from('agendamento')
        .select('''
          id,
          dia,
          aula_periodo,
          hora_inicio,
          hora_fim,
          periodo,
          tipo_agendamento,
          cursos(id, curso),
          salas(id, numero_sala),
          materias(id, nome),
          professores(id, nome_professor)
        ''')
        .eq('dia', diaStr)
        .eq('curso_id', cursoId)
        .order('hora_inicio');

    return List<Map<String, dynamic>>.from(response);
  }

  // Busca próxima aula do banco de dados
  Future<Map<String, dynamic>?> _fetchNextClassFromDatabase(
    String userId,
  ) async {
    final supabase = Supabase.instance.client;

    // Busca curso_id do usuário
    final userData = await _cacheService.getUserData(userId);
    final cursoId = userData?['curso_id'];
    if (cursoId == null) return null;

    final hoje = DateTime.now();
    final diaStr =
        '${hoje.year.toString().padLeft(4, '0')}-${hoje.month.toString().padLeft(2, '0')}-${hoje.day.toString().padLeft(2, '0')}';

    // Busca as duas aulas do dia
    final response = await supabase
        .from('agendamento')
        .select('''
          id,
          aula_periodo,
          hora_inicio,
          hora_fim,
          periodo,
          tipo_agendamento,
          cursos(id, curso, semestre, periodo),
          salas(id, numero_sala),
          materias(id, nome),
          professores(id, nome_professor)
        ''')
        .eq('dia', diaStr)
        .eq('curso_id', cursoId)
        .order('hora_inicio', ascending: true)
        .limit(2);

    if (response.isEmpty) return null;

    // Lógica para determinar qual aula mostrar
    final agora = TimeOfDay.now();
    int aulaIndex = 0;

    if (response.length > 1) {
      final segundaAula = response[1];
      final horaInicioSegunda = _parseTimeOfDay(segundaAula['hora_inicio']);

      if (_isAfterOrEqual(agora, horaInicioSegunda)) {
        aulaIndex = 1;
      }
    }

    return response.length > aulaIndex ? response[aulaIndex] : response[0];
  }

  // Funções auxiliares
  bool _isAfterOrEqual(TimeOfDay a, TimeOfDay b) {
    return a.hour > b.hour || (a.hour == b.hour && a.minute >= b.minute);
  }

  TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  // Limpa caches específicos
  void clearAgendaCache() {
    _userAgendaCache = null;
    _agendaCacheTime = null;
  }

  void clearNextClassCache() {
    _nextClassCache = null;
    _nextClassCacheTime = null;
  }

  void clearCourseCache() {
    _userCourseCache = null;
    _courseCacheTime = null;
  }

  // Limpa todos os caches avançados
  void clearAllAdvancedCache() {
    clearAgendaCache();
    clearNextClassCache();
    clearCourseCache();
  }

  // Força atualização de caches específicos
  Future<void> refreshAgendaCache(int diaSemana) async {
    clearAgendaCache();
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      await getUserAgenda(diaSemana);
    }
  }

  Future<void> refreshNextClassCache() async {
    clearNextClassCache();
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      await getNextClass();
    }
  }
}
