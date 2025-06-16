class Taller {
  final int id;
  final String nombre;
  final String direccion;
  final double latitud;
  final double longitud;
  final String? telefono;
  final String? email;

  Taller({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.latitud,
    required this.longitud,
    this.telefono,
    this.email,
  });

  factory Taller.fromJson(Map<String, dynamic> json) {
    return Taller(
      id: json['id'],
      nombre: json['nombre'],
      direccion: json['direccion'],
      latitud: json['latitud'].toDouble(),
      longitud: json['longitud'].toDouble(),
      telefono: json['telefono']?.toString(),
      email: json['email'],
    );
  }
}
