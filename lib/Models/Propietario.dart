class Propietario {
  int idPerson;
  String nombres;
  String apellidos;
  DateTime fechaNacimiento;
  String correo;
  String password;
  String carnet;
  int telefono;
  DateTime fechaCreacion;
  int status;
  double longitud;
  double latitud;
  int idRol;

  Propietario({
    required this.idPerson,
    required this.nombres,
    required this.apellidos,
    required this.fechaNacimiento,
    required this.correo,
    required this.password,
    required this.carnet,
    required this.telefono,
    required this.fechaCreacion,
    required this.status,
    required this.longitud,
    required this.latitud,
    required this.idRol,
  });

  factory Propietario.fromJson(Map<String, dynamic> json) {
    return Propietario(
      idPerson: json['idPerson'],
      nombres: json['Nombres'],
      apellidos: json['Apellidos'],
      fechaNacimiento: DateTime.parse(json['FechaNacimiento']),
      correo: json['Correo'],
      password: json['Password'],
      carnet: json['Carnet'],
      telefono: json['Telefono'],
      fechaCreacion: DateTime.parse(json['FechaCreacion']),
      status: json['Status'],
      longitud: json['Longitud'],
      latitud: json['Latitud'],
      idRol: json['IdRol'],
    );
  }
}
