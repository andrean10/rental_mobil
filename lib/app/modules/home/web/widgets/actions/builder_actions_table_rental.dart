import 'package:app_rental_mobil/app/db/models/users_model.dart';
import 'package:app_rental_mobil/app/helper/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../super_admin/controllers/rental/data_rental_web_controller.dart';

class BuilderActionsTableRental extends GetView<DataRentalWebController> {
  final UsersModel value;
  final int rowIndex;

  const BuilderActionsTableRental({
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

            Get.defaultDialog(
              title: 'Edit Data',
              titleStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              contentPadding: const EdgeInsets.all(16.0),
              content: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.rentalNameC,
                      decoration: const InputDecoration(
                        labelText: 'Nama Rental',
                        hintText: 'Masukkan nama rental',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      validator: (value) => Validation.formField(
                        value: value,
                        titleField: 'Nama rental',
                      ),
                    ),
                    TextFormField(
                      controller: controller.fullNameC,
                      decoration: const InputDecoration(
                        labelText: 'Nama',
                        hintText: 'Masukkan nama',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      validator: (value) => Validation.formField(
                        value: value,
                        titleField: 'Nama',
                      ),
                    ),
                    TextFormField(
                      controller: controller.numberPhoneC,
                      decoration: const InputDecoration(
                        labelText: 'Nomor HP',
                        hintText: 'Masukkan nomor HP',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      validator: (value) => Validation.formField(
                        value: value,
                        titleField: 'Nomor HP',
                      ),
                    ),
                    TextFormField(
                      controller: controller.addressC,
                      decoration: const InputDecoration(
                        labelText: 'Alamat',
                        hintText: 'Masukkan alamat',
                      ),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.streetAddress,
                      validator: (value) => Validation.formField(
                        value: value,
                        titleField: 'Alamat',
                      ),
                    ),
                  ],
                ),
              ),
              textConfirm: 'Simpan',
              textCancel: 'Batal',
              confirmTextColor: Colors.white,
              onConfirm: () {
                final newData = UsersModel(
                  uid: value.uid,
                  rentalName: controller.rentalNameC.text,
                  fullName: controller.fullNameC.text,
                  email: controller.emailC.text,
                  numberPhone: controller.numberPhoneC.text,
                  address: controller.addressC.text,
                  role: value.role,
                );

                controller.updateUser(
                  rowIndex: rowIndex,
                  newData: newData,
                );
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
    );
  }
}
