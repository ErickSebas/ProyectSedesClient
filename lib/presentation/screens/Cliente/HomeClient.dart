import 'dart:convert';

import 'package:fluttapp/Implementation/ChatImp.dart';
import 'package:fluttapp/Implementation/Conversation.dart';
import 'package:fluttapp/Models/Conversation.dart';
import 'package:fluttapp/Models/Profile.dart';
import 'package:fluttapp/presentation/littlescreens/Popout.dart';
import 'package:fluttapp/presentation/screens/Cliente/ChatPage.dart';
import 'package:fluttapp/presentation/screens/Login.dart';
import 'package:fluttapp/presentation/screens/RegisterUpdate.dart';
import 'package:fluttapp/presentation/services/services_firebase.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Member?
    loggedInPerson; // Variable para almacenar los datos de la persona autenticada

// ignore: must_be_immutable

class ViewClient extends StatelessWidget {
  final int userId;

  ViewClient({required this.userId}) {
    print('ID de usuario en ViewClient: $userId');
  }
  @override
  Widget build(BuildContext context) {
    // Antes de construir la interfaz, obtén los datos de la persona autenticada
    return FutureBuilder<Member?>(
      future: getPersonById(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('No se encontraron datos de la persona');
        } else {
          loggedInPerson = snapshot.data;
          // Ahora puedes construir la interfaz con los datos de la persona
          print('Datos obtenidossss: $loggedInPerson'); // Agrega esta línea
          print('Nombres: ${loggedInPerson?.names}');
          print('Rol: ${loggedInPerson?.role}');
          return CampaignPage();
        }
      },
    );
  }
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

Future<void> Mostrar_Informacion(BuildContext context) async {
  await InfoDialog.MostrarInformacion(context);
}

// ignore: must_be_immutable
class CampaignPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 241, 245, 255),
        centerTitle: true,
        title: Row(
          children: [
            Expanded(
              child: GestureDetector(
                child: Image.asset("assets/Univallenavbar.png"),
              ),
            ),
            GestureDetector(
              onTap: () {
                Mostrar_Informacion(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/LogoU.png",
                  height: 32,
                  width: 32,
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Splash.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF5C8ECB),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/univalle.png',
                        width: 50,
                        height: 50,
                      ),
                      SizedBox(height: 10),
                      Text(
                        loggedInPerson?.names ?? '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        loggedInPerson?.role ?? '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text('Nombres: ${loggedInPerson?.names ?? ''}'),
                leading: Icon(Icons.person),
              ),
              ListTile(
                title: Text('Apellidos: ${loggedInPerson?.lastnames ?? ''}'),
                leading: Icon(Icons.person),
              ),
              ListTile(
                title: Text(
                    'Fecha de Nacimiento: ${loggedInPerson?.fechaNacimiento ?? ''}'),
                leading: Icon(Icons.calendar_today),
              ),
              ListTile(
                title: Text('Rol: ${loggedInPerson?.role ?? ''}'),
                leading: Icon(Icons.work),
              ),
              ListTile(
                title: Text('Correo: ${loggedInPerson?.correo ?? ''}'),
                leading: Icon(Icons.email),
              ),
              ListTile(
                title: Text('Teléfono: ${loggedInPerson?.telefono ?? ''}'),
                leading: Icon(Icons.phone),
              ),
              ListTile(
                title: Text('Carnet: ${loggedInPerson?.carnet ?? ''}'),
                leading: Icon(Icons.credit_card),
              ),
              ListTile(
              leading: Icon(Icons.message),
              title: Text('Mensaje'),
              onTap: () async {
                if(miembroActual!.role=='Cliente'){
                  print(miembroActual!.role);
                  Chat chatCliente = Chat(idChats: 0, idPerson: null, idPersonDestino: miembroActual!.id, fechaActualizacion: DateTime.now());
                  int lastId =0;
                  List<Chat> filteredList=[];
                  await fetchChatsClient().then((value) => {
                    filteredList = value.where((element) => element.idPersonDestino == miembroActual!.id).toList(),
                    if(filteredList.isEmpty){
                      registerNewChat(chatCliente).then((value) => {
                        getLastIdChat().then((value) => {
                          lastId = value,
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChatPage(idChat: lastId, nombreChat: 'Soporte',idPersonDestino: 0,)),
                          ) 
                        })
                      })
                    }else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatPage(idChat: filteredList[0].idChats, nombreChat: 'Soporte', idPersonDestino: 0,)),
                      ) 
                    }
                  });
                  
                }
                
              },
            ),
              Align(
              alignment: Alignment.bottomRight,
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('Cerrar Sesión'),
                onTap: () {
                  miembroActual = loggedInPerson!;
                  Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[// Espacio entre botones
                  Column(
                    children: <Widget>[
                      Card(
                        color: Colors.transparent,
                        child: Container(
                          width: 120,
                          height: 120,
                          child: IconButton(
                            icon: Icon(
                              Icons.pets,
                              size: 60,
                              color: Color(0xFF5C8ECB),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed("/viewPetInfo");
                            },
                          ),
                        ),
                      ),
                      Text(
                        'Ver Tus Mascotas',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                  
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Card(
                        color: Colors.transparent,
                        child: Container(
                          width: 120,
                          height: 120,
                          child: IconButton(
                            icon: Icon(
                              Icons.flag,
                              size: 60,
                              color: const Color(0xFF5C8ECB),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed("/viewMap");
                            },
                          ),
                        ),
                      ),
                      Text(
                        'Ver Campañas',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF5C8ECB),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: <Widget>[
                      Card(
                        color: Colors.transparent,
                        child: Container(
                          width: 120,
                          height: 120,
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              size: 60,
                              color: Color(0xFF5C8ECB),
                            ),
                            onPressed: () {
                              //Navigator.of(context).pushNamed("/updateClient", arguments: loggedInPerson);
                              if (loggedInPerson!.role == "Carnetizador") {
                              esCarnetizador = true;
                              } 
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterUpdate(isUpdate: true, userData: loggedInPerson, carnetizadorMember: loggedInPerson,)),
                              );
                            },
                          ),
                        ),
                      ),
                      Text(
                        'Editar Perfil',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF5C8ECB),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/qrpage");
        },
        child: Icon(Icons.qr_code),
        backgroundColor: Color(0xFF5C8ECB),
      ),
    );
  }
}
