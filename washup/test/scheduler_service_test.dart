import 'package:flutter_test/flutter_test.dart';
import 'package:washup/models/flat.dart';
import 'package:washup/models/laundry_settings.dart';
import 'package:washup/models/time_slot.dart';
import 'package:washup/services/scheduler_service.dart';

void main() {
  LaundrySettings buildSettings({
    int floors = 3,
    int flatsPerFloor = 4,
    int washers = 1,
    int dryers = 1,
    int planDays = 30,
    int maxSlotsPerFlatPerDay = 1,
  }) {
    return LaundrySettings(
      floors: floors,
      flatsPerFloor: flatsPerFloor,
      washers: washers,
      dryers: dryers,
      timeSlots: defaultTimeSlots,
      planDays: planDays,
      flats: generateFlats(floors: floors, flatsPerFloor: flatsPerFloor),
      maxSlotsPerFlatPerDay: maxSlotsPerFlatPerDay,
    );
  }

  test('produces one entry per machine per time slot per day', () {
    final settings = buildSettings(planDays: 7);
    final plan = SchedulerService().generatePlan(settings: settings, startDate: DateTime(2026, 1, 1), seed: 1);

    expect(plan.entries.length, settings.totalSlots);
  });

  test('spreads assignments within one slot of each other (no bias)', () {
    final settings = buildSettings(floors: 3, flatsPerFloor: 4, washers: 1, dryers: 1, planDays: 30);
    final plan = SchedulerService().generatePlan(settings: settings, startDate: DateTime(2026, 1, 1), seed: 42);

    final counts = plan.countsByFlat();
    final activeIds = settings.flats.where((f) => f.active).map((f) => f.id);
    final values = [for (final id in activeIds) counts[id] ?? 0];

    final maxV = values.reduce((a, b) => a > b ? a : b);
    final minV = values.reduce((a, b) => a < b ? a : b);
    expect(maxV - minV, lessThanOrEqualTo(1));
  });

  test('never assigns the same flat twice on the same day when there is room', () {
    // 12 flats, 1 washer + 1 dryer, 3 slots/day => 6 appliance-slots/day,
    // well within the 12 available flats, so nobody should repeat in a day.
    final settings = buildSettings(floors: 3, flatsPerFloor: 4, washers: 1, dryers: 1, planDays: 10);
    final plan = SchedulerService().generatePlan(settings: settings, startDate: DateTime(2026, 1, 1), seed: 7);

    final byDay = <DateTime, List<String>>{};
    for (final e in plan.entries) {
      final key = DateTime(e.date.year, e.date.month, e.date.day);
      byDay.putIfAbsent(key, () => []).add(e.flatId);
    }
    for (final flatIds in byDay.values) {
      expect(flatIds.toSet().length, flatIds.length);
    }
  });

  test('carries in historical counts so future plans compensate for the past', () {
    // A single flat, single machine, single time slot per day: exactly one
    // appliance-slot to hand out per day, so the least-used flat always wins.
    final settings = buildSettings(floors: 1, flatsPerFloor: 2, washers: 1, dryers: 0, planDays: 1)
        .copyWith(timeSlots: const [TimeSlot(label: 'Only', start: '00:00', end: '23:59')]);
    // Flat "1A" has already done 50 slots historically, "1B" none.
    final plan = SchedulerService().generatePlan(
      settings: settings,
      startDate: DateTime(2026, 1, 1),
      seed: 3,
      carryInCounts: {'F1A': 50, 'F1B': 0},
    );

    expect(plan.entries.single.flatId, 'F1B');
  });

  test('excluded flats never receive a slot', () {
    final flats = generateFlats(floors: 1, flatsPerFloor: 2);
    final excluded = flats.map((f) => f.id == 'F1A' ? f.copyWith(active: false) : f).toList();
    final settings = buildSettings(floors: 1, flatsPerFloor: 2, washers: 1, dryers: 0, planDays: 5)
        .copyWith(flats: excluded);

    final plan = SchedulerService().generatePlan(settings: settings, startDate: DateTime(2026, 1, 1), seed: 9);

    expect(plan.entries.every((e) => e.flatId != 'F1A'), isTrue);
  });
}
