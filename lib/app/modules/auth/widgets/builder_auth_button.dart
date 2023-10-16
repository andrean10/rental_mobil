import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/buttons/custom_filled_button.dart';
import '../../../widgets/buttons/custom_text_button.dart';

class BuilderAuthButton extends StatelessWidget {
  final String textFilledButton;
  final String textButton;
  final Function() onPressedFilledButton;
  final Function() onPressedTextButton;
  final RxBool state;

  const BuilderAuthButton({
    super.key,
    required this.textFilledButton,
    required this.textButton,
    required this.onPressedFilledButton,
    required this.onPressedTextButton,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    Widget builderFilledButton() {
      return Obx(
        () => CustomFilledButton(
          width: double.infinity,
          isFilledTonal: false,
          onPressed: onPressedFilledButton,
          state: state.value,
          child: AutoSizeText(
            textFilledButton,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    Widget builderTextButton() {
      return CustomTextButton(
        onPressed: onPressedTextButton,
        child: Text(textButton),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        builderFilledButton(),
        const SizedBox(height: 32),
        builderTextButton(),
      ],
    );
  }
}
