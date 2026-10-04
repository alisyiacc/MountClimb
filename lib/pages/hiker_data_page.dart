import 'package:flutter/material.dart';
import '../models/mountain.dart';
import '../services/profile_service.dart';
import '../utils/format.dart';
import '../widgets/app_text_field.dart';
import 'payment_page.dart';

// Hiker Data Page: form data pemesan. Nama & telepon otomatis terisi dari
// profil akun (GET /rest/v1/profiles) dan boleh diubah sebelum lanjut.
class HikerDataPage extends StatefulWidget {
  final Mountain mountain;
  final int hikerCount;
  final DateTime hikeDate;

  const HikerDataPage({
    super.key,
    required this.mountain,
    required this.hikerCount,
    required this.hikeDate,
  });

  @override
  State<HikerDataPage> createState() => _HikerDataPageState();
}

class _HikerDataPageState extends State<HikerDataPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _error;

  @override
  void initState() {
    super.initState();
    _prefillFromProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _prefillFromProfile() async {
    try {
      final profile = await ProfileService.getMyProfile();
      if (!mounted) return;
      // Jangan menimpa kalau pengguna sudah keburu mengetik.
      if (_nameController.text.isEmpty) _nameController.text = profile.fullName;
      if (_phoneController.text.isEmpty) _phoneController.text = profile.phone;
    } catch (_) {
      // Gagal memuat profil bukan masalah besar: pengguna bisa isi manual.
    }
  }

  void _next() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty) {
      setState(() => _error = 'Nama lengkap wajib diisi.');
      return;
    }
    if (phone.replaceAll(RegExp(r'[^0-9]'), '').length < 9) {
      setState(() => _error = 'Nomor telepon tidak valid.');
      return;
    }

    setState(() => _error = null);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          mountain: widget.mountain,
          hikerCount: widget.hikerCount,
          hikeDate: widget.hikeDate,
          hikerName: name,
          phone: phone,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE3F2FD),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF263238)),
        title: const Text(
          'Data Pendaki',
          style: TextStyle(color: Color(0xFF263238), fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
              children: [
                const Text(
                  'Lengkapi Data Pendaki',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF263238)),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Data terisi otomatis dari profil akunmu, boleh kamu ubah.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF78909C)),
                ),
                const SizedBox(height: 20),

                AppTextField(
                  controller: _nameController,
                  icon: Icons.person_outline,
                  label: 'Nama Lengkap',
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: _phoneController,
                  icon: Icons.phone_outlined,
                  label: 'Nomor Telepon',
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 14),
                _ReadOnlyField(
                  icon: Icons.groups_outlined,
                  label: 'Jumlah Pendaki',
                  value: '${widget.hikerCount} Orang',
                ),
                const SizedBox(height: 14),
                _ReadOnlyField(
                  icon: Icons.calendar_today_outlined,
                  label: 'Tanggal Pendakian',
                  value: formatDateId(widget.hikeDate),
                ),

                if (_error != null) ...[
                  const SizedBox(height: 14),
                  Text(
                    _error!,
                    style: const TextStyle(fontSize: 12.5, color: Color(0xFFE53935)),
                  ),
                ],
                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1F5FE),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, size: 18, color: Color(0xFF1E88E5)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Pastikan data pendaki sesuai KTP/identitas resmi saat pendaftaran sungguhan nanti.',
                          style: TextStyle(fontSize: 12, color: Color(0xFF263238), height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 12,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                  ),
                  child: const Text('Lanjut', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Field hanya-baca (jumlah pendaki & tanggal sudah dipilih di halaman sebelumnya).
class _ReadOnlyField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ReadOnlyField({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF1E88E5)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 11.5, color: Color(0xFF78909C))),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF263238))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
