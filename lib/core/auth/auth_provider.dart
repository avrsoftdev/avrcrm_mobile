import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/app_user.dart';
import '../services/auth_service.dart';
import 'access_control.dart';

class AuthResult {
  final AppUser? user;
  final String? error;

  const AuthResult({this.user, this.error});

  bool get ok => user != null && error == null;
}

/// Loads the signed-in CRM profile from `profiles` (trusted backend source)
/// and exposes role/department for routing. Role is never chosen in the UI.
class AuthProvider extends ChangeNotifier {
  AuthProvider({
    AuthService? authService,
    SupabaseClient? client,
  })  : _auth = authService ?? AuthService(client: client),
        _db = client ?? Supabase.instance.client;

  final AuthService _auth;
  final SupabaseClient _db;

  AppUser? _user;
  bool _loading = true;
  String? _error;
  bool _initialized = false;

  AppUser? get user => _user;
  bool get loading => _loading;
  String? get error => _error;
  bool get isSignedIn => _user != null && _auth.isLoggedIn;
  AuthHomeTarget get homeTarget => AccessControl.homeTarget(_user);

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final session = _auth.currentSession;
      if (session?.user == null) {
        _user = null;
      } else {
        _user = await _loadProfile(session!.user);
        if (_user != null && !_user!.active) {
          await _auth.signOut();
          _user = null;
          _error = 'This account is inactive. Contact your administrator.';
        } else if (_user != null && !_user!.role.canUseCrm) {
          await _auth.signOut();
          _error = _user!.role == AppRole.customer
              ? 'Customer accounts cannot sign in to the CRM mobile app.'
              : 'This account does not have a valid CRM role. Contact your administrator.';
          _user = null;
        }
      }
    } catch (e) {
      _error = 'Unable to restore your session. Please sign in again.';
      _user = null;
      debugPrint('AuthProvider.initialize failed: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<AuthResult> signIn(String identifier, String password) async {
    final normalizedIdentifier = identifier.trim();

    if (normalizedIdentifier.isEmpty || password.trim().isEmpty) {
      return const AuthResult(
        error: 'Email / User ID and password are required.',
      );
    }

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final email = await _resolveEmail(normalizedIdentifier);
      if (email == null || email.isEmpty) {
        _loading = false;
        notifyListeners();
        return const AuthResult(
          error: 'Unable to resolve this User ID. Try your email address.',
        );
      }

      final response = await _auth.signIn(email, password);
      final authUser = response.user;
      if (authUser == null) {
        _loading = false;
        notifyListeners();
        return const AuthResult(error: 'Invalid email or password.');
      }

      final profile = await _loadProfile(authUser);
      if (profile == null) {
        await _auth.signOut();
        _user = null;
        _loading = false;
        notifyListeners();
        return const AuthResult(
          error:
              'Unable to load this account profile. Contact your CRM administrator.',
        );
      }

      if (!profile.active) {
        await _auth.signOut();
        _user = null;
        _loading = false;
        notifyListeners();
        return const AuthResult(
          error: 'This account is inactive. Contact your administrator.',
        );
      }

      if (profile.role == AppRole.customer) {
        await _auth.signOut();
        _user = null;
        _loading = false;
        notifyListeners();
        return const AuthResult(
          error: 'Customer accounts cannot sign in to the CRM mobile app.',
        );
      }

      if (profile.role == AppRole.unknown || !profile.role.canUseCrm) {
        await _auth.signOut();
        _user = null;
        _loading = false;
        notifyListeners();
        return const AuthResult(
          error:
              'This account does not have a valid CRM role. Contact your administrator.',
        );
      }

      // Employees must have a tenant for scoped queries; admins likewise.
      if (!AccessControl.hasValidTenant(profile)) {
        await _auth.signOut();
        _user = null;
        _loading = false;
        notifyListeners();
        return const AuthResult(
          error:
              'This account is missing a tenant assignment. Contact your administrator.',
        );
      }

      _user = profile;
      _loading = false;
      notifyListeners();
      return AuthResult(user: profile);
    } on AuthException catch (e) {
      _user = null;
      _loading = false;
      _error = e.message;
      notifyListeners();
      return AuthResult(error: e.message.isNotEmpty ? e.message : 'Invalid email or password.');
    } catch (e) {
      _user = null;
      _loading = false;
      _error = 'Sign-in failed. Please try again.';
      notifyListeners();
      debugPrint('AuthProvider.signIn failed: $e');
      return const AuthResult(error: 'Sign-in failed. Please try again.');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('AuthProvider.signOut failed: $e');
    } finally {
      _user = null;
      _error = null;
      _loading = false;
      notifyListeners();
    }
  }

  Future<String?> _resolveEmail(String identifier) async {
    if (identifier.contains('@')) return identifier.toLowerCase();

    try {
      final data = await _db.rpc(
        'lookup_email_by_login_id',
        params: {'p_login_id': identifier},
      );
      if (data is String && data.trim().isNotEmpty) {
        return data.trim().toLowerCase();
      }
    } catch (e) {
      debugPrint('lookup_email_by_login_id failed: $e');
    }

    // Fallback: try identifier as email (admins may use email-only accounts).
    return identifier.toLowerCase();
  }

  Future<AppUser?> _loadProfile(User authUser) async {
    try {
      final data = await _db
          .from('profiles')
          .select()
          .eq('id', authUser.id)
          .maybeSingle();

      if (data != null) {
        return mapProfileToAppUser(
          Map<String, dynamic>.from(data),
          authEmail: authUser.email,
          authId: authUser.id,
        );
      }
    } catch (e) {
      debugPrint('profiles lookup failed: $e');
    }

    // Fall back to auth metadata only — never invent elevated roles.
    final mapped = mapAuthMetadataToAppUser(
      id: authUser.id,
      email: authUser.email,
      metadata: authUser.userMetadata,
    );
    if (mapped.role == AppRole.unknown) {
      return null;
    }
    return mapped;
  }
}
