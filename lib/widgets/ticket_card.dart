import 'package:flutter/material.dart';
import '../models/booking.dart';
import 'app_image.dart';

// Kartu tiket yang dipakai di My Ticket Page & History Page.
class TicketCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onTap;

  const TicketCard({super.key, required this.booking, this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isActive = booking.status == 'Aktif';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      booking.bookingCode,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF78909C),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFFE1F5FE)
                          : const Color(0xFFECEFF1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      booking.status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isActive
                            ? const Color(0xFF1E88E5)
                            : const Color(0xFF78909C),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: AppImage(
                        path: booking.thumbnail,
                        fit: BoxFit.cover,
                        fallback: Container(
                          color: const Color(0xFFBBDEFB),
                          alignment: Alignment.center,
                          child: const Icon(Icons.terrain, color: Color(0xFF42A5F5)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.mountainName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF263238),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined,
                                size: 13, color: Color(0xFF78909C)),
                            const SizedBox(width: 4),
                            Text(
                              booking.date,
                              style: const TextStyle(fontSize: 12, color: Color(0xFF78909C)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.groups_outlined,
                                size: 13, color: Color(0xFF78909C)),
                            const SizedBox(width: 4),
                            Text(
                              '${booking.hikerCount} Pendaki',
                              style: const TextStyle(fontSize: 12, color: Color(0xFF78909C)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Color(0xFFB0BEC5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
