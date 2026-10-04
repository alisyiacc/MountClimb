import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/supabase_config.dart';

/// Error yang sudah berisi pesan ramah untuk ditampilkan ke pengguna.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

/// Sesi login (token dari Supabase Auth).
class Session {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String email;
  final DateTime expiresAt;

  const Session({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.email,
    required this.expiresAt,
  });

  /// Token dianggap hampir habis 60 detik sebelum expired.
  bool get isExpiringSoon =>
      DateTime.now().isAfter(expiresAt.subtract(const Duration(seconds: 60)));

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'user_id': userId,
        'email': email,
        'expires_at': expiresAt.millisecondsSinceEpoch,
      };

  factory Session.fromJson(Map<String, dynamic> j) => Session(
        accessToken: j['access_token'] as String,
        refreshToken: j['refresh_token'] as String,
        userId: j['user_id'] as String,
        email: j['email'] as String,
        expiresAt: DateTime.fromMillisecondsSinceEpoch(j['expires_at'] as int),
      );

  /// Dari respons /auth/v1/signup, /auth/v1/token.
  factory Session.fromAuthResponse(Map<String, dynamic> j) {
    final user = (j['user'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final expiresIn = (j['expires_in'] as num?)?.toInt() ?? 3600;
    return Session(
      accessToken: j['access_token'] as String,
      refreshToken: j['refresh_token'] as String,
      userId: (user['id'] ?? '') as String,
      email: (user['email'] ?? '') as String,
      expiresAt: DateTime.now().add(Duration(seconds: expiresIn)),
    );
  }
}

/// Pusat semua panggilan HTTP ke Supabase.
///
/// - Otomatis menyertakan header `apikey` + token login pengguna.
/// - Otomatis memperbarui (refresh) token yang hampir habis.
/// - Mengubah error dari server menjadi [ApiException] berbahasa Indonesia.
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  static const String _prefsKey = 'mountclimb_session';
  static const Duration _timeout = Duration(seconds: 20);

  final http.Client _client = http.Client();

  Session? _session;
  Future<bool>? _refreshing;

  Session? get session => _session;
  bool get isLoggedIn => _session != null;

  // ------------------------------------------------------------------
  // Sesi
  // ------------------------------------------------------------------

  /// Panggil sekali di main() untuk memuat sesi yang tersimpan.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;
    try {
      _session = Session.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      await prefs.remove(_prefsKey);
    }
  }

  Future<void> saveSession(Session s) async {
    _session = s;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(s.toJson()));
  }

  Future<void> clearSession() async {
    _session = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }

  // ------------------------------------------------------------------
  // Pintu masuk request
  // ------------------------------------------------------------------

  /// Data API (tabel, view, function) -> {url}/rest/v1{path}
  Future<dynamic> get(String path, {Map<String, String>? query}) =>
      _send('GET', Uri.parse('${SupabaseConfig.restUrl}$path'), query: query);

  Future<dynamic> post(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) =>
      _send('POST', Uri.parse('${SupabaseConfig.restUrl}$path'),
          body: body, headers: headers);

  Future<dynamic> patch(
    String path, {
    Map<String, String>? query,
    Object? body,
    Map<String, String>? headers,
  }) =>
      _send('PATCH', Uri.parse('${SupabaseConfig.restUrl}$path'),
          query: query, body: body, headers: headers);

  /// Auth API (signup, login, logout) -> {url}/auth/v1{path}
  Future<dynamic> auth(
    String path, {
    Map<String, String>? query,
    Object? body,
    bool authed = false,
  }) =>
      _send('POST', Uri.parse('${SupabaseConfig.authUrl}$path'),
          query: query, body: body, authed: authed);

  // ------------------------------------------------------------------
  // Internal
  // ------------------------------------------------------------------

  Map<String, String> _headers({String? accessToken, Map<String, String>? extra}) {
    return {
      // Wajib di semua request.
      'apikey': SupabaseConfig.apiKey,
      // Token pengguna (kalau sudah login). Kalau belum login, header
      // Authorization TIDAK dikirim (publishable key tidak boleh di sini).
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      if (extra != null) ...extra,
    };
  }

  Future<dynamic> _send(
    String method,
    Uri base, {
    Map<String, String>? query,
    Object? body,
    Map<String, String>? headers,
    bool authed = true,
    bool retried = false,
  }) async {
    final uri = (query == null || query.isEmpty)
        ? base
        : base.replace(queryParameters: query);

    String? token;
    if (authed && _session != null) {
      if (_session!.isExpiringSoon) await _refresh();
      token = _session?.accessToken;
    }

    final req = http.Request(method, uri)
      ..headers.addAll(_headers(accessToken: token, extra: headers));
    if (body != null) req.body = jsonEncode(body);

    final http.Response res;
    try {
      final streamed = await _client.send(req).timeout(_timeout);
      res = await http.Response.fromStream(streamed);
    } on TimeoutException {
      throw const ApiException('Koneksi ke server terlalu lama. Coba lagi.');
    } on http.ClientException {
      throw const ApiException(
          'Tidak bisa terhubung ke server. Periksa koneksi internet Anda.');
    }

    // Token kadaluarsa -> refresh sekali lalu ulangi request.
    if (res.statusCode == 401 && authed && _session != null && !retried) {
      final ok = await _refresh();
      if (ok) {
        return _send(method, base,
            query: query,
            body: body,
            headers: headers,
            authed: authed,
            retried: true);
      }
    }

    return _decode(res);
  }

  Future<bool> _refresh() {
    // Beberapa request bersamaan berbagi satu proses refresh.
    return _refreshing ??= _doRefresh().whenComplete(() => _refreshing = null);
  }

  Future<bool> _doRefresh() async {
    final s = _session;
    if (s == null) return false;
    try {
      final res = await _client
          .post(
            Uri.parse('${SupabaseConfig.authUrl}/token')
                .replace(queryParameters: {'grant_type': 'refresh_token'}),
            headers: _headers(),
            body: jsonEncode({'refresh_token': s.refreshToken}),
          )
          .timeout(_timeout);

      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
        await saveSession(Session.fromAuthResponse(data));
        return true;
      }
      // Refresh token ditolak server -> sesi tidak berlaku lagi.
      if (res.statusCode >= 400 && res.statusCode < 500) {
        await clearSession();
      }
      return false;
    } catch (_) {
      return false; // gangguan jaringan: sesi dibiarkan, coba lagi nanti
    }
  }

  dynamic _decode(http.Response res) {
    dynamic data;
    if (res.bodyBytes.isNotEmpty) {
      final text = utf8.decode(res.bodyBytes);
      try {
        data = jsonDecode(text);
      } catch (_) {
        data = text;
      }
    }
    if (res.statusCode >= 200 && res.statusCode < 300) return data;
    throw ApiException(_errorMessage(data, res.statusCode), res.statusCode);
  }

  String _errorMessage(dynamic data, int status) {
    if (data is Map) {
      final code = (data['error_code'] ?? data['code'])?.toString();
      final msg = (data['message'] ??
              data['msg'] ??
              data['error_description'] ??
              data['error'])
          ?.toString();

      switch (code) {
        case 'invalid_credentials':
          return 'Email atau password salah.';
        case 'user_already_exists':
        case 'email_exists':
          return 'Email sudah terdaftar. Silakan login.';
        case 'weak_password':
          return 'Password terlalu lemah. Gunakan minimal 6 karakter.';
        case 'email_not_confirmed':
          return 'Email belum dikonfirmasi. Cek inbox email Anda.';
        case 'over_email_send_rate_limit':
        case 'over_request_rate_limit':
          return 'Terlalu banyak percobaan. Tunggu sebentar lalu coba lagi.';
        case 'validation_failed':
        case 'email_address_invalid':
          return 'Format email tidak valid.';
        case 'PGRST303':
          return 'Sesi Anda berakhir. Silakan login ulang.';
        case '42501':
          return 'Akses ditolak database. Pastikan GRANT & RLS di schema.sql sudah dijalankan.';
      }
      if (msg != null && msg.isNotEmpty) return msg;
    }
    if (status == 401) return 'Sesi Anda berakhir. Silakan login ulang.';
    return 'Terjadi kesalahan pada server ($status).';
  }
}
