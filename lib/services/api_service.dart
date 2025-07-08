import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // Métodos para usuários
  static Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select('*')
          .eq('id', userId)
          .maybeSingle();
      return response;
    } catch (e) {
      print('Erro ao buscar dados do usuário: $e');
      return null;
    }
  }

  static Future<String?> getUserName(String userId) async {
    try {
      final userData = await getUserData(userId);
      return userData?['nome'];
    } catch (e) {
      print('Erro ao buscar nome do usuário: $e');
      return null;
    }
  }

  static Future<String?> getUserCourseId(String userId) async {
    try {
      final userData = await getUserData(userId);
      return userData?['curso_id']?.toString();
    } catch (e) {
      print('Erro ao buscar curso do usuário: $e');
      return null;
    }
  }

  // Métodos para agendamentos
  static Future<List<Map<String, dynamic>>> getAgendamentosHoje(String cursoId) async {
    try {
      final hoje = DateTime.now();
      final diaStr = _formatDate(hoje);
      
      final response = await _supabase
          .from('agendamento')
          .select('''
            id,
            dia,
            aula_periodo,
            hora_inicio,
            hora_fim,
            tipo_agendamento,
            nome_evento,
            descricao_evento,
            cursos(id, curso, semestre, periodo),
            salas(id, numero_sala)
          ''')
          .eq('dia', diaStr)
          .eq('curso_id', cursoId)
          .order('hora_inicio');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Erro ao buscar agendamentos de hoje: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getAgendamentosPorDia(
    String cursoId,
    DateTime data,
  ) async {
    try {
      final diaStr = _formatDate(data);
      
      final response = await _supabase
          .from('agendamento')
          .select('''
            id,
            tipo_agendamento,
            nome_evento,
            aula_periodo,
            hora_inicio,
            hora_fim,
            sala_id,
            curso_id,
            dia,
            materia_id,
            periodo,
            professor_id,
            descricao_evento,
            cursos(id, curso),
            salas(id, numero_sala),
            materias(id, nome),
            professores(id, nome_professor)
          ''')
          .eq('dia', diaStr)
          .eq('curso_id', cursoId)
          .order('hora_inicio');

      print('RESPONSE BRUTO: $response');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Erro ao buscar agendamentos por dia: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getProximaAulaHoje(String cursoId) async {
    try {
      final hoje = DateTime.now();
      final diaStr = _formatDate(hoje);
      
      final response = await _supabase
          .from('agendamento')
          .select('''
            id,
            aula_periodo,
            hora_inicio,
            hora_fim,
            periodo,
            tipo_agendamento,
            nome_evento,
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
        final horaInicioSegunda = _parseTime(segundaAula['hora_inicio']);
        
        if (_isAfterOrEqual(agora, horaInicioSegunda)) {
          aulaIndex = 1;
        }
      }

      return response[aulaIndex];
    } catch (e) {
      print('Erro ao buscar próxima aula: $e');
      return null;
    }
  }

  // Métodos auxiliares
  static String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  static bool _isAfterOrEqual(TimeOfDay a, TimeOfDay b) {
    return a.hour > b.hour || (a.hour == b.hour && a.minute >= b.minute);
  }

  // Métodos para salas
  static Future<List<Map<String, dynamic>>> getSalas() async {
    try {
      final response = await _supabase
          .from('salas')
          .select('*')
          .order('numero_sala');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Erro ao buscar salas: $e');
      return [];
    }
  }

  // Métodos para cursos
  static Future<List<Map<String, dynamic>>> getCursos() async {
    try {
      final response = await _supabase
          .from('cursos')
          .select('*')
          .order('curso');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Erro ao buscar cursos: $e');
      return [];
    }
  }

  // Métodos para matérias
  static Future<List<Map<String, dynamic>>> getMaterias() async {
    try {
      final response = await _supabase
          .from('materias')
          .select('*')
          .order('nome');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Erro ao buscar matérias: $e');
      return [];
    }
  }

  // Métodos para professores
  static Future<List<Map<String, dynamic>>> getProfessores() async {
    try {
      final response = await _supabase
          .from('professores')
          .select('*')
          .order('nome_professor');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Erro ao buscar professores: $e');
      return [];
    }
  }
} 