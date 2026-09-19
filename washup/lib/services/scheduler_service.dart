import 'dart:math';

import '../models/laundry_plan.dart';
import '../models/laundry_settings.dart';
import '../models/machine.dart';
import '../models/schedule_entry.dart';

/// Generates a laundry rota that is fair "without bias": every eligible flat
/// ends up within one appliance-slot of every other flat over the plan
/// period, and ties between equally-deserving flats are broken with a
/// shuffled random draw rather than list order (list-order bias is exactly
/// what produces the lopsided, same-names-every-week rota this app
/// replaces).
///
/// Algorithm (fair queueing):
///  1. Track how many slots each flat has been assigned so far, seeded from
///     [carryInCounts] so fairness accumulates across plan periods instead
///     of resetting every time.
///  2. For every appliance slot, on every day, restrict candidates to flats
///     that haven't already hit [LaundrySettings.maxSlotsPerFlatPerDay] for
///     that day (falling back to the full active list only if everyone has
///     hit the cap, e.g. very few flats vs. many machines).
///  3. Among candidates, find the minimum running total, take every flat
///     tied at that minimum, and pick one uniformly at random.
///  4. Increment that flat's running and daily counts and move on.
///
/// This keeps the max-vs-min gap in total assignments to at most one slot
/// for the whole period, with no positional or alphabetical favoritism.
class SchedulerService {
  LaundryPlan generatePlan({
    required LaundrySettings settings,
    required DateTime startDate,
    Map<String, int> carryInCounts = const {},
    int? seed,
  }) {
    final activeFlats = settings.flats.where((f) => f.active).toList();
    if (activeFlats.isEmpty) {
      throw StateError('Add at least one active flat before generating a plan.');
    }
    final machines = generateMachines(washers: settings.washers, dryers: settings.dryers);
    if (machines.isEmpty) {
      throw StateError('Add at least one washing machine or dryer.');
    }

    final usedSeed = seed ?? Random().nextInt(1 << 31);
    final random = Random(usedSeed);

    final counts = <String, int>{
      for (final f in activeFlats) f.id: carryInCounts[f.id] ?? 0,
    };

    final entries = <ScheduleEntry>[];
    final day0 = DateTime(startDate.year, startDate.month, startDate.day);

    for (var d = 0; d < settings.planDays; d++) {
      final date = day0.add(Duration(days: d));
      final dayCounts = <String, int>{for (final f in activeFlats) f.id: 0};

      for (var slotIndex = 0; slotIndex < settings.timeSlots.length; slotIndex++) {
        for (final machine in machines) {
          var candidates = activeFlats
              .where((f) => dayCounts[f.id]! < settings.maxSlotsPerFlatPerDay)
              .toList();
          if (candidates.isEmpty) {
            // Everyone already hit the daily cap (more slots than flats
            // allow) - fall back to the full roster, still ranked fairly.
            candidates = activeFlats;
          }

          final minCount = candidates.map((f) => counts[f.id]!).reduce(min);
          final tier = candidates.where((f) => counts[f.id] == minCount).toList();
          tier.shuffle(random);
          final chosen = tier.first;

          counts[chosen.id] = counts[chosen.id]! + 1;
          dayCounts[chosen.id] = dayCounts[chosen.id]! + 1;

          entries.add(ScheduleEntry(
            date: date,
            timeSlotIndex: slotIndex,
            machineId: machine.id,
            machineType: machine.type,
            machineLabel: machine.label,
            flatId: chosen.id,
            flatName: chosen.name,
          ));
        }
      }
    }

    return LaundryPlan(
      generatedAt: DateTime.now(),
      startDate: day0,
      entries: entries,
      fairnessSeed: usedSeed,
    );
  }
}
