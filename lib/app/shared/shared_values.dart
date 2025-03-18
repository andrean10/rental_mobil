abstract class SharedValues {
  static const SUPER_ADMIN = 1;
  static const ADMIN_RENTAL = 2;
  static const USER = 3;

  static final ROLES = [
    'Admin Rental',
    'User',
  ];

  static final SYARAT_DAN_KETENTUAN = [
    "Penyewa wajib memiliki dan menunjukkan identitas resmi (KTP/SIM) yang masih berlaku saat pengambilan kendaraan.",
    "Kendaraan hanya boleh digunakan untuk keperluan pribadi dan tidak boleh dipindahtangankan ke pihak lain tanpa izin tertulis.",
    "Penyewa bertanggung jawab atas segala kerusakan atau kehilangan kendaraan selama masa sewa, kecuali yang disebabkan oleh faktor alam.",
    "Pengembalian kendaraan harus dilakukan sesuai dengan tanggal dan waktu yang telah disepakati. Keterlambatan akan dikenakan biaya tambahan sesuai dengan tarif yang berlaku.",
    "Dilarang menggunakan kendaraan untuk aktivitas ilegal atau yang melanggar hukum yang berlaku di wilayah setempat.",
    "Kendaraan harus dikembalikan dalam kondisi yang sama seperti saat diterima, termasuk jumlah bahan bakar sesuai kesepakatan awal.",
    "Jika terjadi keadaan darurat atau kecelakaan, penyewa wajib segera menghubungi penyedia layanan sewa untuk langkah lebih lanjut.",
    "Pembatalan pesanan dapat dilakukan maksimal 24 jam sebelum tanggal sewa dengan pengembalian dana sebagian sesuai kebijakan penyedia layanan.",
  ];
}
