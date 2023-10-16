import 'package:app_rental_mobil/app/modules/auth/widgets/builder_auth_button.dart';
import 'package:app_rental_mobil/app/modules/auth/widgets/builder_auth_password.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/card/cards.dart';
import '../../widgets/builder_auth_email.dart';
import '../../widgets/builder_auth_head.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    Widget builderAuth() {
      return SizedBox(
        width: (kIsWeb)
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
                  BuilderAuthEmail(
                    controller: controller.emailC,
                    email: controller.email,
                  ),
                  const SizedBox(height: 21),
                  BuilderAuthPassword(
                    controller: controller.passwordC,
                    isVisiblePassword: controller.isVisiblePassword,
                  ),
                  const SizedBox(height: 32),
                  BuilderAuthButton(
                    textFilledButton: 'Login',
                    textButton: 'Belum punya akun? Daftar',
                    onPressedFilledButton: controller.confirm,
                    onPressedTextButton: controller.moveToRegister,
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
                  const SizedBox(height: 21),
                  builderAuth(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
