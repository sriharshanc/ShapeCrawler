import 'machine.dart';

class ScheduleEntry {
  const ScheduleEntry({
    required this.date,
    required this.timeSlotIndex,
    required this.machineId,
    required this.machineType,
    required this.machineLabel,
    required this.flatId,
    required this.flatName,
  });

  final DateTime date;
  final int timeSlotIndex;
  final String machineId;
  final MachineType machineType;
  final String machineLabel;
  final String flatId;
  final String flatName;

  factory ScheduleEntry.fromJson(Map<String, dynamic> json) => ScheduleEntry(
        date: DateTime.parse(json['date'] as String),
        timeSlotIndex: json['timeSlotIndex'] as int,
        machineId: json['machineId'] as String,
        machineType: MachineType.values.byName(json['machineType'] as String),
        machineLabel: json['machineLabel'] as String,
        flatId: json['flatId'] as String,
        flatName: json['flatName'] as String,
      );

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'timeSlotIndex': timeSlotIndex,
        'machineId': machineId,
        'machineType': machineType.name,
        'machineLabel': machineLabel,
        'flatId': flatId,
        'flatName': flatName,
      };
}
