// Helper format yang dipakai di banyak halaman.

/// 90000 -> "Rp90.000"
String formatRupiah(int value) {
  final str = value.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < str.length; i++) {
    final posFromRight = str.length - i;
    buffer.write(str[i]);
    if (posFromRight > 1 && posFromRight % 3 == 1) buffer.write('.');
  }
  return 'Rp$buffer';
}

const List<String> _monthsLong = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
];
const List<String> _monthsShort = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
];
const List<String> _weekdaysShort = [
  'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min',
];

/// 2026-10-15 -> "15 Oktober 2026"
String formatDateId(DateTime d) => '${d.day} ${_monthsLong[d.month - 1]} ${d.year}';

/// "Okt"
String monthShortId(DateTime d) => _monthsShort[d.month - 1];

/// "Rab"
String weekdayShortId(DateTime d) => _weekdaysShort[d.weekday - 1];

/// DateTime -> "2026-10-15" (format yang dimengerti kolom `date` PostgreSQL)
String toIsoDate(DateTime d) {
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '$y-$m-$day';
}
