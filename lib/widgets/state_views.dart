import 'package:flutter/material.dart';
import '../services/api_client.dart';

/// Ubah error apa pun menjadi teks yang aman ditampilkan ke pengguna.
String errorText(Object error) {
  if (error is ApiException) return error.message;
  return 'Terjadi kesalahan. Silakan coba lagi.';
}

/// Indikator loading di tengah area.
class LoadingView extends StatelessWidget {
  final double? height;

  const LoadingView({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 160,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

/// Tampilan error + tombol "Coba Lagi".
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off_rounded, size: 48, color: Color(0xFFB0BEC5)),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Color(0xFF546E7A), height: 1.4),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}
