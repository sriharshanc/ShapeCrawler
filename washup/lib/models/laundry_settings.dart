import 'flat.dart';
import 'time_slot.dart';

class LaundrySettings {
  const LaundrySettings({
    required this.floors,
    required this.flatsPerFloor,
    required this.washers,
    required this.dryers,
    required this.timeSlots,
    required this.planDays,
    required this.flats,
    this.maxSlotsPerFlatPerDay = 1,
  });

  final int floors;
  final int flatsPerFloor;
  final int washers;
  final int dryers;
  final List<TimeSlot> timeSlots;

  /// How many days the generated plan should cover (e.g. 30 for a month).
  final int planDays;

  /// Every flat in the building, in generation order. Names are editable by
  /// the user, so this is the source of truth for who participates.
  final List<Flat> flats;

  /// Soft cap on how many appliance slots a single flat may receive on the
  /// same calendar day before the scheduler is forced to repeat someone.
  final int maxSlotsPerFlatPerDay;

  int get totalFlats => flats.length;
  int get activeFlats => flats.where((f) => f.active).length;
  int get machinesPerSlot => washers + dryers;
  int get slotsPerDay => timeSlots.length * machinesPerSlot;
  int get totalSlots => slotsPerDay * planDays;

  static LaundrySettings initial() {
    final flats = generateFlats(floors: 3, flatsPerFloor: 4);
    return LaundrySettings(
      floors: 3,
      flatsPerFloor: 4,
      washers: 1,
      dryers: 1,
      timeSlots: defaultTimeSlots,
      planDays: 30,
      flats: flats,
    );
  }

  LaundrySettings copyWith({
    int? floors,
    int? flatsPerFloor,
    int? washers,
    int? dryers,
    List<TimeSlot>? timeSlots,
    int? planDays,
    List<Flat>? flats,
    int? maxSlotsPerFlatPerDay,
  }) {
    return LaundrySettings(
      floors: floors ?? this.floors,
      flatsPerFloor: flatsPerFloor ?? this.flatsPerFloor,
      washers: washers ?? this.washers,
      dryers: dryers ?? this.dryers,
      timeSlots: timeSlots ?? this.timeSlots,
      planDays: planDays ?? this.planDays,
      flats: flats ?? this.flats,
      maxSlotsPerFlatPerDay: maxSlotsPerFlatPerDay ?? this.maxSlotsPerFlatPerDay,
    );
  }

  factory LaundrySettings.fromJson(Map<String, dynamic> json) => LaundrySettings(
        floors: json['floors'] as int,
        flatsPerFloor: json['flatsPerFloor'] as int,
        washers: json['washers'] as int,
        dryers: json['dryers'] as int,
        timeSlots: (json['timeSlots'] as List)
            .map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
            .toList(),
        planDays: json['planDays'] as int,
        flats: (json['flats'] as List)
            .map((e) => Flat.fromJson(e as Map<String, dynamic>))
            .toList(),
        maxSlotsPerFlatPerDay: json['maxSlotsPerFlatPerDay'] as int? ?? 1,
      );

  Map<String, dynamic> toJson() => {
        'floors': floors,
        'flatsPerFloor': flatsPerFloor,
        'washers': washers,
        'dryers': dryers,
        'timeSlots': timeSlots.map((e) => e.toJson()).toList(),
        'planDays': planDays,
        'flats': flats.map((e) => e.toJson()).toList(),
        'maxSlotsPerFlatPerDay': maxSlotsPerFlatPerDay,
      };
}
