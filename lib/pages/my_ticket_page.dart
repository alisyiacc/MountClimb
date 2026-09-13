import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/ticket_card.dart';
import 'history_page.dart';

class MyTicketPage extends StatelessWidget {
  const MyTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: SafeArea(
        child: ListView(
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

            if (dummyActiveBookings.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Column(
                  children: const [
                    Icon(Icons.confirmation_number_outlined, size: 56, color: Color(0xFFB0BEC5)),
                    SizedBox(height: 12),
                    Text(
                      'Belum ada tiket aktif',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF546E7A)),
                    ),
                  ],
                ),
              )
            else
              ...dummyActiveBookings.map((booking) => TicketCard(booking: booking)),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }
}
