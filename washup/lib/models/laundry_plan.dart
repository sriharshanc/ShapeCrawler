import 'schedule_entry.dart';

class LaundryPlan {
  const LaundryPlan({
    required this.generatedAt,
    required this.startDate,
    required this.entries,
    required this.fairnessSeed,
  });

  final DateTime generatedAt;
  final DateTime startDate;
  final List<ScheduleEntry> entries;

  /// Random seed used to generate this plan, kept for transparency /
  /// reproducibility (shown to tenants who want to verify fairness).
  final int fairnessSeed;

  /// How many appliance-slots each flat (by id) received in this plan.
  Map<String, int> countsByFlat() {
    final counts = <String, int>{};
    for (final e in entries) {
      counts[e.flatId] = (counts[e.flatId] ?? 0) + 1;
    }
    return counts;
  }

  factory LaundryPlan.fromJson(Map<String, dynamic> json) => LaundryPlan(
        generatedAt: DateTime.parse(json['generatedAt'] as String),
        startDate: DateTime.parse(json['startDate'] as String),
        entries: (json['entries'] as List)
            .map((e) => ScheduleEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
        fairnessSeed: json['fairnessSeed'] as int,
      );

  Map<String, dynamic> toJson() => {
        'generatedAt': generatedAt.toIso8601String(),
        'startDate': startDate.toIso8601String(),
        'entries': entries.map((e) => e.toJson()).toList(),
        'fairnessSeed': fairnessSeed,
      };
}
