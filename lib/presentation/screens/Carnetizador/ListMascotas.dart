import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fluttapp/Models/Mascota.dart';
import 'package:fluttapp/Models/Profile.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/RegisterPet.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/UpdatePet.dart';
import 'package:fluttapp/presentation/screens/Cliente/HomeClient.dart';
import 'package:fluttapp/presentation/screens/ViewMascotaInfo.dart';
import 'package:fluttapp/presentation/services/services_firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;

int? idUsuario;


Future<List<Mascota>> fetchMembers(int idPersona) async {
  final response = await http.get(
      Uri.parse('http://181.188.191.35:3000/propietariomascotas/$idPersona'));

  final List<dynamic> data = json.decode(response.body);
  final members =
      data.map((memberData) => Mascota.fromJson(memberData)).toList();
  return members;
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
  print("Deshabilitando mascota con ID: $idMascota");
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

Future<bool> deleteImages(int userId, int petId) async {
  try {
    final firebase_storage.Reference storageRef =
        firebase_storage.FirebaseStorage.instance.ref();

    String carpeta = 'cliente/$userId/$petId';

    // Elimina la carpeta con el nombre del ID de la mascota
    await storageRef.child(carpeta).delete();

    return true;
  } catch (e) {
    print('Error al eliminar imágenes: $e');
    return false;
  }
}

class ListMascotas extends StatelessWidget {
  late final int userId;
  ListMascotas({required this.userId}) {
    idUsuario = this.userId;
    print('ID de usuario en Lista mascotas: $idUsuario');
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<List<Mascota>>(
        future: fetchMembers(userId),
        builder: (BuildContext context, AsyncSnapshot<List<Mascota>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
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
                appBar: AppBar(
                  backgroundColor: Color.fromARGB(255, 241, 245, 255),
                  title: Text(
                    'Mascotas',
                    style:
                        TextStyle(color: const Color.fromARGB(255, 70, 65, 65)),
                  ),
                  centerTitle: true,
                ),
                body: CampaignPage(mascotas: mascotas),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    print("Usuario que se esta yendo a la otra pagina es");
                    print(loggedInPerson?.id);
                    print(loggedInPerson?.names);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPet(
                            userId: idUsuario!,
                          ), // Pasa el ID del usuario aquí
                        ));
                  },
                  child: Icon(Icons.add_box),
                  backgroundColor: Color(0xFF5C8ECB),
                ));
          }
        },
      ),
    );
  }
}

class CampaignPage extends StatefulWidget {
  final List<Mascota> mascotas;

  CampaignPage({required this.mascotas});

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
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/Splash.png'),
          fit: BoxFit.cover,
        ),
      ),
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

                  return Slidable(
                    endActionPane: ActionPane(
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
                                      onPressed: () {
                                        // Aquí se ejecuta la función deleteUser si el usuario confirma
                                        disablePet(mascota.idMascotas);
                                        deleteImages(mascota.idPersona,
                                            mascota.idMascotas);
                                        eliminarMascota(index);
                                        print("id" +
                                            mascota.idMascotas.toString());
                                        Navigator.of(context)
                                            .pop(); // Cierra el cuadro de diálogo
                                        mostrarFinalizar.Mostrar_Finalizados(
                                            context,
                                            "Registro Eliminado con éxito");
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
                          onPressed: ((context) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdatePet(mascota),
                              ),
                            );
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
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('assets/Perro.png'),
                          radius: 30,
                        ),
                        title: Text(
                          mascota.nombre,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: () => Navigator.pushReplacement(
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
    );
  }
}
