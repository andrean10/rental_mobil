import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final String? hintTitle;
  final bool isReadOnly;
  final bool isEnable;
  final bool obscureText;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? suffixText;
  final bool? suffixIconState;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? maxLength;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final String? errorText;

  const CustomTextField({
    Key? key,
    required this.title,
    this.controller,
    this.hintTitle,
    this.isReadOnly = false,
    this.isEnable = true,
    this.obscureText = false,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.words,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixText,
    this.suffixIconState,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.maxLength,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.validator,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget? builderSuffixIcon() {
      if (suffixIcon != null) {
        return suffixIcon;
      } else {
        if (suffixIconState != null) {
          if (suffixIconState!) {
            return IconButton(
              onPressed: () => controller?.clear(),
              icon: const Icon(
                Icons.cancel_rounded,
              ),
            );
          }
        }
      }
      return null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          title,
          style: theme.textTheme.titleMedium,
          maxLines: 1,
        ),
        const SizedBox(height: 8),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
          controller: controller,
          obscureText: obscureText,
          textAlign: textAlign,
          textCapitalization: textCapitalization,
          maxLines: (keyboardType == TextInputType.multiline) ? null : maxLines,
          maxLength:
              (keyboardType == TextInputType.multiline) ? null : maxLength,
          buildCounter: (context,
                  {required currentLength, required isFocused, maxLength}) =>
              null,
          readOnly: isReadOnly,
          enabled: isEnable,
          decoration: InputDecoration(
            isDense: true,
            hintText: hintTitle,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: theme.colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            errorMaxLines: 2,
            errorText: errorText,
            // contentPadding: const EdgeInsets.all(12),
            prefixIcon: (prefixIcon != null) ? Icon(prefixIcon) : null,
            suffixIcon: builderSuffixIcon(),
            suffixText: suffixText,
          ),
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onTap: onTap,
          onChanged: onChanged,
          validator: validator,
          onEditingComplete: onEditingComplete,
          onFieldSubmitted: onFieldSubmitted ??
              (_) {
                FocusScope.of(context).nextFocus();
              },
        ),
      ],
    );
  }
}
