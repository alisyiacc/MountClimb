import '../models/mountain.dart';
import 'api_client.dart';

/// Endpoint data gunung.
///
///   GET /rest/v1/mountains?select=*&is_active=eq.true&order=sort_order.asc
///   (+ filter opsional)  &difficulty=eq.Mudah
///                        &or=(name.ilike.*semeru*,location.ilike.*semeru*)
class MountainService {
  MountainService._();

  static Future<List<Mountain>> getMountains({
    String? difficulty, // 'Mudah' | 'Sedang' | 'Sulit' | null/'Semua' = semua
    String? search,
    int? limit,
  }) async {
    final query = <String, String>{
      'select': '*',
      'is_active': 'eq.true',
      'order': 'sort_order.asc,name.asc',
    };

    if (difficulty != null && difficulty != 'Semua') {
      query['difficulty'] = 'eq.$difficulty';
    }

    final keyword = _sanitize(search);
    if (keyword.isNotEmpty) {
      query['or'] = '(name.ilike.*$keyword*,location.ilike.*$keyword*)';
    }

    if (limit != null) query['limit'] = '$limit';

    final data = await ApiClient.instance.get('/mountains', query: query);
    return (data as List)
        .map((e) => Mountain.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Buang karakter yang bisa merusak sintaks filter PostgREST: , ( ) * dll.
  static String _sanitize(String? input) {
    if (input == null) return '';
    return input.replaceAll(RegExp(r'[^\w\s\-.]'), ' ').trim();
  }
}
