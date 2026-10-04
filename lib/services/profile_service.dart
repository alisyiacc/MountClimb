import '../models/profile.dart';
import 'api_client.dart';
import 'auth_service.dart';

/// Endpoint profil pengguna.
///
///   GET /rest/v1/profiles?select=*&id=eq.<user-id>&limit=1
class ProfileService {
  ProfileService._();

  static Future<Profile> getMyProfile() async {
    final data = await ApiClient.instance.get('/profiles', query: {
      'select': '*',
      'id': 'eq.${AuthService.userId}',
      'limit': '1',
    });

    final list = data as List;
    if (list.isEmpty) {
      return Profile(fullName: '', phone: '', email: AuthService.email);
    }
    return Profile.fromJson(list.first as Map<String, dynamic>);
  }
}
