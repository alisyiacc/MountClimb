import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/booking_service.dart';
import '../widgets/state_views.dart';
import '../widgets/ticket_card.dart';

// Riwayat pendakian: tiket yang sudah selesai / dibatalkan.
//   GET /rest/v1/v_my_bookings?status=neq.Aktif&order=hike_date.desc
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<Booking>> _future;

  @override
  void initState() {
    super.initState();
    _future = BookingService.getHistory();
  }

  void _reload() {
    setState(() {
      _future = BookingService.getHistory();
    });
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
          'Riwayat Pendakian',
          style: TextStyle(color: Color(0xFF263238), fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Booking>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingView();
            }
            if (snapshot.hasError) {
              return Center(
                child: ErrorView(message: errorText(snapshot.error!), onRetry: _reload),
              );
            }
            final bookings = snapshot.data ?? const <Booking>[];
            if (bookings.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.history, size: 56, color: Color(0xFFB0BEC5)),
                    SizedBox(height: 12),
                    Text(
                      'Belum ada riwayat pendakian',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF546E7A)),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                return TicketCard(booking: bookings[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
