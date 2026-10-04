import 'api_client.dart';

/// Register, login, logout lewat Supabase Auth (REST).
///
///   POST /auth/v1/signup
///   POST /auth/v1/token?grant_type=password
///   POST /auth/v1/logout
class AuthService {
  AuthService._();

  static final ApiClient _api = ApiClient.instance;

  static bool get isLoggedIn => _api.isLoggedIn;
  static String get userId => _api.session?.userId ?? '';
  static String get email => _api.session?.email ?? '';

  /// Mengembalikan `true` jika langsung login, `false` jika Supabase
  /// meminta konfirmasi email dulu (setting "Confirm email" aktif).
  static Future<bool> signUp({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    final data = await _api.auth('/signup', body: {
      'email': email.trim(),
      'password': password,
      // `data` masuk ke raw_user_meta_data -> dibaca trigger handle_new_user()
      // untuk mengisi tabel profiles.
      'data': {
        'full_name': fullName.trim(),
        'phone': phone.trim(),
      },
    });

    if (data is Map<String, dynamic> && data['access_token'] != null) {
      await _api.saveSession(Session.fromAuthResponse(data));
      return true;
    }
    return false;
  }

  static Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final data = await _api.auth(
      '/token',
      query: {'grant_type': 'password'},
      body: {'email': email.trim(), 'password': password},
    );
    await _api.saveSession(Session.fromAuthResponse(data as Map<String, dynamic>));
  }

  static Future<void> signOut() async {
    try {
      await _api.auth('/logout', authed: true);
    } catch (_) {
      // Walau gagal di server, sesi lokal tetap dihapus.
    }
    await _api.clearSession();
  }
}
