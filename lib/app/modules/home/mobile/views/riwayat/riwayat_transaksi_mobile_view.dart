import 'package:app_rental_mobil/app/db/models/pesanan_model.dart';
import 'package:app_rental_mobil/app/helper/currency_format.dart';
import 'package:app_rental_mobil/app/helper/format_date_time.dart';
import 'package:app_rental_mobil/app/helper/validation.dart';
import 'package:app_rental_mobil/app/modules/home/mobile/controllers/riwayat/riwayat_transaksi_mobile_controller.dart';
import 'package:app_rental_mobil/app/widgets/buttons/custom_filled_button.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../widgets/textformfield/custom_text_form_field.dart';

class RiwayatTransaksiMobileView
    extends GetView<RiwayatTransaksiMobileController> {
  const RiwayatTransaksiMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    Widget builderImage(PesananModel item) {
      final state = controller.checkIsRented(item.tanggalSelesai)
          ? 'Sedang Disewa'
          : 'Selesai Disewa';

      return Expanded(
        flex: 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              CachedNetworkImage(
                height: double.infinity,
                imageUrl: '${item.kendaraanModel?.urlImg}',
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Image.asset(
                  'assets/img/no_image.png',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.5),
                padding: const EdgeInsets.all(4),
                child: Center(
                  child: Text(
                    state,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget builderInfo(PesananModel item) {
      return Expanded(
        flex: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  '${item.kendaraanModel?.carName}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SizedBox(height: 4),
                AutoSizeText(
                  '${item.userOrder?.rental?.fullName}',
                  style: theme.textTheme.bodyMedium,
                ),
                // const SizedBox(height: 12),
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
      );
    }

    void builderKeluhan(PesananModel item) {
      showModalBottomSheet(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => CustomTextField(
                      controller: controller.keluhanC,
                      isAutoFocus: true,
                      title: 'Ada keluhan?',
                      hintTitle: 'Masukkan keluhan anda disini',
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      maxLines: 5,
                      suffixIconState: controller.keluhan.value.isNotEmpty,
                      validator: (value) => Validation.formField(
                        value: value,
                        titleField: 'Keluhan',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => CheckboxListTile(
                      title: const Text('Sertakan lokasi saya'),
                      value: controller.isSendLocation.value,
                      onChanged: (value) {
                        controller.isSendLocation.value = value ?? false;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => CustomFilledButton(
                      onPressed: () => controller.addKeluhan(item),
                      isFilledTonal: false,
                      state: controller.isLoading.value,
                      child: const Text('Infokan ke Admin Rental'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    Widget builderContent(List<PesananModel> data) {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemBuilder: (context, index) {
          final item = data[index];

          return GestureDetector(
            onTap: () {
              if (controller.checkIsRented(item.tanggalSelesai)) {
                builderKeluhan(item);
              }
            },
            child: SizedBox(
              height: size.height * 0.2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  builderImage(item),
                  const SizedBox(width: 21),
                  builderInfo(item),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 32),
        itemCount: data.length,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pinjaman'),
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
