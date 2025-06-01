class Habit {
  String? id;
  String name;
  String frequency;
  String category;
  bool completed;
  DateTime createdAt;
  int streak;
  List<DateTime> completionDates;

  Habit({
    this.id,
    required this.name,
    required this.frequency,
    required this.category,
    this.completed = false,
    required this.createdAt,
    this.streak = 0,
    this.completionDates = const [],
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'frequency': frequency,
    'category': category,
    'completed': completed,
    'createdAt': createdAt.toIso8601String(),
    'streak': streak,
    'completionDates': completionDates.map((d) => d.toIso8601String()).toList(),
  };

  factory Habit.fromMap(Map<String, dynamic> map, String id) => Habit(
    id: id,
    name: map['name'],
    frequency: map['frequency'],
    category: map['category'] ?? 'General',
    completed: map['completed'],
    createdAt: DateTime.parse(map['createdAt']),
    streak: map['streak'] ?? 0,
    completionDates: (map['completionDates'] as List<dynamic>?)
        ?.map((d) => DateTime.parse(d))
        .toList() ??
        [],
  );
}