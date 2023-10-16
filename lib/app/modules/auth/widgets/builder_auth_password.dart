import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/textformfield/custom_text_form_field.dart';
import '../helper/validation_auth.dart';

class BuilderAuthPassword extends StatelessWidget {
  final TextEditingController controller;
  final RxBool isVisiblePassword;

  const BuilderAuthPassword({
    super.key,
    required this.controller,
    required this.isVisiblePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomTextField(
        controller: controller,
        title: 'Password',
        hintTitle: 'Testing123',
        keyboardType: TextInputType.visiblePassword,
        obscureText: !isVisiblePassword.value,
        textInputAction: TextInputAction.done,
        prefixIcon: Icons.lock_rounded,
        suffixIcon: IconButton(
          onPressed: () => isVisiblePassword.toggle(),
          icon: Icon(
            (isVisiblePassword.value)
                ? Icons.visibility_rounded
                : Icons.visibility_off_rounded,
          ),
        ),
        onFieldSubmitted: (value) => FocusScope.of(context).unfocus(),
        validator: (value) => ValidationAuth.isWeakPassword(value),
        // errorText: (controller.errorText.value.isNotEmpty)
        // ? controller.errorText.value
        // : null,
      ),
    );
  }
}
