import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

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
    required String curso,
    required int semestre,
    required String periodo,
  }) async {
    // 1. Cadastra o usuário no Supabase Auth
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'curso': curso, 'semestre': semestre, 'periodo': periodo},
    );

    final user = response.user;

    // 2. Insere os dados na tabela "users"
    if (user != null) {
      await _registerUserInUsersTable(
        user.id,
        email,
        curso: curso,
        semestre: semestre,
        periodo: periodo,
      );
    }

    return response;
  }

  Future<void> _registerUserInUsersTable(
    String userId,
    String email, {
    required String curso,
    required int semestre,
    required String periodo,
  }) async {
    // Verifica se o usuário já existe na tabela (opcional)
    final existing =
        await _supabase
            .from('users')
            .select('id')
            .eq('id', userId)
            .maybeSingle();

    if (existing == null) {
      await _supabase.from('users').insert({
        'id': userId,
        'email': email,
        'curso': curso,
        'semestre': semestre,
        'periodo': periodo,
        'created_at': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Get current user information
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  String? getCurrentUserEmail() {
    return getCurrentUser()?.email;
  }

  // Get user profile data
  Map<String, dynamic>? getCurrentUserData() {
    return getCurrentUser()?.userMetadata;
  }
}
