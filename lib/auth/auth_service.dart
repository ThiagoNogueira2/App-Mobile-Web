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
    String? curso,
    String? semestre,
    String? periodo,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'curso': curso, 'semestre': semestre, 'periodo': periodo},
    );

    return response;
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
