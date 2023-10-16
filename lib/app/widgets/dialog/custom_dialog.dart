import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CustomDialog extends StatelessWidget {
  final Future<bool> Function()? onWillPop;
  final String title;
  final String description;
  final String animation;
  final bool? repeat;
  final Widget? child;

  const CustomDialog({
    super.key,
    this.onWillPop,
    required this.title,
    required this.description,
    required this.animation,
    this.repeat,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Future.delayed(3.seconds, () => Get.back());

    return WillPopScope(
      onWillPop: onWillPop ?? () async => true,
      child: Dialog(
        child: Padding(
          padding: EdgeInsets.only(
            left: 32,
            right: 32,
            top: 48,
            bottom: (child != null) ? 24 : 48,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 35,
                          right: 25,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.onSecondary,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 50,
                          left: 18,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.onSecondary,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 15,
                          left: 40,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.onSecondary,
                            ),
                          ),
                        ),
                        Lottie.asset(
                          animation,
                          width: 150,
                          height: 150,
                          repeat: repeat ?? false,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              AutoSizeText(
                title,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 26),
              AutoSizeText(
                description,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              if (child != null) ...[
                const SizedBox(height: 42),
                child!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
