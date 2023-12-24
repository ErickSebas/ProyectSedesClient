import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttapp/Models/Mascota.dart';
import 'package:fluttapp/Models/Profile.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/RegisterPet.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/UpdatePet.dart';
import 'package:fluttapp/presentation/screens/Cliente/HomeClient.dart';
import 'package:fluttapp/presentation/screens/ViewMascotaInfo.dart';
import 'package:fluttapp/presentation/services/services_firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ListMascotas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListaMascotas(userId: 0,),
    );
  }
}

class ListaMascotas extends StatefulWidget {
  final int userId;

  const ListaMascotas({super.key, required this.userId});
  @override
  _ListMascotasState createState() => _ListMascotasState();
}

class _ListMascotasState extends State<ListaMascotas> {
  int? idUsuario;
  Member? miembroMascota;
  Map<int, List<File?>> _selectedImages = {};
  List<Mascota> mascotas=[];
  bool isLoadingImages=true;

  @override
  void initState(){
    super.initState();
    fetchMembers(widget.userId).then((value) => {
      mascotas = value,
      loadAllImages(),
      getPersonData()
    });
    
  }

  Future<List<Mascota>> fetchMembers(int idPersona) async {
    final response = await http.get(
        Uri.parse('http://181.188.191.35:3000/propietariomascotas/$idPersona'));

    final List<dynamic> data = json.decode(response.body);
    final members =
        data.map((memberData) => Mascota.fromJson(memberData)).toList();
    return members;
  }

  Future<void> getPersonData() async {
    miembroMascota = await getPersonById(idUsuario!);
  }

  Future<void> loadAllImages() async {
    for (var mascota in mascotas) {
      await addImageUrlsToSelectedImages('cliente', mascota.idPersona, mascota.idMascotas);
    }
    if(mounted){
      setState(() {
        isLoadingImages = false;
      });
    }
    
  }

  Future<void> addImageUrlsToSelectedImages(
  String carpeta, int idCliente, int idMascota) async {
    try {

      List<String> imageUrls = await getImagesUrls(carpeta, idCliente, idMascota);
      List<File?> tempImages = [];

      for (String url in imageUrls) {
        File tempImage = await _downloadImage(url);
        tempImages.add(tempImage);
      }

      setState(() {
        _selectedImages[idMascota] = tempImages;
      });


    } catch (e) {
      print('Error al obtener y descargar las imágenes: $e');
    }
  }

  Future<List<String>> getImagesUrls(
      String carpeta, int idCliente, int idMascota) async {
    List<String> imageUrls = [];

    try {
      Reference storageRef =
          FirebaseStorage.instance.ref('$carpeta/$idCliente/$idMascota');
      ListResult result = await storageRef.list();

      for (var item in result.items) {
        String downloadURL = await item.getDownloadURL();
        imageUrls.add(downloadURL);
      }
    } catch (e) {
      print('Error al obtener URLs de imágenes: $e');
    }

    return imageUrls;
  }

  Future<File> _downloadImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();
      final tempImageFile =
          File('${tempDir.path}/${DateTime.now().toIso8601String()}.jpg');
      await tempImageFile.writeAsBytes(bytes);
      return tempImageFile;
    } else {
      throw Exception('Error al descargar imagen');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ListMascotas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}
