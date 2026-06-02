import 'package:flutter/material.dart';

class DebugFixesDemo extends StatefulWidget {
  const DebugFixesDemo({super.key});

  @override
  State<DebugFixesDemo> createState() => _DebugFixesDemoState();
}

class _DebugFixesDemoState extends State<DebugFixesDemo> {
  int _counter = 0;
  DateTime? _pickedDate;

  Future<void> _openDatePicker() async {
    final now = DateTime.now();

    // Calling showDatePicker from a mounted widget keeps the context valid.
    final date = await showDatePicker(
      context: context,
      initialDate: _pickedDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );

    if (!mounted || date == null) {
      return;
    }

    setState(() {
      _pickedDate = date;
    });
  }

  String get _dateLabel {
    final date = _pickedDate;
    if (date == null) {
      return 'No date selected';
    }

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exercise 5 - Debug and Fix UI Errors',
            style: textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          _FixPanel(
            title: 'ListView inside Column',
            description:
                'Fixed by wrapping the ListView.builder with Expanded.',
            child: SizedBox(
              height: 150,
              child: Column(
                children: [
                  const Text('Bounded movie list'),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return ListTile(
                          dense: true,
                          leading: const Icon(Icons.check_circle_outline),
                          title: Text('Fixed item ${index + 1}'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const _FixPanel(
            title: 'Overflow on small screens',
            description:
                'Fixed by wrapping this exercise screen with SingleChildScrollView.',
            child: Text(
              'The content can scroll vertically, so smaller devices do not show bottom overflow errors.',
            ),
          ),
          const SizedBox(height: 12),
          _FixPanel(
            title: 'State update issue',
            description: 'Fixed by changing the value inside setState().',
            child: Row(
              children: [
                Expanded(child: Text('Counter: $_counter')),
                IconButton.filledTonal(
                  onPressed: () {
                    setState(() {
                      _counter++;
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _FixPanel(
            title: 'DatePicker context',
            description:
                'Fixed by calling showDatePicker from this widget tree.',
            child: Row(
              children: [
                Expanded(child: Text(_dateLabel)),
                FilledButton.icon(
                  onPressed: _openDatePicker,
                  icon: const Icon(Icons.calendar_month_outlined),
                  label: const Text('Pick'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FixPanel extends StatelessWidget {
  const _FixPanel({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(description),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
