class VehiculoDetalleLogic {
  final Map<String, dynamic> vehiculo;

  VehiculoDetalleLogic(this.vehiculo);

  List<Map<String, String>> obtenerDetalles() {
    return [
      {"label": "Matrícula", "value": vehiculo["matricula"].toString()},
      {"label": "Marca", "value": vehiculo["marca"].toString()},
      {"label": "Motor", "value": vehiculo["motor"].toString()},
      {"label": "Potencia", "value": "${vehiculo["potencia"]} CV"},
      {"label": "Año", "value": vehiculo["anyo"].toString()},
    ];
  }
}
