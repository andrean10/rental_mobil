import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../card/cards.dart';

class CustomTextFieldOTP extends StatelessWidget {
  final TextEditingController? controller;
  final double? width;
  final double? height;
  final TextInputAction? textInputAction;
  final bool isError;

  const CustomTextFieldOTP({
    Key? key,
    required this.controller,
    this.width,
    this.height,
    this.textInputAction = TextInputAction.next,
    required this.isError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Cards.filled(
      context: context,
      child: Center(
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: theme.textTheme.headlineSmall,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            errorText: (isError) ? '' : null,
            errorStyle: const TextStyle(
              fontSize: 0,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: theme.colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: theme.colorScheme.primary,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: theme.colorScheme.error,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: theme.colorScheme.error,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            counterText: '',
          ),
          keyboardType: TextInputType.number,
          textInputAction: textInputAction,
          onChanged: (value) {
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            } else {
              FocusScope.of(context).previousFocus();
            }
          },
        ),
      ),
    );
  }
}
