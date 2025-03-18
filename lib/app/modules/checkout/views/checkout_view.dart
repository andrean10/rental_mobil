import 'package:app_rental_mobil/app/helper/currency_format.dart';
import 'package:app_rental_mobil/app/helper/format_date_time.dart';
import 'package:app_rental_mobil/app/shared/shared_values.dart';
import 'package:app_rental_mobil/app/widgets/buttons/custom_filled_button.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widgets/card/cards.dart';
import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget builderDetailItem() {
      return Cards.elevated(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(child: Text('Kendaraan')),
                  Text(
                    '${controller.data.kendaraanModel?.carName}',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Expanded(child: Text('Tanggal Sewa')),
                  Text(
                    FormatDateTime.dateToString(
                      newPattern: 'dd MMMM yyyy',
                      value: controller.data.tanggalMulai.toString(),
                    ),
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Expanded(child: Text('Tanggal Kembali')),
                  Text(
                    FormatDateTime.dateToString(
                      newPattern: 'dd MMMM yyyy',
                      value: controller.data.tanggalSelesai.toString(),
                    ),
                    style: Get.textTheme.bodyLarge,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Expanded(child: Text('Total Harga')),
                  Text(
                    CurrencyFormat.convertToIdr(number: controller.data.harga),
                    style: Get.textTheme.bodyLarge,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget syaratDanKetentuan() {
      return Cards.elevated(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Syarat dan Ketentuan', style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              ...SharedValues.SYARAT_DAN_KETENTUAN.map((e) {
                final index = SharedValues.SYARAT_DAN_KETENTUAN.indexOf(e) + 1;
                return Text(
                  '$index.  $e',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.justify,
                );
              }).toList(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Order'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          builderDetailItem(),
          const SizedBox(height: 16),
          syaratDanKetentuan(),
          const SizedBox(height: 16),
          CustomFilledButton(
            isFilledTonal: false,
            onPressed: controller.checkout,
            child: const Text('Checkout'),
          ),
        ]),
      ),
    );
  }
}
