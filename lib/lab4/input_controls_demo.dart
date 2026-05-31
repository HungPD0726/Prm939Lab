import 'package:flutter/material.dart';

enum LearningTrack {
  mobile('Mobile UI'),
  layout('Layout Practice'),
  theme('Theme Design');

  const LearningTrack(this.label);

  final String label;
}

class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  double _sliderValue = 60;
  bool _notificationsEnabled = true;
  LearningTrack _selectedTrack = LearningTrack.mobile;
  DateTime? _selectedDate;

  Future<void> _pickDate() async {
    final now = DateTime.now();

    // DatePicker is called from this widget's valid BuildContext.
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  String get _formattedDate {
    final date = _selectedDate;
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

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        Text('Exercise 2 - Input Widgets', style: textTheme.headlineSmall),
        const SizedBox(height: 12),
        Text('Slider value: ${_sliderValue.round()}%'),
        Slider(
          value: _sliderValue,
          min: 0,
          max: 100,
          divisions: 10,
          label: '${_sliderValue.round()}%',
          onChanged: (value) {
            setState(() {
              _sliderValue = value;
            });
          },
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Enable notifications'),
          subtitle: Text(_notificationsEnabled ? 'On' : 'Off'),
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
        const SizedBox(height: 12),
        Text('Choose a learning track', style: textTheme.titleMedium),
        const SizedBox(height: 4),
        // RadioGroup manages the selected value for the RadioListTile widgets.
        RadioGroup<LearningTrack>(
          groupValue: _selectedTrack,
          onChanged: (value) {
            if (value == null) {
              return;
            }

            setState(() {
              _selectedTrack = value;
            });
          },
          child: Column(
            children: [
              for (final track in LearningTrack.values)
                RadioListTile<LearningTrack>(
                  contentPadding: EdgeInsets.zero,
                  title: Text(track.label),
                  value: track,
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _pickDate,
          icon: const Icon(Icons.calendar_month_outlined),
          label: const Text('Pick Date'),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.fact_check_outlined),
            title: const Text('Current values'),
            subtitle: Text(
              'Slider: ${_sliderValue.round()}%, '
              'Switch: ${_notificationsEnabled ? 'On' : 'Off'}, '
              'Radio: ${_selectedTrack.label}, '
              'Date: $_formattedDate',
            ),
          ),
        ),
      ],
    );
  }
}
