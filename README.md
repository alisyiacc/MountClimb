# MountClimb

Aplikasi pemesanan tiket pendakian gunung, dibuat dengan Flutter & Dart.

## Status Pengerjaan — VERSI FULL (10 Halaman)

Semua halaman sudah dibuat dan navigasi antar halaman sudah berjalan penuh:

1. **Home Page** — greeting, search bar visual, image slider, gunung populer.
2. **Explore Page** — search bar visual, kategori chip visual, daftar semua gunung.
3. **Mountain Detail Page** — image slider, info ketinggian/rating/kesulitan, deskripsi,
   info pendakian, tombol "Pesan Tiket".
4. **Ticket Page** — jenis tiket, pilihan tanggal visual, jumlah pendaki visual,
   ringkasan harga, tombol lanjut.
5. **Hiker Data Page** — tampilan form data pendaki (dummy: nama, telepon, jumlah pendaki).
6. **Payment Page** — ringkasan pesanan, pilihan metode pembayaran visual, tombol "Bayar Sekarang".
7. **Booking Success Page** — icon berhasil, kode booking dummy, detail singkat pendakian,
   tombol "Lihat Tiket".
8. **My Ticket Page** — tiket aktif (ticket card), link ke Riwayat.
9. **History Page** — riwayat pendakian (beberapa tiket dummy berstatus "Selesai").
10. **Profile Page** — avatar & data dummy, menu Riwayat/Pengaturan/Bantuan/Logout (visual).

Widget reusable: `BottomNav`, `ImageSlider` (PageView + indicator), `MountainCard`, `TicketCard`.

Semua halaman `StatelessWidget` (kecuali `ImageSlider` yang StatefulWidget internal
demi indicator titik yang responsif — ini widget, bukan page). Tidak ada Provider,
Riverpod, Bloc, GetX, database, Firebase, API, atau sistem pembayaran sungguhan.

## Alur Navigasi

```
Home ──► Explore ──► Mountain Detail ──► Ticket ──► Hiker Data
                                                          │
                                                          ▼
My Ticket ◄── Booking Success ◄── Payment ◄──────────────┘

Bottom Nav: Home ↔ Explore ↔ My Ticket ↔ Profile
History bisa diakses dari Profile atau My Ticket.
```

## Cara Menjalankan

1. Pastikan Flutter SDK sudah terinstall (`flutter doctor`).
2. Extract zip ini ke folder pilihanmu.
3. **Tambahkan gambar** ke folder `assets/images/` dengan nama persis berikut
   (kalau belum ada, aplikasi tetap jalan karena ada placeholder ikon otomatis):
   - `semeru.jpg`
   - `rinjani.jpg`
   - `merbabu.jpg`
   - `bromo.jpg`
   - `papandayan.jpg`
4. Di terminal, masuk ke folder project lalu jalankan:
   ```
   flutter pub get
   flutter run
   ```
   Atau buka folder ini di VS Code / Android Studio dan tekan tombol Run.

## Cara Mengetes

- **Home** → coba swipe slider foto, tap salah satu mountain card.
- **Mountain Detail** → scroll info, tap "Pesan Tiket".
- **Ticket Page** → cek tampilan jenis tiket, tanggal, jumlah pendaki, ringkasan harga,
  lalu tap "Lanjut".
- **Hiker Data Page** → cek data dummy tampil, tap "Lanjut".
- **Payment Page** → cek ringkasan pesanan & metode pembayaran, tap "Bayar Sekarang".
- **Booking Success** → cek kode booking & detail muncul, tap "Lihat Tiket" →
  harus langsung ke My Ticket Page dengan tiket aktif tampil.
- **Bottom Nav** → pindah antar Home / Explore / My Ticket / Profile, pastikan
  ikon aktif berubah sesuai halaman.
- **My Ticket → Riwayat** dan **Profile → Riwayat Pendakian** → harus membuka
  History Page dengan daftar tiket berstatus "Selesai".
- Pastikan tombol back di setiap halaman kembali ke halaman sebelumnya dengan benar.
- Pastikan tidak ada error merah (red screen) di seluruh alur.

Kalau ada error saat menjalankan, kirim pesan errornya agar bisa langsung diperbaiki.
