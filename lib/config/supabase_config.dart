// Konfigurasi koneksi ke Supabase.
//
// Ambil dua nilai ini dari Supabase Dashboard:
//   Project Settings -> API Keys  (atau "Data API" / "API")
//
// - url    : Project URL, contoh https://abcdefghijklmn.supabase.co
// - apiKey : "Publishable key" (diawali sb_publishable_...) atau, pada
//            project lama, "anon public key" (diawali eyJ...).
//
// Kedua key itu AMAN ditaruh di aplikasi (memang dirancang untuk publik),
// karena data tetap dilindungi RLS di database.
// JANGAN PERNAH memakai "secret key" / "service_role key" di sini.
class SupabaseConfig {
  SupabaseConfig._();

  static const String url = 'https://hbyaclsipeoelcxjwotx.supabase.co';
  static const String apiKey = 'sb_publishable_vMBhfUuObgDoa4nLn4qHZw_9z5kgkoU';

  // Dua "pintu" utama Supabase:
  static const String restUrl = '$url/rest/v1'; // data (PostgREST)
  static const String authUrl = '$url/auth/v1'; // login & register
}
