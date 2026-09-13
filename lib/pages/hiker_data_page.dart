import 'package:flutter/material.dart';
import '../models/mountain.dart';
import 'payment_page.dart';

// Hiker Data Page: menampilkan tampilan form data pendaki.
// Karena halaman ini StatelessWidget di tahap awal, field diisi dengan
// data dummy (bukan TextField ber-controller) sesuai ketentuan tugas.
class HikerDataPage extends StatelessWidget {
  final Mountain mountain;
  final int hikerCount;
  final String dateLabel;

  const HikerDataPage({
    super.key,
    required this.mountain,
    required this.hikerCount,
    required this.dateLabel,
  });

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
                  'Data berikut masih berupa contoh (dummy).',
                  style: TextStyle(fontSize: 12, color: Color(0xFF78909C)),
                ),
                const SizedBox(height: 20),

                const _DummyFormField(
                  icon: Icons.person_outline,
                  label: 'Nama Lengkap',
                  value: 'Sharul Maulana',
                ),
                const SizedBox(height: 14),
                const _DummyFormField(
                  icon: Icons.phone_outlined,
                  label: 'Nomor Telepon',
                  value: '0812-3456-7890',
                ),
                const SizedBox(height: 14),
                _DummyFormField(
                  icon: Icons.groups_outlined,
                  label: 'Jumlah Pendaki',
                  value: '$hikerCount Orang',
                ),
                const SizedBox(height: 14),
                _DummyFormField(
                  icon: Icons.calendar_today_outlined,
                  label: 'Tanggal Pendakian',
                  value: dateLabel,
                ),
                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1F5FE),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: const [
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(
                          mountain: mountain,
                          hikerCount: hikerCount,
                          dateLabel: dateLabel,
                        ),
                      ),
                    );
                  },
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

class _DummyFormField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DummyFormField({required this.icon, required this.label, required this.value});

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
