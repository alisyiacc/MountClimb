import '../models/booking.dart';
import '../models/mountain.dart';
import '../utils/format.dart';
import 'api_client.dart';

/// Endpoint pemesanan tiket.
///
///   POST /rest/v1/rpc/create_booking          -> buat tiket (bayar)
///   GET  /rest/v1/v_my_bookings?status=eq.Aktif   -> My Ticket
///   GET  /rest/v1/v_my_bookings?status=neq.Aktif  -> Riwayat
class BookingService {
  BookingService._();

  /// Biaya layanan (hanya untuk tampilan estimasi; total resmi dihitung server
  /// di function create_booking — pastikan angkanya sama dengan schema.sql).
  static const int serviceFee = 5000;

  static Future<Booking> createBooking({
    required Mountain mountain,
    required DateTime hikeDate,
    required int hikerCount,
    required String hikerName,
    required String phone,
    required String paymentMethod,
  }) async {
    final data = await ApiClient.instance.post('/rpc/create_booking', body: {
      'p_mountain_id': mountain.id,
      'p_hike_date': toIsoDate(hikeDate),
      'p_hiker_count': hikerCount,
      'p_hiker_name': hikerName,
      'p_phone': phone,
      'p_payment_method': paymentMethod,
    });
    return Booking.fromCreateResponse(data as Map<String, dynamic>, mountain);
  }

  /// Tiket yang masih aktif (tanggal pendakian belum lewat).
  static Future<List<Booking>> getActiveBookings() =>
      _fetch({'status': 'eq.Aktif', 'order': 'hike_date.asc'});

  /// Riwayat: tiket yang sudah selesai / dibatalkan.
  static Future<List<Booking>> getHistory() =>
      _fetch({'status': 'neq.Aktif', 'order': 'hike_date.desc'});

  static Future<List<Booking>> _fetch(Map<String, String> filters) async {
    final data = await ApiClient.instance.get(
      '/v_my_bookings',
      query: {'select': '*', ...filters},
    );
    return (data as List)
        .map((e) => Booking.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
