// Model profil pengguna (tabel `profiles`).
class Profile {
  final String fullName;
  final String phone;
  final String email;

  const Profile({
    required this.fullName,
    required this.phone,
    required this.email,
  });

  factory Profile.fromJson(Map<String, dynamic> j) {
    return Profile(
      fullName: (j['full_name'] ?? '') as String,
      phone: (j['phone'] ?? '') as String,
      email: (j['email'] ?? '') as String,
    );
  }
}
