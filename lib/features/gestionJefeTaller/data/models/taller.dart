class Taller {
  final int id;
  final String nombre;
  final String direccion;
  final int telefono;
  final String email;
  final double latitud;
  final double longitud;

  Taller({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.email,
    required this.latitud,
    required this.longitud,
  });

  factory Taller.fromJson(Map<String, dynamic> json) {
    return Taller(
      id: json['id'],
      nombre: json['nombre'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      email: json['email'],
      latitud: json['latitud'],
      longitud: json['longitud'],
    );
  }
}
