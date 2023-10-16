import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../helper/validation.dart';
import '../../../../../widgets/buttons/custom_filled_button.dart';
import '../controller/kendaraan/data_kendaraan_web_controller.dart';

Widget builderContentImage(DataKendaraanWebController controller) {
  if (controller.fileImage.value != null || controller.urlImage.value != null) {
    return Image.network(
      (controller.fileImage.value?.path) != null
          ? controller.fileImage.value!.path
          : controller.urlImage.value!,
      fit: BoxFit.cover,
    );
  } else {
    return const Icon(
      Icons.image,
      size: 100,
      color: Colors.grey,
    );
  }
}

Form formKendaraanWeb(DataKendaraanWebController controller) {
  return Form(
    key: controller.formKey,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              Obx(() {
                return Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: (controller.isImageAvailable.value)
                          ? Colors.grey
                          : Colors.red,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: builderContentImage(controller),
                );
              }),
              ...[
                const SizedBox(height: 12),
                Obx(() {
                  if (!controller.isImageAvailable.value) {
                    return Text(
                      'Gambar tidak boleh kosong',
                      style: Get.theme.textTheme.labelMedium
                          ?.copyWith(color: Colors.red),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
                const SizedBox(height: 12),
              ],
              CustomFilledButton(
                onPressed: () {
                  if (kIsWeb) {
                    controller.pickImage();
                  }
                },
                isFilledTonal: false,
                child: Obx(
                  () => Text(
                    (controller.fileImage.value != null ||
                            controller.urlImage.value != null)
                        ? 'Ganti Gambar'
                        : 'Pilih Gambar',
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 21),
        Expanded(
          child: Column(
            children: [
              TextFormField(
                controller: controller.carNameC,
                decoration: const InputDecoration(
                  labelText: 'Nama Kendaraan',
                  hintText: 'Masukkan nama kendaraan',
                  isDense: true,
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                validator: (value) => Validation.formField(
                  value: value,
                  titleField: '',
                ),
              ),
              TextFormField(
                controller: controller.hargaC,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  hintText: 'Masukkan harga',
                  isDense: true,
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                validator: (value) => Validation.formField(
                  value: value,
                  titleField: 'Harga',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.deskripsiC,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  hintText: 'Masukkan deskripsi',
                  isDense: true,
                ),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.multiline,
                validator: (value) => Validation.formField(
                  value: value,
                  titleField: 'Deskripsi',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    ),
  );
}
