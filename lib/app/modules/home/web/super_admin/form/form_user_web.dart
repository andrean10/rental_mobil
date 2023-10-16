import 'package:app_rental_mobil/app/modules/home/web/super_admin/controllers/user/data_user_web_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../helper/validation.dart';
import '../../../../../shared/shared_values.dart';
import '../../../../auth/helper/validation_auth.dart';

Form formUserWeb(DataUserWebController controller) {
  return Form(
    key: controller.formKey,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
              const SizedBox(height: 16),
              Obx(
                () => DropdownButtonFormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  value: controller.roleC.value,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    hintText: 'Pilih role',
                  ),
                  items: SharedValues.ROLES.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: controller.changedRole,
                  validator: (value) => Validation.formField(
                    value: value,
                    titleField: 'Role',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () {
                  if (controller.roleC.value == SharedValues.ROLES[0]) {
                    return TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: controller.rentalNameC,
                      decoration: const InputDecoration(
                        labelText: 'Nama Rental',
                        hintText: 'Masukkan nama rental',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => Validation.formField(
                        value: value,
                        titleField: 'Nama rental',
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          child: Column(
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: controller.emailC,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Masukkan email',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                validator: ValidationAuth.isEmailValid,
              ),
              const SizedBox(height: 16),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: controller.numberPhoneC,
                decoration: const InputDecoration(
                  labelText: 'Nomor HP',
                  hintText: 'Masukkan nomor HP',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                maxLength: 13,
                validator: ValidationAuth.isNumberPhoneValid,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
              const SizedBox(height: 16),
            ],
          ),
        )
      ],
    ),
  );
}
