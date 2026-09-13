import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MountClimbApp());
}

class MountClimbApp extends StatelessWidget {
  const MountClimbApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MountClimb',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomePage(),
      // Supaya aplikasi menyesuaikan diri di mana pun dijalankan: di HP
      // (Android/iOS) tampilan tetap penuh seperti biasa, sedangkan kalau
      // dijalankan di Chrome pada laptop/monitor lebar, kontennya otomatis
      // dibatasi ke lebar ala mobile dan diposisikan rapi di tengah supaya
      // tidak melar aneh. Dipasang di sini (lewat `builder`) supaya berlaku
      // untuk SELURUH halaman tanpa perlu mengubah tiap halaman satu-satu.
      builder: (context, child) => ResponsiveAppFrame(child: child ?? const SizedBox.shrink()),
    );
  }
}

/// Membungkus seluruh isi aplikasi (lewat `MaterialApp.builder`) agar
/// otomatis menyesuaikan lebar layar tempat aplikasi dijalankan:
///
/// - Layar sempit, mis. HP Android/iOS (lebar < [_mobileBreakpoint]):
///   tidak ada perubahan sama sekali — tampil penuh 1:1 seperti tampilan
///   mobile aslinya.
/// - Layar lebar, mis. dijalankan di Chrome pada laptop/monitor
///   (lebar >= [_mobileBreakpoint]): konten dibatasi ke lebar ala mobile
///   ([_maxContentWidth]) & diposisikan di tengah dengan sedikit bayangan,
///   supaya rapi dan tidak melar penuh satu layar.
///
/// Dibuat murni dari widget bawaan Flutter (LayoutBuilder, MediaQuery,
/// ColoredBox, Center, SizedBox, DecoratedBox) — tanpa package pihak ketiga.
class ResponsiveAppFrame extends StatelessWidget {
  final Widget child;

  const ResponsiveAppFrame({super.key, required this.child});

  static const double _mobileBreakpoint = 600;
  static const double _maxContentWidth = 480;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth >= _mobileBreakpoint;

        if (!isWideScreen) {
          // HP Android/iOS (atau jendela sempit) -> tampil apa adanya.
          return child;
        }

        // Chrome di laptop/desktop (layar lebar) -> "bingkai" ala mobile
        // di tengah layar, dan MediaQuery di-override supaya seluruh
        // halaman di dalamnya menganggap ukuran layarnya memang selebar
        // bingkai tersebut (konsisten dari sisi tampilan maupun logika).
        final mediaQuery = MediaQuery.of(context);

        return ColoredBox(
          color: const Color(0xFFBBDEFB),
          child: Center(
            child: SizedBox(
              width: _maxContentWidth,
              height: constraints.maxHeight,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 40, spreadRadius: 2),
                  ],
                ),
                child: MediaQuery(
                  data: mediaQuery.copyWith(
                    size: Size(_maxContentWidth, constraints.maxHeight),
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
