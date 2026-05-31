import 'package:flutter/material.dart';

class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  static const String _imageUrl =
      'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        Text('Exercise 1 - Core Widgets', style: textTheme.headlineSmall),
        const SizedBox(height: 12),
        // This section shows Text and Icon, two of the most common display widgets.
        Row(
          children: [
            Icon(Icons.widgets_outlined, color: colorScheme.primary, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Text, Icon, Image, Card, and ListTile',
                style: textTheme.titleMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: ColoredBox(
              color: colorScheme.surfaceContainerHighest,
              child: Image.network(
                _imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.broken_image_outlined, size: 48),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Card + ListTile gives a compact row layout for app content.
        Card(
          child: ListTile(
            leading: Icon(Icons.school_outlined, color: colorScheme.primary),
            title: const Text('Flutter UI Fundamentals'),
            subtitle: const Text('Card containing a ListTile'),
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
      ],
    );
  }
}
