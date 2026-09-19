import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/flat.dart';
import '../models/laundry_settings.dart';
import '../models/time_slot.dart';
import '../services/app_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  late int _floors;
  late int _flatsPerFloor;
  late int _washers;
  late int _dryers;
  late int _planDays;
  late int _maxSlotsPerFlatPerDay;
  late List<TimeSlot> _timeSlots;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppState>().settings;
    if (!_initialized) {
      _floors = settings.floors;
      _flatsPerFloor = settings.flatsPerFloor;
      _washers = settings.washers;
      _dryers = settings.dryers;
      _planDays = settings.planDays;
      _maxSlotsPerFlatPerDay = settings.maxSlotsPerFlatPerDay;
      _timeSlots = List.of(settings.timeSlots);
      _initialized = true;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Building setup')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            Text('Building', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _NumberField(
                    label: 'Floors',
                    value: _floors,
                    min: 1,
                    max: 50,
                    onChanged: (v) => setState(() => _floors = v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _NumberField(
                    label: 'Flats per floor',
                    value: _flatsPerFloor,
                    min: 1,
                    max: 26,
                    onChanged: (v) => setState(() => _flatsPerFloor = v),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Total flats: ${_floors * _flatsPerFloor}. '
                'You can rename individual flats or exclude one from the '
                'rota on the Flats tab.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 24),
            Text('Cellar appliances', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _NumberField(
                    label: 'Washing machines',
                    value: _washers,
                    min: 0,
                    max: 20,
                    onChanged: (v) => setState(() => _washers = v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _NumberField(
                    label: 'Dryers',
                    value: _dryers,
                    min: 0,
                    max: 20,
                    onChanged: (v) => setState(() => _dryers = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Time slots per day', style: Theme.of(context).textTheme.titleMedium),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: 'Add time slot',
                  onPressed: _timeSlots.length >= 8
                      ? null
                      : () => setState(() => _timeSlots.add(
                            const TimeSlot(label: 'Slot', start: '00:00', end: '00:00'),
                          )),
                ),
              ],
            ),
            for (var i = 0; i < _timeSlots.length; i++) _TimeSlotRow(
              slot: _timeSlots[i],
              canDelete: _timeSlots.length > 1,
              onChanged: (slot) => setState(() => _timeSlots[i] = slot),
              onDelete: () => setState(() => _timeSlots.removeAt(i)),
            ),
            const SizedBox(height: 24),
            Text('Plan length', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _NumberField(
              label: 'Days to schedule',
              value: _planDays,
              min: 1,
              max: 90,
              onChanged: (v) => setState(() => _planDays = v),
            ),
            const SizedBox(height: 8),
            _NumberField(
              label: 'Max slots per flat per day',
              value: _maxSlotsPerFlatPerDay,
              min: 1,
              max: 10,
              onChanged: (v) => setState(() => _maxSlotsPerFlatPerDay = v),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Save building setup'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final appState = context.read<AppState>();
    final currentFlats = appState.settings.flats;
    final updatedFlats = generateFlats(
      floors: _floors,
      flatsPerFloor: _flatsPerFloor,
      existing: currentFlats,
    );

    final newSettings = LaundrySettings(
      floors: _floors,
      flatsPerFloor: _flatsPerFloor,
      washers: _washers,
      dryers: _dryers,
      timeSlots: _timeSlots,
      planDays: _planDays,
      flats: updatedFlats,
      maxSlotsPerFlatPerDay: _maxSlotsPerFlatPerDay,
    );

    await appState.updateSettings(newSettings);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Building setup saved. Generate a new plan to apply it.')),
      );
    }
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(labelText: label, contentPadding: const EdgeInsets.symmetric(horizontal: 12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            visualDensity: VisualDensity.compact,
            onPressed: value > min ? () => onChanged(value - 1) : null,
          ),
          Text('$value', style: Theme.of(context).textTheme.titleMedium),
          IconButton(
            icon: const Icon(Icons.add),
            visualDensity: VisualDensity.compact,
            onPressed: value < max ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _TimeSlotRow extends StatelessWidget {
  const _TimeSlotRow({
    required this.slot,
    required this.canDelete,
    required this.onChanged,
    required this.onDelete,
  });

  final TimeSlot slot;
  final bool canDelete;
  final ValueChanged<TimeSlot> onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              initialValue: slot.label,
              decoration: const InputDecoration(labelText: 'Label', isDense: true),
              onChanged: (v) => onChanged(slot.copyWith(label: v)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              initialValue: slot.start,
              decoration: const InputDecoration(labelText: 'Start', isDense: true, hintText: 'HH:MM'),
              onChanged: (v) => onChanged(slot.copyWith(start: v)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              initialValue: slot.end,
              decoration: const InputDecoration(labelText: 'End', isDense: true, hintText: 'HH:MM'),
              onChanged: (v) => onChanged(slot.copyWith(end: v)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: canDelete ? onDelete : null,
          ),
        ],
      ),
    );
  }
}
