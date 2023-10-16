import 'package:app_rental_mobil/app/db/models/kendaraan_model.dart';
import 'package:app_rental_mobil/app/modules/home/web/admin_rental/controller/kendaraan/data_kendaraan_web_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../admin_rental/form/form_kendaraan_web.dart';

class BuilderActionsTableKendaraan extends GetView<DataKendaraanWebController> {
  final KendaraanModel value;
  final int rowIndex;

  const BuilderActionsTableKendaraan({
    required this.value,
    required this.rowIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            controller.setDataTextController(value);

            Get.defaultDialog<bool>(
              title: 'Edit Data',
              titleStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              contentPadding: const EdgeInsets.all(16.0),
              content: formKendaraanWeb(controller),
              textConfirm: 'Simpan',
              textCancel: 'Batal',
              confirmTextColor: Colors.white,
              onConfirm: () => controller.updateKendaraan(value.uid!),
              onCancel: controller.clearDataTextController,
              onWillPop: () async {
                controller.clearDataTextController();
                return true;
              },
            );
          },
          icon: Icon(
            Icons.edit_rounded,
            color: theme.colorScheme.primary,
          ),
        ),
        IconButton(
          onPressed: () {
            Get.defaultDialog(
              title: 'Konfirmasi',
              middleText: 'Apakah anda yakin ingin menghapus data ini?',
              textConfirm: 'Ya',
              textCancel: 'Tidak',
              confirmTextColor: Colors.white,
              onConfirm: () => controller.deleteKendaraan(
                uid: value.uid!,
                rowIndex: rowIndex,
              ),
            );
          },
          icon: Icon(
            Icons.delete_rounded,
            color: theme.colorScheme.error,
          ),
        ),
      ],
    );
  }
}
