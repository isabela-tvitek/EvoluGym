class Exercise {
  final int? id;
  final String name;  // Nome do exercício
  final String type;  // Tipo do exercício
  final bool completed; // Status de completado (true ou false)

  Exercise({
    this.id,
    required this.name,
    required this.type,
    this.completed = false,
  });

  // Método para criar um exercício a partir de um JSON
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'], // Ajuste conforme a API
      type: json['type'], // Tipo do exercício (ajuste conforme a API)
      completed: json['completed'] ?? false,
    );
  }

  // Método para converter um exercício em um formato JSON para enviar à API
  Map<String, dynamic> toJson() {
    return {
      'name': name,       // 'name' é o campo da API
      'type': type,       // 'type' é o campo da API
      'completed': completed,  // 'completed' é o campo da API
    };
  }
}
