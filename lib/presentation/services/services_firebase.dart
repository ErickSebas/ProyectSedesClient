/// <summary>
/// Nombre de la aplicación: AdminMaYpiVaC
/// Nombre del desarrollador: Equipo-Sedes-Univalle
/// Fecha de creación: 18/08/2023
/// </summary>
/// 
// <copyright file="services_firebase.dart" company="Sedes-Univalle">
// Esta clase está restringida para su uso, sin la previa autorización de Sedes-Univalle.
// </copyright>


import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttapp/Models/Profile.dart';



import 'package:flutter/material.dart';



FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;
double? proceso = 0.0;
Member? miembroActual;
bool esCarnetizador = false;
int idCamp = 0;
int isLogin = 0;

Future<void> eliminarArchivoDeStorage(int id) async {
  Reference ref = storage.ref().child('campana' + id.toString() + '.json');
  try {
    await ref.delete();
    print("Archivo eliminado correctamente.");
  } catch (e) {
    print("Error al eliminar el archivo: $e");
  }
}

  void Mostrar_Error(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: Text(errorMessage),
        actions: <Widget>[
          TextButton(
            child: Text('Aceptar', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


 /* void Mostrar_Finalizado(BuildContext context, String texto) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 50),
            SizedBox(height: 10),
            Text(texto),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Hecho', style: TextStyle(color: Colors.black),),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ChangeNotifierProvider(create: (context) => CampaignProvider(), 
                child: CampaignPage())),
              );
            },
          ),
        ],
      );
    },
  );
}
*/
  Future<void> Mostrar_Mensaje(BuildContext context, String texto)async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 50),
            SizedBox(height: 10),
            Text(texto),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Hecho', style: TextStyle(color: Colors.black),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}




