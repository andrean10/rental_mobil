import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final double? width;
  final double? height;
  final Icon? icon;
  final Widget child;
  final ButtonStyle? style;
  final VoidCallback? onPressed;
  final bool state;

  const CustomElevatedButton({
    Key? key,
    this.width,
    this.height,
    this.icon,
    required this.child,
    this.style,
    this.onPressed,
    this.state = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: width,
      height: height ?? size.height * 0.055,
      child: (icon != null)
          ? ElevatedButton.icon(
              onPressed: onPressed,
              icon: icon!,
              label: child,
              style: style,
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: style,
              child: (state)
                  ? SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        color: colors.primary,
                      ),
                    )
                  : child,
            ),
    );
  }
}
