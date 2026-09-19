import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/laundry_settings.dart';
import '../models/machine.dart';
import '../models/schedule_entry.dart';

/// Renders one day's rota as a grid: time slots across the top (as in the
/// original paper Waschplan), machines down the side.
class DayScheduleCard extends StatelessWidget {
  const DayScheduleCard({
    super.key,
    required this.date,
    required this.entries,
    required this.settings,
  });

  final DateTime date;
  final List<ScheduleEntry> entries;
  final LaundrySettings settings;

  @override
  Widget build(BuildContext context) {
    final machines = generateMachines(washers: settings.washers, dryers: settings.dryers);
    final byMachineSlot = <String, ScheduleEntry>{
      for (final e in entries) '${e.machineId}_${e.timeSlotIndex}': e,
    };

    final theme = Theme.of(context);
    final isToday = DateUtils.isSameDay(date, DateTime.now());

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isToday
            ? BorderSide(color: theme.colorScheme.primary, width: 1.5)
            : BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: isToday
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.surfaceContainerHighest,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              DateFormat('EEEE, d MMM yyyy').format(date),
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.symmetric(
                inside: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
              columnWidths: const {0: IntrinsicColumnWidth()},
              children: [
                TableRow(
                  decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerLow),
                  children: [
                    const _Cell(text: '', header: true),
                    for (final slot in settings.timeSlots)
                      _Cell(text: slot.rangeLabel, header: true),
                  ],
                ),
                for (final machine in machines)
                  TableRow(
                    children: [
                      _Cell(text: machine.label, header: true, icon: _iconFor(machine.type)),
                      for (var i = 0; i < settings.timeSlots.length; i++)
                        _Cell(
                          text: byMachineSlot['${machine.id}_$i']?.flatName ?? '—',
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(MachineType type) =>
      type == MachineType.washer ? Icons.local_laundry_service_outlined : Icons.dry_outlined;
}

class _Cell extends StatelessWidget {
  const _Cell({required this.text, this.header = false, this.icon});

  final String text;
  final bool header;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: theme.colorScheme.primary),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: header
                  ? theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)
                  : theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
