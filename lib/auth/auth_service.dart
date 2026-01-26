import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/cache_service.dart';
import '../services/logged_user_preload_service.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final CacheService _cacheService = CacheService();
  final LoggedUserPreloadService _loggedUserPreload =
      LoggedUserPreloadService();

  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmailPassword(
    String email,
    String password, {
    required String nome,
    required String curso,
    required int cursoId,
    int? semestre,
    String? periodo,
  }) async {
    // Cadastra o usuário no Supabase Auth com user_metadata
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'nome': nome,
        'curso': curso, // nome do curso para o metadata
        'curso_id': cursoId, // id do curso para referência
        if (semestre != null) 'semestre': semestre,
        if (periodo != null) 'periodo': periodo,
      },
    );

    final user = response.user;

    // Insere também na tabela "users" apenas se o usuário foi criado com sucesso
    if (user != null) {
      await _registerUserInUsersTable(
        user.id,
        email,
        nome: nome,
        cursoId: cursoId,
        semestre: semestre,
        periodo: periodo,
      );
    }

    return response;
  }

  Future<void> _registerUserInUsersTable(
    String userId,
    String email, {
    required String nome,
    required int cursoId,
    int? semestre,
    String? periodo,
  }) async {
    try {
      // Verifica se o usuário já existe na tabela
      final existing =
          await _supabase
              .from('users')
              .select('id')
              .eq('id', userId)
              .maybeSingle();

      if (existing == null) {
        // Insere apenas se não existir
        await _supabase.from('users').insert({
          'id': userId,
          'email': email,
          'nome': nome,
          'curso_id': cursoId,
          if (semestre != null) 'semestre': semestre,
          if (periodo != null) 'periodo': periodo,
          'created_at': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      print('Erro ao registrar usuário na tabela users: $e');
      // Não re-throw para não quebrar o fluxo de cadastro
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    _cacheService.clearUserCache();
    _loggedUserPreload.clearAllCaches();
  }

  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  String? getCurrentUserEmail() {
    return getCurrentUser()?.email;
  }

  Map<String, dynamic>? getCurrentUserData() {
    return getCurrentUser()?.userMetadata;
  }
}
