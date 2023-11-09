import 'dart:convert';
import 'package:fluttapp/Models/Profile.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/ListMascotas.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/ProfilePage.dart';
import 'package:fluttapp/presentation/screens/Cliente/HomeClient.dart';
import 'package:fluttapp/presentation/screens/RegisterUpdate.dart';
import 'package:fluttapp/presentation/services/alert.dart';
import 'package:fluttapp/presentation/services/services_firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

 // Variable para almacenar los datos de la persona autenticada
int? useridROL;

class ListMembersScreen extends StatefulWidget {
  late final Member? userData;
  final int userId;
  ListMembersScreen({required this.userId}) {
    useridROL = this.userId;
    print('ID de usuario en Buscar Clientes: $useridROL');
  }

  @override
  _ListMembersScreenState createState() => _ListMembersScreenState();
}

Future<Member?> getPersonById(int userId) async {
  final response = await http.get(
    Uri.parse('http://181.188.191.35:3000/getpersonbyid/$userId'),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final member = Member.fromJson(data);
    return member;
  } else if (response.statusCode == 404) {
    return null; // Persona no encontrada
  } else {
    throw Exception('Error al obtener la persona por ID');
  }
}

MostrarFinalizar mostrarFinalizar = new MostrarFinalizar();

class _ListMembersScreenState extends State<ListMembersScreen> {
  String searchQuery = "";
  Future<List<Member>>? members;

  Future<List<Member>> fetchMembers() async {
    final response = await http
        .get(Uri.parse('http://181.188.191.35:3000/allaccountsclient'));
    //        await http.get(Uri.parse('http://10.10.0.14:3000/allaccountsclient'));
    print('Fetching members...'); // Agregar esto para verificar si se llama

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final members =
          data.map((memberData) => Member.fromJson(memberData)).toList();
      return members;
    } else {
      throw Exception('Failed to load members');
    }
  }

  @override
  void initState() {
    super.initState();
    members = fetchMembers();

    // Llamar a getPersonById para obtener los datos de la persona actualmente autenticada.
    getPersonById(useridROL!).then((person) {
      if (person != null) {
        // Los datos de la persona se han obtenido correctamente.
        setState(() {
          miembroActual = person;
          print(person.names);
          print(person.correo);
        });
      } else {
        // La persona no se encontró o hubo un error al obtenerla.
        mostrarFinalizar.Mostrar_Finalizados(
          context,
          "No se encontraron datos de la persona o hubo un error.",
        );
      }
    });
  }

  Future<void> refreshMembersList() async {
    setState(() {
      members = fetchMembers();
    });
  }

  List<Member> filteredMembers(List<Member> allMembers) {
    {
      return allMembers.where((member) {
        final lowerCaseName = member.names.toLowerCase();
        final lowerCaseCarnet = member.carnet?.toLowerCase();
        final lowerCaseQuery = searchQuery.toLowerCase();

        return (lowerCaseName.contains(lowerCaseQuery) ||
            lowerCaseCarnet!.contains(lowerCaseQuery));
      }).toList();
    }
  }

  Future<void> deleteUser(String userId) async {
    final url = Uri.parse('http://181.188.191.35:3000/deleteperson/$userId');
    final response = await http.put(url);

    if (response.statusCode == 200) {
      print('Usuario eliminado con éxito');
    } else {
      print('Error al eliminar el usuario: ${response.statusCode}');
    }
  }

  Future<bool> deleteImageAndFolder(int userId) async {
    try {
      final firebase_storage.Reference storageRef =
          firebase_storage.FirebaseStorage.instance.ref();
      print("ID ------------" + userId.toString());
      String carpeta = 'cliente/$userId';

      // Listamos los elementos en la carpeta
      firebase_storage.ListResult listResult =
          await storageRef.child(carpeta).listAll();

      // Eliminamos cada elemento individualmente
      for (var item in listResult.items) {
        await item.delete();
      }

      return true;
    } catch (e) {
      print('Error al eliminar imagen y carpeta: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 241, 245, 255),
        title: Text('Cuentas', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.arrow_back) ,color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        /*decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Splash.png'),
            fit: BoxFit.cover,
          ),
        ),*/
        child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Buscar por nombre o carnet',
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF5C8ECB)),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Member>>(
              future: members,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: SpinKitCircle(
                      color: Color(0xFF5C8ECB),
                      size: 50.0,
                    ));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final allMembers = snapshot.data ?? [];
                  final filtered = filteredMembers(allMembers);

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final member = filtered[index];
                      return Container(
                        margin: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            width: 2,
                            color: Color(0xFF5C8ECB),
                          ),
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    member.names,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${member.fechaCreacion?.day}/${member.fechaCreacion?.month}/${member.fechaCreacion?.year}",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Carnet: ${member.carnet}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Telefono: ${member.telefono}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Fecha Nacimiento: ${member.fechaNacimiento?.day}/${member.fechaNacimiento?.month}/${member.fechaNacimiento?.year}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 16),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
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
                                                    // Aquí se ejecuta la función deleteUser si el usuario confirma
                                                    await showLoadingDialog(context, () async{
                                                      deleteUser(
                                                        member.id.toString());
                                                      deleteImageAndFolder(
                                                          member.id);
                                                    });
                                                    showSnackbar(context, member.names+" Eliminado con éxito");
                                                    Navigator.of(context)
                                                        .pop(); // Cierra el cuadro de diálogo

                                                    /*mostrarFinalizar
                                                        .Mostrar_Finalizados(
                                                            context,
                                                            "Registro Eliminado con éxito");*/
                                                    refreshMembersList();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Text("Eliminar"),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        primary: Colors.red
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProfilePage(
                                              member: member,
                                              carnetizadorMember: miembroActual,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text("Ver Perfil"),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ListMascotas(userId: member.id),
                                          ),
                                        );
                                      },
                                      child: Text("Ver Mascotas"),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      ) ,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RegisterUpdate(
                    isUpdate: false, carnetizadorMember: miembroActual)),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF5C8ECB),
      ),
    );
  }
}
