import 'package:app_rental_mobil/app/db/models/pesanan_model.dart';
import 'package:app_rental_mobil/app/helper/currency_format.dart';
import 'package:app_rental_mobil/app/helper/format_date_time.dart';
import 'package:app_rental_mobil/app/modules/home/mobile/controllers/riwayat/riwayat_transaksi_mobile_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RiwayatTransaksiMobileView
    extends GetView<RiwayatTransaksiMobileController> {
  const RiwayatTransaksiMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    Widget builderContent(List<PesananModel> data) {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemBuilder: (context, index) {
          final item = data[index];

          return GestureDetector(
            onTap: () {},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      height: size.height * 0.2,
                      imageUrl: '${item.kendaraanModel?.urlImg}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 21),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        '${item.kendaraanModel?.carName}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AutoSizeText(
                        '${item.userOrder?.rental?.fullName}',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.today_rounded,
                            size: 18,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 4),
                          AutoSizeText(
                            FormatDateTime.dateToString(
                              newPattern: 'dd MMMM yyyy, HH:mm',
                              value: item.tanggalMulai.toString(),
                            ),
                            style: theme.textTheme.labelMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.event_available_rounded,
                            size: 18,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),
                          AutoSizeText(
                            FormatDateTime.dateToString(
                              newPattern: 'dd MMMM yyyy, HH:mm',
                              value: item.tanggalSelesai.toString(),
                            ),
                            style: theme.textTheme.labelMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 21),
                      Text('Total Harga', style: theme.textTheme.labelMedium),
                      const SizedBox(height: 4),
                      AutoSizeText(
                        CurrencyFormat.convertToIdr(number: item.harga),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 32),
        itemCount: data.length,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
      ),
      body: StreamBuilder(
        stream: controller.streamRiwayatTransaksi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  'Terjadi kesalahan coba lagi',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.isNotEmpty) {
            final data = snapshot.data!;
            return builderContent(data);
          }

          return const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(
              child: Text(
                'Riwayat transaksi anda kosong, silahkan lakukan pemesanan sewa pertama anda',
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}
