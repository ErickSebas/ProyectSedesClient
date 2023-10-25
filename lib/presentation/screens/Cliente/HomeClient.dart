import 'dart:async';
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttapp/Implementation/ChatImp.dart';
import 'package:fluttapp/Implementation/Conversation.dart';
import 'package:fluttapp/Implementation/TokensImpl.dart';
import 'package:fluttapp/Models/Conversation.dart';
import 'package:fluttapp/Models/Profile.dart';
import 'package:fluttapp/presentation/littlescreens/Popout.dart';
import 'package:fluttapp/presentation/screens/Campaign.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/SearchClientNew.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/ListMascotas.dart';
import 'package:fluttapp/presentation/screens/Cliente/ChatPage.dart';
import 'package:fluttapp/presentation/screens/Cliente/Conversation.dart';
import 'package:fluttapp/presentation/screens/Login.dart';
import 'package:fluttapp/presentation/screens/QRPage.dart';
import 'package:fluttapp/presentation/screens/RegisterUpdate.dart';
import 'package:fluttapp/presentation/services/alert.dart';
import 'package:fluttapp/presentation/services/services_firebase.dart';
import 'package:fluttapp/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// Variable para almacenar los datos de la persona autenticada
MostrarFinalizar mostrarFinalizar = MostrarFinalizar();
// ignore: must_be_immutable

class ViewClient extends StatelessWidget {
  final int userId;

  ViewClient({required this.userId}) {
    print('ID de usuario en ViewClient: $userId');
  }
  @override
  Widget build(BuildContext context) {

          return CampaignPage();
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
    return null;
  } else {
    throw Exception('Error al obtener la persona por ID');
  }
}

Future<void> Mostrar_Informacion(BuildContext context) async {
  await InfoDialog.MostrarInformacion(context);
}

Future<String?> getImageUrl(int idCliente) async {
  try {
    Reference storageRef = FirebaseStorage.instance.ref('cliente/$idCliente');
    ListResult result = await storageRef.list();

    for (var item in result.items) {
      if (item.name == 'imagenUsuario.jpg') {
        String downloadURL = await item.getDownloadURL();
        return downloadURL;
      }
    }
  } catch (e) {
    print('Error al obtener URL de la imagen: $e');
  }

  return null;
}

