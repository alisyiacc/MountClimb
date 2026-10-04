import 'package:flutter/material.dart';
import '../models/mountain.dart';
import '../services/booking_service.dart';
import '../utils/format.dart';
import '../widgets/app_image.dart';
import 'hiker_data_page.dart';

// Ticket Page: pilih tanggal & jumlah pendaki (state disimpan di HP),
// harga dihitung langsung dari harga gunung yang berasal dari database.
class TicketPage extends StatefulWidget {
  final Mountain mountain;

  const TicketPage({super.key, required this.mountain});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  static const int _minHikers = 1;
  static const int _maxHikers = 10; // sama dengan batas di database
  static const int _daysToShow = 14;

  late final List<DateTime> _dates;
  late DateTime _selectedDate;
  int _hikerCount = 2;

  @override
  void initState() {
    super.initState();
    // Mulai dari BESOK (server menolak tanggal hari ini / yang sudah lewat).
    final now = DateTime.now();
    _dates = List.generate(
      _daysToShow,
      (i) => DateTime(now.year, now.month, now.day + 1 + i),
    );
    _selectedDate = _dates.first;
  }

  void _changeCount(int delta) {
    final next = _hikerCount + delta;
    if (next < _minHikers || next > _maxHikers) return;
    setState(() => _hikerCount = next);
  }

  @override
  Widget build(BuildContext context) {
    final mountain = widget.mountain;
    final int subtotal = mountain.price * _hikerCount;
    final int total = subtotal + BookingService.serviceFee;

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
                          child: AppImage(
                            path: mountain.thumbnail,
                            fit: BoxFit.cover,
                            fallback: Container(
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
                        child: AppImage(
                          path: mountain.thumbnail,
                          fit: BoxFit.cover,
                          fallback: Container(
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

                // Pilihan tanggal
                const Text('Pilih Tanggal',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF263238))),
                const SizedBox(height: 10),
                SizedBox(
                  height: 82,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final date in _dates)
                        _DateChip(
                          date: date,
                          selected: date == _selectedDate,
                          onTap: () => setState(() => _selectedDate = date),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Jumlah pendaki
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
                          _StepperButton(
                            icon: Icons.remove,
                            enabled: _hikerCount > _minHikers,
                            onTap: () => _changeCount(-1),
                          ),
                          Container(
                            width: 36,
                            alignment: Alignment.center,
                            child: Text(
                              '$_hikerCount',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF263238)),
                            ),
                          ),
                          _StepperButton(
                            icon: Icons.add,
                            enabled: _hikerCount < _maxHikers,
                            onTap: () => _changeCount(1),
                          ),
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
                        label: 'Tiket x $_hikerCount',
                        value: formatRupiah(subtotal),
                      ),
                      const SizedBox(height: 8),
                      _SummaryRow(
                        label: 'Biaya Layanan',
                        value: formatRupiah(BookingService.serviceFee),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(height: 1, color: Color(0xFF90CAF9)),
                      ),
                      _SummaryRow(
                        label: 'Total',
                        value: formatRupiah(total),
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
                          hikerCount: _hikerCount,
                          hikeDate: _selectedDate,
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
  final DateTime date;
  final bool selected;
  final VoidCallback onTap;

  const _DateChip({required this.date, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Text(weekdayShortId(date),
                style: TextStyle(fontSize: 10, color: selected ? Colors.white70 : const Color(0xFF78909C))),
            const SizedBox(height: 4),
            Text('${date.day}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : const Color(0xFF263238),
                )),
            Text(monthShortId(date),
                style: TextStyle(fontSize: 10, color: selected ? Colors.white70 : const Color(0xFF78909C))),
          ],
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _StepperButton({required this.icon, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: const Color(0xFFE1F5FE),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? const Color(0xFF1E88E5) : const Color(0xFFB0BEC5),
        ),
      ),
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
