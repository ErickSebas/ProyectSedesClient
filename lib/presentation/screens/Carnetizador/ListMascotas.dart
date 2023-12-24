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

int? idUsuario;
Member? miembroMascota;
Map<int, List<File?>> _selectedImages = {};

bool isLoadingImages=true;

Future<List<Mascota>> fetchMembers(int idPersona) async {
  final response = await http.get(
      Uri.parse('http://181.188.191.35:3000/propietariomascotas/$idPersona'));

  final List<dynamic> data = json.decode(response.body);
  final members =
      data.map((memberData) => Mascota.fromJson(memberData)).toList();
  return members;
}

@override
void initState() {
  initState();
  getPersonData();
}

Future<void> getPersonData() async {
  miembroMascota = await getPersonById(idUsuario!);
}
/*
Future<List<Mascota>> fetchMembers() async {
  final response =
      await http.get(Uri.parse('http://181.188.191.35:3000/allmascotas'));

  final List<dynamic> data = json.decode(response.body);
  final members =
      data.map((memberData) => Mascota.fromJson(memberData)).toList();
  return members;
}
*/

Future<void> disablePet(int idMascota) async {
  final url = Uri.parse('http://181.188.191.35:3000/disablemascota/$idMascota');
  final response = await http.put(
    url,
    body: jsonEncode({'id': idMascota, 'Status': 0}),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
  } else {
    // Manejar el caso de error si es necesario
  }
}

Future<bool> deletePetFolder(int userId, int petId) async {
  try {
    final firebase_storage.Reference storageRef =
        firebase_storage.FirebaseStorage.instance.ref();

    String carpeta = 'cliente/$userId/$petId';

    // Listamos los elementos en la carpeta de la mascota
    firebase_storage.ListResult listResult =
        await storageRef.child(carpeta).listAll();

    // Eliminamos cada elemento individualmente
    for (var item in listResult.items) {
      await item.delete();
    }

    return true;
  } catch (e) {
    return false;
  }
}

class ListMascotas extends StatefulWidget {
  late final int userId;
  ListMascotas({required this.userId}) {
    idUsuario = this.userId;
  }
  @override
  _ListMascotasState createState() => _ListMascotasState();
}

class _ListMascotasState extends State<ListMascotas> {
  

  @override
  Widget build(BuildContext context) {
    getPersonData();
    return FutureBuilder<List<Mascota>>(
        future: fetchMembers(widget.userId),
        builder: (BuildContext context, AsyncSnapshot<List<Mascota>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: SpinKitCircle(
                      color: Color(0xFF5C8ECB),
                      size: 50.0,
                    ),
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else {
            List<Mascota> mascotas = snapshot.data!;
            return Scaffold(
              appBar:mascotas.isEmpty?  AppBar(
                  leading: Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.arrow_back) ,color: Colors.black,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  backgroundColor: Color.fromARGB(255, 241, 245, 255),
                  title: Text(
                    'Lista de Mascota',
                    style: TextStyle(color: Colors.black),
                  ),
                  centerTitle: true,
                ):null,
                body: mascotas.isEmpty? Center(child: Text("No tienes Mascotas"),): CampaignPage(mascotas: mascotas, userId: widget.userId),
                floatingActionButton: /*miembroActual!.role=="Cliente"?null:*/ FloatingActionButton(
                  onPressed: () async {
                    if (miembroMascota?.latitud == 0.1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Actualiza tus datos para poder usar esta opcion')),
                      );
                    } else {
                      final res = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPet(
                              userId: idUsuario!,
                            ), // Pasa el ID del usuario aquí
                          ));

                      if(res!=null){
                        setState(() {
                          
                        });
                      }
                    }
                  },
                  child: Icon(Icons.add_box),
                  backgroundColor: Color(0xFF5C8ECB),
                ));
          }
        },
    );
  }
}

class CampaignPage extends StatefulWidget {
  List<Mascota> mascotas;
  int userId;

  CampaignPage({required this.mascotas, required this.userId});

