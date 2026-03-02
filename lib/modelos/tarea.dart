class Tarea {
  String nombre;
  DateTime fechaLimite;
  bool completada;
  String notas; //

  //Constructor
  Tarea({
    required this.nombre,
    required this.fechaLimite,
    this.completada = false,
    this.notas = '',
  });

  // Para guardar
  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'fechaLimite': fechaLimite.toIso8601String(),
        'completada': completada,
        'notas': notas,
      };

  // Para leer
  factory Tarea.fromJson(Map<String, dynamic> json) => Tarea(
        nombre: json['nombre'] as String,
        fechaLimite: DateTime.parse(json['fechaLimite'] as String),
        completada: (json['completada'] ?? false) as bool,
        notas: (json['notas'] ?? '') as String,
      );

}