import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/booking_service.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/state_views.dart';
import '../widgets/ticket_card.dart';
import 'history_page.dart';

// My Ticket: tiket aktif milik pengguna.
//   GET /rest/v1/v_my_bookings?status=eq.Aktif&order=hike_date.asc
class MyTicketPage extends StatefulWidget {
  const MyTicketPage({super.key});

  @override
  State<MyTicketPage> createState() => _MyTicketPageState();
}

class _MyTicketPageState extends State<MyTicketPage> {
  late Future<List<Booking>> _future;

  @override
  void initState() {
    super.initState();
    _future = BookingService.getActiveBookings();
  }

  Future<void> _reload() async {
    final next = BookingService.getActiveBookings();
    setState(() => _future = next);
    try {
      await next;
    } catch (_) {
      // Error sudah ditampilkan oleh FutureBuilder.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _reload,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Ticket',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF263238)),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HistoryPage()),
                      );
                    },
                    icon: const Icon(Icons.history, size: 18, color: Color(0xFF1E88E5)),
                    label: const Text(
                      'Riwayat',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E88E5)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Tiket aktif yang siap kamu gunakan',
                style: TextStyle(fontSize: 13, color: Color(0xFF78909C)),
              ),
              const SizedBox(height: 18),
              FutureBuilder<List<Booking>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingView();
                  }
                  if (snapshot.hasError) {
                    return ErrorView(
                      message: errorText(snapshot.error!),
                      onRetry: _reload,
                    );
                  }
                  final bookings = snapshot.data ?? const <Booking>[];
                  if (bookings.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Column(
                        children: [
                          Icon(Icons.confirmation_number_outlined, size: 56, color: Color(0xFFB0BEC5)),
                          SizedBox(height: 12),
                          Text(
                            'Belum ada tiket aktif',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF546E7A)),
                          ),
                        ],
                      ),
                    );
                  }
                  return Column(
                    children: [
                      for (final booking in bookings) TicketCard(booking: booking),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }
}
