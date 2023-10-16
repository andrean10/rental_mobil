import 'package:app_rental_mobil/app/helper/currency_format.dart';
import 'package:app_rental_mobil/app/modules/home_detail/controllers/home_detail_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/card/cards.dart';

class BuilderDetailContent extends GetView<HomeDetailController> {
  const BuilderDetailContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget builderTitleProduct() {
      return SizedBox(
        width: double.infinity,
        child: Cards.elevated(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoSizeText(
                  '${controller.data.carName}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                AutoSizeText(
                  '${CurrencyFormat.convertToIdr(number: controller.data.harga)} / hari',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget builderDetailProduct() {
      return SizedBox(
        width: double.infinity,
        child: Cards.elevated(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoSizeText(
                  'Deskripsi',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${controller.data.deskripsi}',
                )
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        builderTitleProduct(),
        const SizedBox(height: 12),
        builderDetailProduct(),
      ],
    );
  }
}
