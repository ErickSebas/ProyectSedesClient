import 'dart:convert';
import 'package:fluttapp/Models/Profile.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/HomeCarnetizador.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/ProfilePage.dart';
import 'package:fluttapp/presentation/screens/RegisterUpdate.dart';
import 'package:fluttapp/presentation/services/services_firebase.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListMembersScreen extends StatefulWidget {
  @override
  _ListMembersScreenState createState() => _ListMembersScreenState();
}

class _ListMembersScreenState extends State<ListMembersScreen> {
  String searchQuery = "";

  Future<List<Member>>? members;

  Future<List<Member>> fetchMembers() async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/allaccountsclient'));
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
  }

  List<Member> filteredMembers(List<Member> allMembers) {
    {
      return allMembers.where((member) {
        final lowerCaseName = member.names.toLowerCase();
        final lowerCaseCarnet = member.carnet?.toLowerCase();
        final lowerCaseRole = member.role?.toLowerCase();
        final lowerCaseQuery = searchQuery.toLowerCase();

        return (lowerCaseName.contains(lowerCaseQuery) ||
                lowerCaseCarnet!.contains(lowerCaseQuery)); 
      }).toList();
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
                    ), // Pasa el ID del usuario aquí
                  ),
                );
            },
          ),
          
        ),
        
      ),
      
      body: Stack(
          children: [
            Image.asset(
            'assets/Splash.png', // Reemplaza 'background.jpg' con la ruta correcta de tu imagen de fondo
            fit: BoxFit.cover, // Ajusta la imagen al tamaño de la pantalla
            width: double.infinity,
            height: double.infinity,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (query) {
                  setState(() {
                    searchQuery = query;
                  });
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Buscar por nombre o carnet',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
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
                                  child:
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                // Lógica para eliminar el miembro
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
                                                        ProfilePage(
                                                            member: member),
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
                        isUpdate: false,
                      )),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0xFF5C8ECB),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: ListMembersScreen()));
}
  