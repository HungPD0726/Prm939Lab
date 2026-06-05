import 'package:flutter/material.dart';

class Lab5ProductImage extends StatelessWidget {
  const Lab5ProductImage({
    super.key,
    required this.imageAsset,
    this.width,
    this.height,
    this.radius = 8,
    this.fit = BoxFit.cover,
  });

  final String imageAsset;
  final double? width;
  final double? height;
  final double radius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        imageAsset,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: colorScheme.surfaceContainerHighest,
            alignment: Alignment.center,
            child: Icon(
              Icons.inventory_2_outlined,
              color: colorScheme.onSurfaceVariant,
            ),
          );
        },
      ),
    );
  }
}
