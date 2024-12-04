class ExerciseDetail {
  final int? id;
  final int exerciseId;
  final String date;
  final int series;
  final double weight;
  final String observation;

  ExerciseDetail({
    this.id,
    required this.exerciseId,
    required this.date,
    required this.series,
    required this.weight,
    required this.observation,
  });

  factory ExerciseDetail.fromMap(Map<String, dynamic> map) {
    return ExerciseDetail(
      id: map['id'],
      exerciseId: map['exerciseId'],
      date: map['date'],
      series: map['series'],
      weight: map['weight'],
      observation: map['observation'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
      'date': date,
      'series': series,
      'weight': weight,
      'observation': observation,
    };
  }
}
