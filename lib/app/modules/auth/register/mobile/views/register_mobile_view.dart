import 'package:app_rental_mobil/app/helper/validation.dart';
import 'package:app_rental_mobil/app/modules/auth/register/mobile/controllers/register_mobile_controller.dart';
import 'package:app_rental_mobil/app/modules/auth/widgets/builder_auth_button.dart';
import 'package:app_rental_mobil/app/modules/auth/widgets/builder_auth_head.dart';
import 'package:app_rental_mobil/app/widgets/textformfield/custom_text_form_field.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../../widgets/card/cards.dart';
import '../../../widgets/builder_auth_email.dart';
import '../../../widgets/builder_auth_password.dart';

class RegisterMobileView extends GetView<RegisterMobileController> {
  const RegisterMobileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    Widget builderFullName() {
      return Obx(
        () => CustomTextField(
          title: 'Nama Lengkap',
          controller: controller.fullNameC,
          hintTitle: 'Anton',
          keyboardType: TextInputType.name,
          suffixIconState: controller.fullName.isNotEmpty,
          validator: (value) => Validation.formField(
            value: value,
            titleField: 'Nama lengkap',
          ),
        ),
      );
    }

    Widget builderNumberPhone() {
      return Obx(
        () => CustomTextField(
          title: 'Nomor Telepon',
          controller: controller.numberPhoneC,
          hintTitle: '081234567890',
          keyboardType: TextInputType.phone,
          suffixIconState: controller.numberPhone.value.isNotEmpty,
          maxLength: 13,
          validator: (value) => Validation.formField(
            value: value,
            titleField: 'Nomor telepon',
          ),
        ),
      );
    }

    Widget builderAddress() {
      return Obx(
        () => CustomTextField(
          title: 'Alamat',
          controller: controller.addressC,
          hintTitle: 'Jl. Soebrantas',
          keyboardType: TextInputType.streetAddress,
          textInputAction: TextInputAction.done,
          suffixIconState: controller.address.isNotEmpty,
          validator: (value) => Validation.formField(
            value: value,
            titleField: 'Alamat',
          ),
        ),
      );
    }

    Widget builderAuth() {
      return SizedBox(
        width: (GetPlatform.isWeb)
            ? (orientation == Orientation.portrait)
                ? double.infinity
                : 500
            : null,
        child: Cards.filled(
          context: context,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 32,
            ),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  builderFullName(),
                  const SizedBox(height: 16),
                  BuilderAuthEmail(
                    controller: controller.emailC,
                    email: controller.email,
                  ),
                  const SizedBox(height: 16),
                  BuilderAuthPassword(
                    controller: controller.passwordC,
                    isVisiblePassword: controller.isVisiblePassword,
                  ),
                  const SizedBox(height: 16),
                  builderNumberPhone(),
                  const SizedBox(height: 16),
                  builderAddress(),
                  const SizedBox(height: 32),
                  BuilderAuthButton(
                    textFilledButton: 'Register',
                    textButton: 'Sudah punya akun? Login',
                    onPressedFilledButton: controller.confirm,
                    onPressedTextButton: controller.moveToLogin,
                    state: controller.isLoading,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const BuilderAuthHead(),
                  const SizedBox(height: 32),
                  builderAuth()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