  @override
  _CampaignPageState createState() => _CampaignPageState();
}

class _CampaignPageState extends State<CampaignPage> {
  String filtro = '';

  void eliminarMascota(int index) {
    setState(() {
      widget.mascotas.removeAt(index);
    });
  }

  @override
  void initState(){
    super.initState();
    loadAllImages();
  }

  Future<void> loadAllImages() async {
    for (var mascota in widget.mascotas) {
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
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.arrow_back) ,color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          backgroundColor: Color.fromARGB(255, 241, 245, 255),
          title: Text(
            'Lista de Mascota',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
      body:  Container(
        color: Colors.white,
      /*decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/Splash.png'),
          fit: BoxFit.cover,
        ),
      ),*/
      child: Column(
        children: <Widget>[
          Card(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  filtro = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                labelText: 'Buscar',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlueAccent),
                ),
              ),
            ),
          ),
          Expanded(
            child: SlidableAutoCloseBehavior(
              child: ListView.builder(
                itemCount: widget.mascotas.length,
                itemBuilder: (context, index) {
                  
                  final mascota = widget.mascotas[index];
                  if (filtro.isNotEmpty &&
                      !(mascota.nombre.toLowerCase().contains(filtro) ||
                          mascota.raza.toLowerCase().contains(filtro) ||
                          mascota.carnetPropietario
                              .toString()
                              .contains(filtro))) {
                    return Container();
                  }

                  return  Slidable(
                    endActionPane: /*miembroActual!.role=="Cliente"?null:*/ ActionPane(
                      motion: StretchMotion(),
                      children: [
                        SlidableAction(
                          onPressed: ((context) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Confirmación"),
                                  content: Text(
                                      "¿Estás seguro de que quieres eliminar este registro?"),
                                  actions: [
                                    TextButton(
                                      child: Text("Cancelar"),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Cierra el cuadro de diálogo
                                      },
                                    ),
                                    TextButton(
                                      child: Text("Eliminar"),
                                      onPressed: () async {
                                        await showLoadingDialog(context, () async {
                                          disablePet(mascota.idMascotas);
                                          deletePetFolder(mascota.idPersona,
                                              mascota.idMascotas);
                                          eliminarMascota(index);
                                        });
                                        showSnackbar(context, "Eliminado con éxito");
                                        Navigator.of(context)
                                            .pop(); 
                                        /*mostrarFinalizar.Mostrar_Finalizados(
                                            context,
                                            "Registro Eliminado con éxito");*/
                                        //refreshMembersList();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }),
                          borderRadius: BorderRadius.circular(20),
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                        ),
                        SlidableAction(
                          onPressed: ((context) async {
                            final res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdatePet(mascota),
                              ),
                            );
                            if(res!=null){
                              await loadAllImages();
                              widget.mascotas = await fetchMembers(widget.userId);
                              setState(() {
                                
                              });
                            }
                          }),
                          borderRadius: BorderRadius.circular(20),
                          backgroundColor: Color(0xFF5C8ECB),
                          icon: Icons.edit,
                        ),
                      ],
                    ),
                    child: Card(
                      margin: EdgeInsets.all(10),
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        leading: Stack(
  alignment: Alignment.center,
  children: [
    CircleAvatar(
      backgroundImage: (_selectedImages[widget.mascotas[index].idMascotas] != null && _selectedImages[widget.mascotas[index].idMascotas]!.isNotEmpty)
          ? FileImage(_selectedImages[widget.mascotas[index].idMascotas]![0]!)
          : null,
      radius: 30,
    ),
    if (_selectedImages.isEmpty || (_selectedImages[widget.mascotas[index].idMascotas]?.isEmpty ?? true))
      SizedBox(
        width: 60, 
        height: 60, 
        child: SpinKitCircle(
          color:Colors.white,
        ),
      ),
  ],
),



                        title: Text(
                          mascota.nombre,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white.withOpacity(0.6),
                          size: 18.0,
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewMascotasInfo(mascota),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
