class Mascota {
  int idMascotas;
  String nombre;
  String raza;
  int edad;
  String color;
  String descripcion;
  int idPersona;
  String sexo;
  int idQr;
  String carnetPropietario; // Nuevo campo añadido

  Mascota({
    required this.idMascotas,
    required this.nombre,
    required this.raza,
    required this.edad,
    required this.color,
    required this.descripcion,
    required this.idPersona,
    required this.sexo,
    required this.idQr,
    required this.carnetPropietario, // Nuevo campo
  });

  factory Mascota.fromJson(Map<String, dynamic> json) {
    return Mascota(
      idMascotas: json['idMascotas'],
      nombre: json['Nombre'],
      raza: json['Raza'],
      edad: json['Edad'],
      color: json['Color'],
      descripcion: json['Descripcion'],
      idPersona: json['IdPersona'],
      sexo: json['Sexo'],
      idQr: json['IdQr'],
      carnetPropietario: json['CarnetPropietario'], // Nuevo campo
    );
  }
}
