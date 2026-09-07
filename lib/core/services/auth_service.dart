import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService({SupabaseClient? client})
      : _supabase = client ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  User? get currentUser => _supabase.auth.currentUser;
  Session? get currentSession => _supabase.auth.currentSession;
  bool get isLoggedIn => currentSession != null;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<AuthResponse> signIn(String email, String password) async {
    return _supabase.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<AuthResponse> register({
    required String email,
    required String password,
    required String name,
    required String companyName,
  }) async {
    return _supabase.auth.signUp(
      email: email.trim(),
      password: password,
      data: {
        'name': name.trim(),
        'company_name': companyName.trim(),
      },
    );
  }

  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email.trim());
  }

  Future<void> signOut() => _supabase.auth.signOut();
}
