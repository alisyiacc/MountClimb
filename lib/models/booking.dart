import '../utils/format.dart';
import 'mountain.dart';

// Model tiket/booking. Sumber data:
//  - view `v_my_bookings`        (My Ticket & Riwayat)  -> Booking.fromJson
//  - function `create_booking`   (setelah bayar)        -> Booking.fromCreateResponse
class Booking {
  final String id;
  final String bookingCode;
  final String mountainId;
  final String mountainName;
  final DateTime hikeDate;
  final int hikerCount;
  final String status; // 'Aktif' | 'Selesai' | 'Dibatalkan'
  final String thumbnail;
  final int total;
  final String hikerName;
  final String phone;
  final String paymentMethod;

  const Booking({
    required this.id,
    required this.bookingCode,
    required this.mountainId,
    required this.mountainName,
    required this.hikeDate,
    required this.hikerCount,
    required this.status,
    required this.thumbnail,
    required this.total,
    required this.hikerName,
    required this.phone,
    required this.paymentMethod,
  });

  /// Tanggal siap tampil, contoh: "15 Oktober 2026".
  String get date => formatDateId(hikeDate);

  /// Dari satu baris view `v_my_bookings`.
  factory Booking.fromJson(Map<String, dynamic> j) {
    return Booking(
      id: j['id'] as String,
      bookingCode: j['booking_code'] as String,
      mountainId: j['mountain_id'] as String,
      mountainName: j['mountain_name'] as String,
      hikeDate: DateTime.parse(j['hike_date'] as String),
      hikerCount: (j['hiker_count'] as num).toInt(),
      status: j['status'] as String,
      thumbnail: (j['thumbnail'] ?? '') as String,
      total: (j['total'] as num).toInt(),
      hikerName: (j['hiker_name'] ?? '') as String,
      phone: (j['phone'] ?? '') as String,
      paymentMethod: (j['payment_method'] ?? '') as String,
    );
  }

  /// Dari respons `POST /rpc/create_booking` (baris tabel `bookings`).
  /// Nama & gambar gunung diambil dari objek [mountain] yang sedang dipesan.
  factory Booking.fromCreateResponse(Map<String, dynamic> j, Mountain mountain) {
    return Booking(
      id: j['id'] as String,
      bookingCode: j['booking_code'] as String,
      mountainId: j['mountain_id'] as String,
      mountainName: mountain.name,
      hikeDate: DateTime.parse(j['hike_date'] as String),
      hikerCount: (j['hiker_count'] as num).toInt(),
      status: 'Aktif',
      thumbnail: mountain.thumbnail,
      total: (j['total'] as num).toInt(),
      hikerName: (j['hiker_name'] ?? '') as String,
      phone: (j['phone'] ?? '') as String,
      paymentMethod: (j['payment_method'] ?? '') as String,
    );
  }
}
