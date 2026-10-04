import 'package:flutter/material.dart';

// Gambar serbaguna: otomatis memilih Image.network kalau `path` berupa URL
// (http/https, mis. dari Supabase Storage) dan Image.asset kalau path lokal
// (mis. assets/images/semeru.jpg). Kalau gagal dimuat -> tampil placeholder.
class AppImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final Widget? fallback;

  const AppImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.fallback,
  });

  bool get _isNetwork => path.startsWith('http://') || path.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    final placeholder = fallback ??
        Container(
          color: const Color(0xFFBBDEFB),
          alignment: Alignment.center,
          child: const Icon(Icons.terrain, color: Color(0xFF42A5F5)),
        );

    if (path.isEmpty) return placeholder;

    if (_isNetwork) {
      return Image.network(
        path,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => placeholder,
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : placeholder,
      );
    }

    return Image.asset(
      path,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => placeholder,
    );
  }
}
