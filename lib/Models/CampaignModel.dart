import 'dart:convert';

import 'package:http/http.dart' as http;



class Campaign {
  final int id;

  final String nombre;

  final String descripcion;

  final String categoria;

  final DateTime dateStart;
  final DateTime dateEnd;
  final int userId;

  Campaign(
      {required this.id,
      required this.nombre,
      required this.descripcion,
      required this.categoria,
      required this.dateStart,
      required this.dateEnd,
      required this.userId});

  // Constructor desde JSON

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['idCampañas'],
      nombre: json['NombreCampaña'],
      descripcion: json['Descripcion'],
      categoria: json['Categoria'],
      dateStart: DateTime.parse(json['FechaInicio']),
      dateEnd: DateTime.parse(json['FechaFinal']),
      userId: json['userId'],
    );
  }
}

late List<Campaign> campaigns = [];

Future<List<Campaign>> fetchCampaigns() async {
  final response = await http
    .get(Uri.parse('http://181.188.191.35:3000/campanas'));
  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Campaign.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load Campana');
  }
}
