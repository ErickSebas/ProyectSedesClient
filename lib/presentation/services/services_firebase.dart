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
import 'package:http/http.dart' as http;


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';



FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;
double? proceso = 0.0;
Member? miembroActual = Member(names: '', id: 0, correo: '', latitud: 0.1, longitud: 0.1);
bool esCarnetizador = false;
int idCamp = 0;
int isLogin = 0;
final ImagePicker _picker = ImagePicker();

Future<void> eliminarArchivoDeStorage(int id) async {
  Reference ref = storage.ref().child('campana' + id.toString() + '.json');
  try {
    await ref.delete();
    print("Archivo eliminado correctamente.");
  } catch (e) {
    print("Error al eliminar el archivo: $e");
  }
}

  Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load(path);

  final file = File('${(await getTemporaryDirectory()).path}/usuario.png');
  await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

final myColorMaterial = createMaterialColor(Color(0xFF5C8ECB));


  void Mostrar_Error1(BuildContext context, String errorMessage) {
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

void showPicker(context, Function(File) onFileSelected) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Galería'),
                    onTap: () async {
                      final XFile? image = await _imgFromGallery();
                      Navigator.of(context).pop();
                      if (image != null) {
                        File fileImage = File(image.path);
                        onFileSelected(fileImage);
                      }
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Cámara'),
                  onTap: () async {
                    final XFile? image = await _imgFromCamera();
                    Navigator.of(context).pop();
                    if (image != null) {
                      File fileImage = File(image.path);
                      onFileSelected(fileImage);
                    }
                  },
                ),
              ],
            ),
          );
        }
    );
  }

  Future<XFile?> _imgFromCamera() async {
    final XFile? image = await _picker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );
    return image;
  }

  Future<XFile?> _imgFromGallery() async {
    final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );
    return image;
  }

  Future<void> showLoadingDialog(BuildContext context, Future<void> Function() asyncFunction) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            Container(margin: EdgeInsets.only(left: 7), child: Text("Cargando...")),
          ],
        ),
      );
    },
  );
  try {
    await asyncFunction();
  } catch (e) {
    showSnackbar(context, "Error: "+e.toString());
  } finally {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

void showSnackbar(BuildContext context, String message, {int durationSeconds = 3}) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: Duration(seconds: durationSeconds),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

  Future<String> getAddressFromLatLng(
      double lat, double lng, String apiKey) async {
    final url = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {'latlng': '$lat,$lng', 'key': apiKey},
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['status'] == 'OK' && json['results'].isNotEmpty) {
        return json['results'][0]['formatted_address'];
      }
    }

    return 'No se pudo obtener la dirección';
  }

  Future<void> launchWhatsApp(String phone) async {
  // Añade el código de país (+591) y el símbolo de WhatsApp
  final fullPhone = '+591$phone';
  final url = 'https://wa.me/$fullPhone'; // URL para abrir WhatsApp

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'No se pudo abrir WhatsApp';
  }
}






