import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final ShapeBorder? shape;
  final Color? color;
  final double? elevation;
  final Clip? clip;
  final Widget child;

  const CustomCard({
    super.key,
    this.shape,
    this.color,
    this.elevation,
    this.clip,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: shape,
      color: color,
      elevation: elevation,
      clipBehavior: clip,
      child: child,
    );
  }
}
