import 'package:flutter/material.dart';
import '../models/mountain.dart';
import '../services/api_client.dart';
import '../services/booking_service.dart';
import '../utils/format.dart';
import '../widgets/state_views.dart';
import 'booking_success_page.dart';

// Payment Page: pilih metode bayar lalu kirim pesanan ke Supabase
// (POST /rest/v1/rpc/create_booking). Harga final & kode booking dibuat server.
class PaymentPage extends StatefulWidget {
  final Mountain mountain;
  final int hikerCount;
  final DateTime hikeDate;
  final String hikerName;
  final String phone;

  const PaymentPage({
    super.key,
    required this.mountain,
    required this.hikerCount,
    required this.hikeDate,
    required this.hikerName,
    required this.phone,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // Teks harus sama persis dengan yang dibolehkan di database (create_booking).
  static const List<_PayOption> _options = [
    _PayOption('Transfer Bank', Icons.account_balance_outlined),
    _PayOption('QRIS', Icons.qr_code_scanner),
    _PayOption('E-Wallet', Icons.account_balance_wallet_outlined),
  ];

  String _method = 'Transfer Bank';
  bool _paying = false;

  Future<void> _pay() async {
    if (_paying) return;
    setState(() => _paying = true);

    try {
      final booking = await BookingService.createBooking(
        mountain: widget.mountain,
        hikeDate: widget.hikeDate,
        hikerCount: widget.hikerCount,
        hikerName: widget.hikerName,
        phone: widget.phone,
        paymentMethod: _method,
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BookingSuccessPage(booking: booking),
        ),
      );
    } on ApiException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError(errorText(e));
    } finally {
      if (mounted) setState(() => _paying = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: const Color(0xFFE53935)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mountain = widget.mountain;
    final int subtotal = mountain.price * widget.hikerCount;
    final int total = subtotal + BookingService.serviceFee;

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
                      _DetailRow(icon: Icons.person_outline, label: 'Pemesan', value: widget.hikerName),
                      const SizedBox(height: 12),
                      _DetailRow(
                          icon: Icons.calendar_today_outlined,
                          label: 'Tanggal',
                          value: formatDateId(widget.hikeDate)),
                      const SizedBox(height: 12),
                      _DetailRow(
                          icon: Icons.groups_outlined,
                          label: 'Jumlah Pendaki',
                          value: '${widget.hikerCount} Orang'),
                      const SizedBox(height: 12),
                      _DetailRow(
                          icon: Icons.confirmation_number_outlined,
                          label: 'Harga Tiket',
                          value: formatRupiah(mountain.price)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Text('Metode Pembayaran',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF263238))),
                const SizedBox(height: 10),
                for (final option in _options) ...[
                  _PaymentMethodTile(
                    icon: option.icon,
                    label: option.label,
                    selected: option.label == _method,
                    onTap: () => setState(() => _method = option.label),
                  ),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 14),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1F5FE),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _SummaryRow(label: 'Subtotal', value: formatRupiah(subtotal)),
                      const SizedBox(height: 8),
                      _SummaryRow(label: 'Biaya Layanan', value: formatRupiah(BookingService.serviceFee)),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(height: 1, color: Color(0xFF90CAF9)),
                      ),
                      _SummaryRow(label: 'Total Pembayaran', value: formatRupiah(total), bold: true),
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
                  onPressed: _paying ? null : _pay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                  ),
                  child: _paying
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                        )
                      : const Text('Bayar Sekarang',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PayOption {
  final String label;
  final IconData icon;
  const _PayOption(this.label, this.icon);
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
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF263238)),
          ),
        ),
      ],
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFF1E88E5) : const Color(0xFFBBDEFB),
            width: selected ? 1.5 : 1,
          ),
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
