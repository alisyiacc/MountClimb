import 'package:flutter/material.dart';
import '../models/mountain.dart';
import 'hiker_data_page.dart';

// Ticket Page: menampilkan pilihan tanggal & jumlah pendaki secara VISUAL
// (tanpa state, sesuai ketentuan tahap awal). Nilai yang ditandai "terpilih"
// bersifat tetap/dummy karena halaman ini StatelessWidget.
class TicketPage extends StatelessWidget {
  final Mountain mountain;

  const TicketPage({super.key, required this.mountain});

  static const int selectedHikerCount = 2;
  static const String selectedDateLabel = '15 Okt';
  static const String selectedDateFull = '15 Oktober 2026';

  String _formatPrice(int price) {
    final str = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      final posFromRight = str.length - i;
      buffer.write(str[i]);
      if (posFromRight > 1 && posFromRight % 3 == 1) buffer.write('.');
    }
    return 'Rp$buffer';
  }

  @override
  Widget build(BuildContext context) {
    final int total = mountain.price * selectedHikerCount;

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE3F2FD),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF263238)),
        title: const Text(
          'Pesan Tiket',
          style: TextStyle(color: Color(0xFF263238), fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
              children: [
                // Ringkasan gunung
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: Image.asset(
                            mountain.thumbnail,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: const Color(0xFFBBDEFB),
                              child: const Icon(Icons.terrain, color: Color(0xFF42A5F5)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(mountain.name,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF263238))),
                            const SizedBox(height: 3),
                            Text(mountain.location,
                                style: const TextStyle(fontSize: 12, color: Color(0xFF78909C))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                // Gambar gunung yang dipesan + deskripsi singkat
                const Text('Gunung yang Dipesan',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF263238))),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.asset(
                          mountain.thumbnail,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: const Color(0xFFBBDEFB),
                            alignment: Alignment.center,
                            child: const Icon(Icons.terrain, size: 40, color: Color(0xFF42A5F5)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Text(
                          mountain.description,
                          style: const TextStyle(fontSize: 12.5, color: Color(0xFF546E7A), height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Pilihan tanggal (visual)
                const Text('Pilih Tanggal',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF263238))),
                const SizedBox(height: 10),
                SizedBox(
                  height: 82,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      _DateChip(day: '13', month: 'Okt', weekday: 'Sen', selected: false),
                      _DateChip(day: '14', month: 'Okt', weekday: 'Sel', selected: false),
                      _DateChip(day: '15', month: 'Okt', weekday: 'Rab', selected: true),
                      _DateChip(day: '16', month: 'Okt', weekday: 'Kam', selected: false),
                      _DateChip(day: '17', month: 'Okt', weekday: 'Jum', selected: false),
                      _DateChip(day: '18', month: 'Okt', weekday: 'Sab', selected: false),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Jumlah pendaki (visual)
                const Text('Jumlah Pendaki',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF263238))),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.groups_outlined, color: Color(0xFF1E88E5)),
                          SizedBox(width: 10),
                          Text('Pendaki', style: TextStyle(fontSize: 14, color: Color(0xFF263238))),
                        ],
                      ),
                      Row(
                        children: [
                          _StepperButton(icon: Icons.remove),
                          Container(
                            width: 36,
                            alignment: Alignment.center,
                            child: Text(
                              '$selectedHikerCount',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF263238)),
                            ),
                          ),
                          _StepperButton(icon: Icons.add),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Ringkasan harga
                const Text('Ringkasan Harga',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF263238))),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1F5FE),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _SummaryRow(
                        label: 'Tiket x $selectedHikerCount',
                        value: _formatPrice(mountain.price * selectedHikerCount),
                      ),
                      const SizedBox(height: 8),
                      const _SummaryRow(label: 'Biaya Layanan', value: 'Rp5.000'),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(height: 1, color: Color(0xFF90CAF9)),
                      ),
                      _SummaryRow(
                        label: 'Total',
                        value: _formatPrice(total + 5000),
                        bold: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Tombol lanjut, area jempol bawah layar
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
                        builder: (context) => HikerDataPage(
                          mountain: mountain,
                          hikerCount: selectedHikerCount,
                          dateLabel: selectedDateFull,
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

class _DateChip extends StatelessWidget {
  final String day;
  final String month;
  final String weekday;
  final bool selected;

  const _DateChip({required this.day, required this.month, required this.weekday, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF1E88E5) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: selected ? const Color(0xFF1E88E5) : const Color(0xFFBBDEFB)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(weekday, style: TextStyle(fontSize: 10, color: selected ? Colors.white70 : const Color(0xFF78909C))),
          const SizedBox(height: 4),
          Text(day,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : const Color(0xFF263238),
              )),
          Text(month, style: TextStyle(fontSize: 10, color: selected ? Colors.white70 : const Color(0xFF78909C))),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  const _StepperButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: const Color(0xFFE1F5FE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 16, color: const Color(0xFF1E88E5)),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _SummaryRow({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: bold ? 14 : 13,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
              color: const Color(0xFF263238),
            )),
        Text(value,
            style: TextStyle(
              fontSize: bold ? 15 : 13,
              fontWeight: FontWeight.w700,
              color: bold ? const Color(0xFF1E88E5) : const Color(0xFF263238),
            )),
      ],
    );
  }
}
