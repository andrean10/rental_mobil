import 'package:app_rental_mobil/app/db/models/users_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../super_admin/controllers/user/data_user_web_controller.dart';
import '../../super_admin/form/form_user_web.dart';

class BuilderActionsTableUser extends GetView<DataUserWebController> {
  final UsersModel value;
  final int rowIndex;

  const BuilderActionsTableUser({
    required this.value,
    required this.rowIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              controller.setDataTextController(value);

              Get.defaultDialog(
                title: 'Edit Data',
                titleStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                contentPadding: const EdgeInsets.all(16.0),
                content: formUserWeb(controller),
                textConfirm: 'Simpan',
                textCancel: 'Batal',
                confirmTextColor: Colors.white,
                onConfirm: () async {
                  await controller.updateUser(
                    uid: value.uid!,
                    rowIndex: rowIndex,
                  );
                },
              ).whenComplete(() => controller.clearDataTextController());
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
                onConfirm: () => controller.deleteUser(
                  uid: value.uid ?? '',
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
      ),
    );
  }
}
