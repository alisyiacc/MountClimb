import 'package:flutter/material.dart';
import '../widgets/ticket_card.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

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
        child: dummyHistoryBookings.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.history, size: 56, color: Color(0xFFB0BEC5)),
                    SizedBox(height: 12),
                    Text(
                      'Belum ada riwayat pendakian',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF546E7A)),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                itemCount: dummyHistoryBookings.length,
                itemBuilder: (context, index) {
                  return TicketCard(booking: dummyHistoryBookings[index]);
                },
              ),
      ),
    );
  }
}