// ignore: must_be_immutable
class CampaignPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     Widget mensajeCondicional() {
      if (miembroActual?.latitud == 0.1) {
        return Container(
          color: Colors.red, // Puedes personalizar el color
          padding: EdgeInsets.all(10.0), // Personaliza el espaciado
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Debes actualizar tus datos'),
              TextButton(
                onPressed: () {
                  // Navega a la otra página aquí
                       Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterUpdate(
                                          isUpdate: true,
                                          userData: miembroActual,
                                          carnetizadorMember: miembroActual,
                                        )),
                              );
                },
                child: Text('Actualizar'),
              ),
            ],
          ),
        );
      } else {
        return SizedBox.shrink(); // Si no se cumple la condición, muestra un widget invisible
      }
    }

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
                      FutureBuilder<String?>(
                        future: getImageUrl(miembroActual?.id ?? 0),
                        builder: (BuildContext context,
                            AsyncSnapshot<String?> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SpinKitCircle(
                      color: Colors.blue,
                      size: 50.0,
                    );
                          } else if (snapshot.hasError) {
                            return Text(
                                'Error al cargar la imagen: ${snapshot.error}');
                          } else {
                            final imageUrl = snapshot.data;
                            print('URL de la imagen: $imageUrl');
                            print(
                                'ID enviado a getImageUrl: ${miembroActual?.id}');
                            return imageUrl != null
                                ? Image.network(
                                    imageUrl,
                                    width: 50,
                                    height: 50,
                                  )
                                : Image.asset(
                                    'assets/univalle.png',
                                    width: 50,
                                    height: 50,
                                  );
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      Text(
                        miembroActual?.names ?? '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        miembroActual?.role ?? '',
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
                title: Text('Nombres: ${miembroActual?.names ?? ''}'),
                leading: Icon(Icons.person),
              ),
              ListTile(
                title: Text('Apellidos: ${miembroActual?.lastnames ?? ''}'),
                leading: Icon(Icons.person),
              ),
              ListTile(
                title: Text(
                    'Fecha de Nacimiento: ${miembroActual!.fechaNacimiento?.year}-${miembroActual!.fechaNacimiento?.month}-${miembroActual!.fechaNacimiento?.day}'),
                leading: Icon(Icons.calendar_today),
              ),
              ListTile(
                title: Text('Rol: ${miembroActual?.role ?? ''}'),
                leading: Icon(Icons.work),
              ),
              ListTile(
                title: Text('Correo: ${miembroActual?.correo ?? ''}'),
                leading: Icon(Icons.email),
              ),
              ListTile(
                title: Text('Teléfono: ${miembroActual?.telefono ?? ''}'),
                leading: Icon(Icons.phone),
              ),
              ListTile(
                title: Text('Carnet: ${miembroActual?.carnet ?? ''}'),
                leading: Icon(Icons.credit_card),
              ),
              ListTile(
                leading: Icon(Icons.message),
                title: Text('Mensaje'),
                onTap: () async {
                  if (miembroActual!.role == 'Cliente') {
                    print(miembroActual!.role);
                    Chat chatCliente = Chat(
                        idChats: 0,
                        idPerson: null,
                        idPersonDestino: miembroActual!.id,
                        fechaActualizacion: DateTime.now());
                    int lastId = 0;
                    List<Chat> filteredList = [];
                    await fetchChatsClient().then((value) => {
                          filteredList = value
                              .where((element) =>
                                  element.idPersonDestino == miembroActual!.id)
                              .toList(),
                          if (filteredList.isEmpty)
                            {
                              registerNewChat(chatCliente).then((value) => {
                                    getLastIdChat().then((value) => {
                                          lastId = value,
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ChatPage(
                                                      idChat: lastId,
                                                      nombreChat: 'Soporte',
                                                      idPersonDestino: 0,
                                                    )),
                                          )
                                        })
                                  })
                            }
                          else
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                          idChat: filteredList[0].idChats,
                                          nombreChat: 'Soporte',
                                          idPersonDestino: 0,
                                        )),
                              )
                            }
                        });
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreenState()),
                    );
                  }
                },
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Cerrar Sesión'),
                  onTap: () async {
                    miembroActual = miembroActual!;
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setInt('miembroLocal', 0);
                    chats.clear();
                    namesChats.clear();
                    tokenClean();
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
body: Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    // Muestra el mensaje en la parte superior si se cumple la condición
    mensajeCondicional(),
    Expanded(
      child: Container(
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
                children: <Widget>[
                  miembroActual!.role == "Carnetizador" ||
                      miembroActual!.role == "Super Admin" ||
                      miembroActual!.role == "Admin"
                      ? Column(
                          children: <Widget>[
                            Card(
                              color: Colors.transparent,
                              child: Container(
                                width: 120,
                                height: 120,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    size: 60,
                                    color: const Color(0xFF5C8ECB),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ListMembersScreen(
                                              userId: miembroActual!.id,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Text(
                              'Buscar Cliente',
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color(0xFF5C8ECB),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  miembroActual!.role == "Carnetizador" ||
                      miembroActual!.role == "Super Admin" ||
                      miembroActual!.role == "Admin"
                      ? SizedBox(width: 20)
                      : Container(),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListMascotas(
                                          userId: miembroActual!.id,
                                        )),
                              );
                            },
                          ),
                        ),
                      ),
                      Text(
                        'Mis Mascotas',
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ListCampaignPage(),
                                ),
                              );
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
                              if (miembroActual!.role == "Carnetizador") {
                                esCarnetizador = true;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterUpdate(
                                          isUpdate: true,
                                          userData: miembroActual,
                                          carnetizadorMember: miembroActual,
                                        )),
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
    ),
  ],
),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QRScannerPage(),
              //Probar si hay algun error de redireccionamiento
            ),
          );
        },
        child: Icon(Icons.qr_code),
        backgroundColor: Color(0xFF5C8ECB),
      ),
    );
  }
}
