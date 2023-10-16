import 'package:app_rental_mobil/app/modules/home_detail/controllers/home_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/buttons/custom_filled_button.dart';

class BuilderDetailOrder extends GetView<HomeDetailController> {
  const BuilderDetailOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget builderFormField({
      required bool isDatePicker,
      required String titleText,
      required String hintText,
      required TextEditingController textEditingController,
      DateTime? firstDate,
      Function(DateTime)? changedDate,
      Function(TimeOfDay)? changedTime,
    }) {
      return TextFormField(
        controller: textEditingController,
        focusNode: controller.focusNode,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
          errorMaxLines: 3,
        ),
        autofocus: false,
        showCursor: false,
        readOnly: true,
        onTap: () async {
          controller.focusNode.unfocus();

          if (isDatePicker) {
            final date = await showDatePicker(
              context: context,
              initialDate: firstDate ?? DateTime.now(),
              firstDate: firstDate ?? DateTime.now(),
              lastDate: DateTime.now().add(
                const Duration(days: 365 * 10),
              ),
            );

            if (date != null) {
              changedDate!(date);
            }
          } else {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );

            if (time != null) {
              changedTime!(time);
            }
          }
        },
        validator: (value) => controller.validatorDate(
          value: value,
          title: hintText,
        ),
      );
    }

    Widget builderForm() {
      return Form(
        key: controller.formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: builderFormField(
                    isDatePicker: true,
                    titleText: 'Mulai',
                    hintText: 'Tanggal Mulai',
                    textEditingController: controller.dateStartC,
                    changedDate: controller.changeDateStart,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: builderFormField(
                    isDatePicker: true,
                    titleText: 'Selesai',
                    hintText: 'Tanggal Selesai',
                    firstDate: DateTime.now().add(const Duration(days: 1)),
                    textEditingController: controller.dateEndC,
                    changedDate: controller.changeDateEnd,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: builderFormField(
                    isDatePicker: false,
                    titleText: 'Mulai',
                    hintText: 'Jam Mulai',
                    textEditingController: controller.timeStartC,
                    changedTime: controller.changeTimeStart,
                  ),
                ),
                const SizedBox(width: 16),
                Obx(
                  () {
                    final timeEnd = controller.timeEnd.value;
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jam Selesai',
                            style: theme.textTheme.labelMedium,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            (timeEnd.isNotEmpty) ? timeEnd : '-',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: CustomFilledButton(
        isFilledTonal: false,
        onPressed: () {
          showModalBottomSheet(
            showDragHandle: true,
            context: context,
            builder: (context) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Pilih Tanggal Sewa',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    builderForm(),
                    const SizedBox(height: 21),
                    Obx(
                      () => CustomFilledButton(
                        onPressed: controller.moveToCheckout,
                        isFilledTonal: false,
                        state: controller.isLoading.value,
                        child: const Text('Sewa Sekarang'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ).whenComplete(() => controller.clearDate());
        },
        child: const Text('Sewa'),
      ),
    );
  }
}
