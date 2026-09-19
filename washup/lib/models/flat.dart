class Flat {
  const Flat({required this.id, required this.floor, required this.name, this.active = true});

  final String id;
  final int floor;
  final String name;
  final bool active;

  factory Flat.fromJson(Map<String, dynamic> json) => Flat(
        id: json['id'] as String,
        floor: json['floor'] as int,
        name: json['name'] as String,
        active: json['active'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'floor': floor,
        'name': name,
        'active': active,
      };

  Flat copyWith({String? name, bool? active}) => Flat(
        id: id,
        floor: floor,
        name: name ?? this.name,
        active: active ?? this.active,
      );
}

/// Generates flat names like 1A, 1B, ... for [floors] floors and
/// [flatsPerFloor] flats on each floor, preserving any custom names
/// already present in [existing] (matched by id).
List<Flat> generateFlats({
  required int floors,
  required int flatsPerFloor,
  List<Flat> existing = const [],
}) {
  final byId = {for (final f in existing) f.id: f};
  final flats = <Flat>[];
  for (var floor = 1; floor <= floors; floor++) {
    for (var i = 0; i < flatsPerFloor; i++) {
      final letter = String.fromCharCode('A'.codeUnitAt(0) + i);
      final id = 'F$floor$letter';
      final prior = byId[id];
      flats.add(Flat(
        id: id,
        floor: floor,
        name: prior?.name ?? '$floor$letter',
        active: prior?.active ?? true,
      ));
    }
  }
  return flats;
}
