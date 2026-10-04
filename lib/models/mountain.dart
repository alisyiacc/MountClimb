// Model data gunung untuk aplikasi MountClimb.
// Data diambil dari tabel `mountains` di Supabase (lihat supabase/schema.sql).

class Mountain {
  final String id;
  final String name;
  final String location;
  final int heightMeters;
  final double rating;
  final int price; // harga tiket dalam rupiah
  final String difficulty; // Mudah, Sedang, Sulit
  final String description;
  final String hikingInfo;
  final List<String> images; // untuk image slider di detail page
  final String thumbnail; // gambar utama untuk card

  const Mountain({
    required this.id,
    required this.name,
    required this.location,
    required this.heightMeters,
    required this.rating,
    required this.price,
    required this.difficulty,
    required this.description,
    required this.hikingInfo,
    required this.images,
    required this.thumbnail,
  });

  /// Membuat Mountain dari JSON baris tabel `mountains` (nama kolom snake_case).
  factory Mountain.fromJson(Map<String, dynamic> j) {
    return Mountain(
      id: j['id'] as String,
      name: j['name'] as String,
      location: j['location'] as String,
      heightMeters: (j['height_meters'] as num).toInt(),
      rating: (j['rating'] as num).toDouble(),
      price: (j['price'] as num).toInt(),
      difficulty: j['difficulty'] as String,
      description: (j['description'] ?? '') as String,
      hikingInfo: (j['hiking_info'] ?? '') as String,
      images: List<String>.from((j['images'] as List?) ?? const []),
      thumbnail: (j['thumbnail'] ?? '') as String,
    );
  }
}
