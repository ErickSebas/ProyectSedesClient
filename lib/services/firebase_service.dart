/// <summary>
/// Nombre de la aplicación: MaYpiVaC
/// Nombre del desarrollador: Equipo-Sedes-Univalle
/// Fecha de creación: 18/08/2023
/// </summary>
///
// <copyright file="firebase_service.dart" company="Sedes-Univalle">
// Esta clase está restringida para su uso, sin la previa autorización de Sedes-Univalle.
// </copyright>
// <author>Pedro Conde</author>

import "dart:convert";
import 'package:http/http.dart' as http;
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_storage/firebase_storage.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;

List<dynamic> lstlinks = [];
List<dynamic> locations = [];
List<Marker> lstMarcadores = [];
List<dynamic> lstVersions = [];
// Obtener el archivo de Firebase Storage
Future<List<Map<String, dynamic>>> Obtener_Archivo() async {
  List<Map<String, dynamic>> lstUbicaciones = [];
  Reference ref = storage.ref().child('ubications.json');
  var datosUrl = await ref.getDownloadURL();
  var response = await http.get(Uri.parse(datosUrl));
  if (response.statusCode == 200) {
    var jsonList = jsonDecode(response.body) as List;
    lstUbicaciones = 
        jsonList.map((item) => item as Map<String, dynamic>).toList();
  }
  return lstUbicaciones;
}

// Obtener el archivo de Firebase Storage
Future<List> Obtener_Links() async {
  List lstLinks = [];
  Reference ref = storage.ref().child('links.json');
  var datosUrl = await ref.getDownloadURL();
  var response = await http.get(Uri.parse(datosUrl));
  if (response.statusCode == 200) {
    var jsonList = jsonDecode(response.body) as List;
    lstLinks = jsonList.map((item) => item).toList();
  }
  return lstLinks;
}

// Obtener el archivo de Firebase Storage
Future<List> Obtener_Version() async {
  List lstVersions = [];
  Reference ref = storage.ref().child('version.json');
  var datosUrl = await ref.getDownloadURL();
  var response = await http.get(Uri.parse(datosUrl));
  if (response.statusCode == 200) {
    var jsonList = jsonDecode(response.body) as List;
    lstVersions = jsonList.map((item) => item).toList();
  }
  return lstVersions;
}
