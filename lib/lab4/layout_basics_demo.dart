import 'package:flutter/material.dart';

class LayoutBasicsDemo extends StatelessWidget {
  const LayoutBasicsDemo({super.key});

  static const List<String> _movies = [
    'The Flutter Journey',
    'Material Design Basics',
    'Stateful Widget Story',
    'Layout Builder Mission',
    'Scaffold City',
    'Theme Mode Night',
    'ListView Reloaded',
    'Padding and Spacing',
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Exercise 3 - Layout Basics', style: textTheme.headlineSmall),
          const SizedBox(height: 12),
          // Row creates horizontal summary sections, while SizedBox keeps spacing consistent.
          const Row(
            children: [
              Expanded(
                child: _SummaryTile(
                  icon: Icons.movie_outlined,
                  title: 'Movies',
                  value: '8',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _SummaryTile(
                  icon: Icons.star_outline,
                  title: 'Rating',
                  value: '4.8',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Movie List', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          // Expanded gives ListView a bounded height inside Column.
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 96),
              itemCount: _movies.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    tileColor: Theme.of(context).colorScheme.surfaceContainer,
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(_movies[index]),
                    subtitle: const Text('Built with ListView.builder'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.onSecondaryContainer),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(color: colorScheme.onSecondaryContainer),
          ),
        ],
      ),
    );
  }
}
