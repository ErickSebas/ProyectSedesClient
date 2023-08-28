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

FirebaseFirestore db  = FirebaseFirestore.instance;
FirebaseStorage storage  = FirebaseStorage.instance;

// Obtener el archivo de Firebase Storage
Future<List> Obtener_Archivo() async {
  List lstUbicaciones = [];
  Reference ref = storage.ref().child('ubications.json');
  var datosUrl = await ref.getDownloadURL();
  var response = await http.get(Uri.parse(datosUrl));
  if (response.statusCode == 200) {
    var jsonList = jsonDecode(response.body) as List;
    lstUbicaciones = jsonList.map((item) => item).toList();
  }
  return lstUbicaciones;
}


 