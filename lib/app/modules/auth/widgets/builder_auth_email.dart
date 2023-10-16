import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/textformfield/custom_text_form_field.dart';
import '../helper/validation_auth.dart';

class BuilderAuthEmail extends StatelessWidget {
  final TextEditingController controller;
  final RxString email;

  const BuilderAuthEmail({
    required this.controller,
    required this.email,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ObxValue(
      (email) {
        return CustomTextField(
          controller: controller,
          title: 'Email',
          hintTitle: 'example@gmail.com',
          keyboardType: TextInputType.emailAddress,
          textCapitalization: TextCapitalization.none,
          prefixIcon: Icons.email_rounded,
          suffixIcon: (email.value.isNotEmpty)
              ? IconButton(
                  onPressed: () => controller.clear(),
                  icon: const Icon(Icons.cancel_rounded),
                )
              : null,
          validator: (value) => ValidationAuth.isEmailValid(value),
          // errorText: (controller.errorText.value.isNotEmpty)
          //     ? controller.errorText.value
          //     : null,
        );
      },
      email,
    );
  }
}
