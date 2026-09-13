import 'package:flutter/material.dart';
import '../models/mountain.dart';
import 'booking_success_page.dart';

class PaymentPage extends StatelessWidget {
  final Mountain mountain;
  final int hikerCount;
  final String dateLabel;

  const PaymentPage({
    super.key,
    required this.mountain,
    required this.hikerCount,
    required this.dateLabel,
  });

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
    final int subtotal = mountain.price * hikerCount;
    final int total = subtotal + 5000;

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE3F2FD),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF263238)),
        title: const Text(
          'Pembayaran',
          style: TextStyle(color: Color(0xFF263238), fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 130),
              children: [
                const Text('Ringkasan Pesanan',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF263238))),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    children: [
                      _DetailRow(icon: Icons.terrain, label: 'Gunung', value: mountain.name),
                      const SizedBox(height: 12),
                      _DetailRow(icon: Icons.calendar_today_outlined, label: 'Tanggal', value: dateLabel),
                      const SizedBox(height: 12),
                      _DetailRow(icon: Icons.groups_outlined, label: 'Jumlah Pendaki', value: '$hikerCount Orang'),
                      const SizedBox(height: 12),
                      _DetailRow(
                          icon: Icons.confirmation_number_outlined,
                          label: 'Harga Tiket',
                          value: _formatPrice(mountain.price)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Text('Metode Pembayaran',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF263238))),
                const SizedBox(height: 10),
                const _PaymentMethodTile(icon: Icons.account_balance_outlined, label: 'Transfer Bank', selected: true),
                const SizedBox(height: 10),
                const _PaymentMethodTile(icon: Icons.qr_code_scanner, label: 'QRIS', selected: false),
                const SizedBox(height: 10),
                const _PaymentMethodTile(
                    icon: Icons.account_balance_wallet_outlined, label: 'E-Wallet', selected: false),
                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1F5FE),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _SummaryRow(label: 'Subtotal', value: _formatPrice(subtotal)),
                      const SizedBox(height: 8),
                      const _SummaryRow(label: 'Biaya Layanan', value: 'Rp5.000'),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(height: 1, color: Color(0xFF90CAF9)),
                      ),
                      _SummaryRow(label: 'Total Pembayaran', value: _formatPrice(total), bold: true),
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
                    // Tidak ada backend/payment sungguhan, tombol hanya navigation.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingSuccessPage(
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
                  child: const Text('Bayar Sekarang', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF1E88E5)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF78909C))),
        ),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF263238))),
      ],
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _PaymentMethodTile({required this.icon, required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: selected ? const Color(0xFF1E88E5) : const Color(0xFFBBDEFB), width: selected ? 1.5 : 1),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF1E88E5)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF263238))),
          ),
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            size: 20,
            color: selected ? const Color(0xFF1E88E5) : const Color(0xFFB0BEC5),
          ),
        ],
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
