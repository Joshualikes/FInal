class Workout {
  final int? id;
  final String title;
  final String details;
  final int duration;

  Workout({this.id, required this.title, required this.details, required this.duration});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'details': details,
      'duration': duration,
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      title: map['title'],
      details: map['details'],
      duration: map['duration'],
    );
  }
}