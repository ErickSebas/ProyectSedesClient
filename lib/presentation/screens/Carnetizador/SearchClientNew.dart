import 'dart:convert';
import 'package:fluttapp/Models/Profile.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/HomeCarnetizador.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/ProfilePage.dart';
import 'package:fluttapp/presentation/screens/RegisterUpdate.dart';
import 'package:fluttapp/presentation/services/alert.dart';
import 'package:fluttapp/presentation/services/services_firebase.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Member?
    loggedInPerson; // Variable para almacenar los datos de la persona autenticada
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
    Uri.parse('http://10.253.1.91:3000/getpersonbyid/$userId'),
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
    final response =
        await http.get(Uri.parse('http://10.253.1.91:3000/allaccountsclient'));
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
          loggedInPerson = person;
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
        //final lowerCaseRole = member.role?.toLowerCase();
        final lowerCaseQuery = searchQuery.toLowerCase();

        return (lowerCaseName.contains(lowerCaseQuery) ||
            lowerCaseCarnet!.contains(lowerCaseQuery));
      }).toList();
    }
  }
  Future<void> deleteUser(String userId) async {
    final url = Uri.parse(
        'http://10.10.0.14:3000/deleteperson/$userId'); // Reemplaza $userId con el ID del usuario que deseas eliminar
    final response = await http.put(url);

    if (response.statusCode == 200) {
      // La solicitud PUT se completó con éxito, puedes mostrar un mensaje de éxito o actualizar la lista de usuarios.
      print('Usuario eliminado con éxito');
    } else {
      // Manejar errores aquí, como mostrar un mensaje de error o registrar el error.
      print('Error al eliminar el usuario: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4D6596),
        title: Text('Cuentas', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeCarnetizador(
                    userId: miembroActual!.id,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      body: Column(
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
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Member>>(
              future: members,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
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
                          gradient: LinearGradient(
                            colors: [Color(0xFF86ABF9), Color(0xFF4D6596)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
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
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${member.fechaCreacion?.day}/${member.fechaCreacion?.month}/${member.fechaCreacion?.year}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Carnet: ${member.carnet}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Rol: ${member.role}",
                                style: TextStyle(
                                    color: Colors.white,
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
                                                  onPressed: () {
                                                    // Aquí se ejecuta la función deleteUser si el usuario confirma
                                                    deleteUser(
                                                        member.id.toString());
                                                    Navigator.of(context)
                                                        .pop(); // Cierra el cuadro de diálogo
                                                    mostrarFinalizar
                                                        .Mostrar_Finalizados(
                                                            context,
                                                            "Registro Eliminado con éxito");
                                                    refreshMembersList();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Text("Eliminar"),
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProfilePage(member: member, carnetizadorMember: loggedInPerson),
                                          ),
                                        );
                                      },
                                      child: Text("Ver Perfil"),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => RegisterUpdate(
                      isUpdate: false, carnetizadorMember: personaMember
                    )),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF5C8ECB),
      ),
    );
  }
}
