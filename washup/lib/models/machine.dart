enum MachineType { washer, dryer }

class Machine {
  const Machine({required this.id, required this.type, required this.label});

  final String id;
  final MachineType type;
  final String label;

  factory Machine.fromJson(Map<String, dynamic> json) => Machine(
        id: json['id'] as String,
        type: MachineType.values.byName(json['type'] as String),
        label: json['label'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'label': label,
      };
}

List<Machine> generateMachines({required int washers, required int dryers}) {
  final machines = <Machine>[];
  for (var i = 1; i <= washers; i++) {
    machines.add(Machine(id: 'W$i', type: MachineType.washer, label: 'Washer $i'));
  }
  for (var i = 1; i <= dryers; i++) {
    machines.add(Machine(id: 'D$i', type: MachineType.dryer, label: 'Dryer $i'));
  }
  return machines;
}
