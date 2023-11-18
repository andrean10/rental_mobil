import 'package:app_rental_mobil/app/helper/validation.dart';
import 'package:app_rental_mobil/app/modules/auth/widgets/builder_auth_button.dart';
import 'package:app_rental_mobil/app/modules/auth/widgets/builder_auth_head.dart';
import 'package:app_rental_mobil/app/shared/shared_theme.dart';
import 'package:app_rental_mobil/app/widgets/textformfield/custom_text_form_field.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../../widgets/card/cards.dart';
import '../../../helper/validation_auth.dart';
import '../../../widgets/builder_auth_email.dart';
import '../../../widgets/builder_auth_password.dart';
import '../controllers/register_web_controller.dart';

class RegisterWebView extends GetView<RegisterWebController> {
  const RegisterWebView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orientation = MediaQuery.of(context).orientation;

    Widget builderRentalName() {
      return Obx(
        () => CustomTextField(
          title: 'Nama Rental',
          controller: controller.rentalNameC,
          hintTitle: 'Trans Jakarta',
          keyboardType: TextInputType.name,
          suffixIconState: controller.rentalName.isNotEmpty,
          validator: (value) => Validation.formField(
            value: value,
            titleField: 'Nama rental',
          ),
        ),
      );
    }

    Widget builderFullName() {
      return Obx(
        () => CustomTextField(
          title: 'Nama Pemilik',
          controller: controller.fullNameC,
          hintTitle: 'Joko Anwar',
          keyboardType: TextInputType.name,
          suffixIconState: controller.fullName.isNotEmpty,
          validator: (value) => Validation.formField(
            value: value,
            titleField: 'Nama pemilik',
          ),
        ),
      );
    }

    Widget builderNumberPhone() {
      return CustomTextField(
        title: 'Nomor Telepon',
        controller: controller.numberPhoneC,
        hintTitle: '081234567890',
        keyboardType: TextInputType.phone,
        suffixIconState: controller.numberPhone.isNotEmpty,
        maxLength: 13,
        validator: ValidationAuth.isNumberPhoneValid,
      );
    }

    Widget builderAddress() {
      return Obx(
        () => CustomTextField(
          title: 'Alamat',
          controller: controller.addressC,
          hintTitle: 'Jl. Soebrantas',
          keyboardType: TextInputType.streetAddress,
          maxLines: 3,
          suffixIconState: controller.address.isNotEmpty,
          validator: (value) => Validation.formField(
            value: value,
            titleField: 'Alamat',
          ),
        ),
      );
    }

    Widget builderUploadCar() {
      return CustomTextField(
        controller: controller.multipleImgC,
        title: 'Upload Foto Mobil (Wajib Min 3 Gambar)',
        hintTitle: 'Belum ada file yang dipilih',
        isReadOnly: false,
        isShowCursor: false,
        keyboardType: TextInputType.none,
        textInputAction: TextInputAction.done,
        suffixIcon: InkWell(
          onTap: controller.pickMultipleImage,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: theme.colorScheme.outlineVariant,
            ),
            padding: const EdgeInsets.all(14),
            child: const Text(
              'Telusuri File',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        validator: (value) => Validation.formField(
          value: value,
          titleField: 'Upload Foto Mobil',
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
                  builderRentalName(),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
                  builderUploadCar(),
                  const SizedBox(height: 16),
                  Text(
                    'Syarat dan ketentuan yang berlaku',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: SharedTheme.bold,
                    ),
                  ),
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
