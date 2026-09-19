class TimeSlot {
  const TimeSlot({required this.label, required this.start, required this.end});

  final String label;
  final String start;
  final String end;

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
        label: json['label'] as String,
        start: json['start'] as String,
        end: json['end'] as String,
      );

  Map<String, dynamic> toJson() => {'label': label, 'start': start, 'end': end};

  String get rangeLabel => '$start - $end';

  TimeSlot copyWith({String? label, String? start, String? end}) => TimeSlot(
        label: label ?? this.label,
        start: start ?? this.start,
        end: end ?? this.end,
      );
}

const defaultTimeSlots = <TimeSlot>[
  TimeSlot(label: 'Morning', start: '07:00', end: '12:00'),
  TimeSlot(label: 'Afternoon', start: '12:00', end: '17:00'),
  TimeSlot(label: 'Evening', start: '17:00', end: '22:00'),
];
