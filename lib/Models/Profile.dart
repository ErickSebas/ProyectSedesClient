import 'dart:convert';
import 'package:http/http.dart' as http;

class Member {
  late String names;
  late String? lastnames;
  late DateTime? fechaNacimiento;
  late int id;
  late String? role;
  late String? contrasena; // Nuevo atributo
  late String correo;
  late int? telefono;
  late String? carnet;
  late double longitud;
  late double  latitud;
  late DateTime? fechaCreacion;
  late int? status;
  // Nuevo atributo

  Member(
      {required this.names,
      this.lastnames,
      this.fechaNacimiento,
      required this.id,
      this.role,
      this.contrasena, // Nuevo atributo
      required this.correo, // Nuevo atributo
      this.telefono,
      this.carnet,
      required this.latitud,
      required this.longitud,
      this.fechaCreacion,
      this.status});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
        id: json['idPerson'],
        names: json['Nombres'],
        lastnames: json['Apellidos'],
        fechaNacimiento: DateTime.parse(json['FechaNacimiento']),
        correo: json['Correo'],
        contrasena: json['Password'],
        carnet: json['Carnet'],
        telefono: json['Telefono'],
        fechaCreacion: DateTime.parse(json['FechaCreacion']),
        status: json['Status'],
        longitud: json['Longitud'],
        latitud: json['Latitud'],
        role: json['NombreRol']);
  }
factory Member.fromJson2(Map<String, dynamic> json) {

    final result = json['result'];

    return Member(

      names: result['Nombres'],

      id: result['idPerson'],

      correo: result['Correo'],

      latitud: result['Latitud'],

      longitud: result['Longitud'],

      fechaCreacion: result['FechaCreacion'] != null

          ? DateTime.parse(result['FechaCreacion'])

          : null,

    );

  }

  Future<List<Member>> fetchMembers() async {
    final response = await http.get(
        Uri.parse('https://backendapi-398117.rj.r.appspot.com/allaccounts'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final members =
          data.map((memberData) => Member.fromJson(memberData)).toList();
      return members;
    } else {
      throw Exception('Failed to load members');
    }
  }

   
}

Future<Member> getCardByUser(int id) async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/cardholderbyuser/'+id.toString())); 

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final member = Member.fromJson(data);
      return member;
    } else {
      throw Exception('Failed to load members');
    }
  }
  Future<int> getNextIdPerson() async {
  final response = await http.get(Uri.parse(
      'https://backendapi-398117.rj.r.appspot.com/nextidperson')); //////
  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    print(jsonResponse[0]['AUTO_INCREMENT']);
    var res = jsonResponse[0]['AUTO_INCREMENT'];
    return res;
  } else {
    throw Exception('Failed to load id');
  }
}
