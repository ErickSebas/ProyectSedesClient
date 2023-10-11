import 'dart:convert';
import 'package:crypto/crypto.dart';
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
    names: json['Nombres'] ?? '',
    lastnames: json['Apellidos'] ?? '',
    fechaNacimiento: json['FechaNacimiento'] != null 
        ? DateTime.parse(json['FechaNacimiento']) 
        : null, 
    correo: json['Correo'] ?? '',
    contrasena: json['Password'] ?? '',
    carnet: json['Carnet'] ?? '',
    telefono: json['Telefono'] ?? 0,
    fechaCreacion: json['FechaCreacion'] != null 
        ? DateTime.parse(json['FechaCreacion']) 
        : null, 
    status: json['Status'],
    longitud: json['Longitud'],
    latitud: json['Latitud'],
    role: json['NombreRol'] 
  );
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

  @override
  String toString() {
    return 'Member(names: $names, lastnames: $lastnames, fechaNacimiento: $fechaNacimiento, role: $role, contrasena: $contrasena, correo: $correo, telefono: $telefono, carnet: $carnet, longitud: $longitud, latitud: $latitud, fechaCreacion: $fechaCreacion, status: $status)';
  }

  Future<List<Member>> fetchMembers() async {
    final response = await http.get(
        Uri.parse('http://181.188.191.35:3000/allaccounts'));

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
        Uri.parse('http://181.188.191.35:3000/cardholderbyuser/'+id.toString())); 

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final member = Member.fromJson(data);
      return member;
    } else {
      throw Exception('Failed to load members');
    }
  }

  Future<Member> getPersonByEMail(String email) async {
    final response = await http.get(
        Uri.parse('http://181.188.191.35:3000/personbyemail/'+email)); 

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final member = Member.fromJson(data);
      return member;
    } else {
      throw Exception('Failed to load member');
    }
  }


  Future<int> getNextIdPerson() async {
  final response = await http.get(Uri.parse(
      'http://181.188.191.35:3000/nextidperson')); //////
  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    print(jsonResponse[0]['AUTO_INCREMENT']);
    var res = jsonResponse[0]['AUTO_INCREMENT'];
    return res;
  } else {
    throw Exception('Failed to load id');
  }
}

  Future<int> registerUser2(Member miembro) async {
    print(miembro.toString());
    final url = Uri.parse('http://181.188.191.35:3000/register');
    var idRol=0;
    if (miembro.role == 'Carnetizador') {
      idRol = 3;
    } else if (miembro.role == 'Cliente') {
      idRol = 4;
    }else if(miembro.role==null){
      idRol = 4;
    }
    String? md5Password = null;
    if(miembro.contrasena!=null)
    md5Password = md5.convert(utf8.encode(miembro.contrasena!)).toString();

    final response = await http.post(
      url,
      body: jsonEncode({
        'Nombres': miembro.names,
        'Apellidos': miembro.lastnames,
        'FechaNacimiento': miembro.fechaNacimiento?.toIso8601String(),
        'FechaCreacion': miembro.fechaCreacion?.toIso8601String(),
        'Carnet': miembro.carnet,
        'Telefono': miembro.telefono,
        'IdRol': idRol,
        'Latitud': miembro.latitud,
        'Longitud': miembro.longitud,
        'Correo': miembro.correo,
        'Password': md5Password, 
        'Status': miembro.status,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200||response.statusCode==400) {
      return 1;
    } 
    else{
      return 0;
    }
  }