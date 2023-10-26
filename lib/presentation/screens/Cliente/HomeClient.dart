import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
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
import 'package:path_provider/path_provider.dart';
import '../../../services/connectivity_service.dart';

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
    if(image==null){
    Reference storageRef = FirebaseStorage.instance.ref('cliente/$idCliente');
    ListResult result = await storageRef.list();

    for (var item in result.items) {
      if (item.name == 'imagenUsuario.jpg') {
        String downloadURL = await item.getDownloadURL();
        return downloadURL;
      }
    }
    }
  } catch (e) {
    print('Error al obtener URL de la imagen: $e');
  }

  return null;
}


// ignore: must_be_immutable
class CampaignPage extends StatefulWidget {

  @override
  _CampaignPageState createState() => _CampaignPageState();

}

class _CampaignPageState extends State<CampaignPage> {

  final ConnectivityService _connectivityService = ConnectivityService();
  bool isloadingProfile = true;

  @override
  void initState() {
    super.initState();
    _connectivityService.initialize(context);
    addImageToSelectedImages(miembroActual!.id);
  }

  @override
  void dispose() {
    _connectivityService.dispose();
    super.dispose();
  }

    Future<File?> addImageToSelectedImages(int idPerson) async {
  try {
    isloadingProfile=true;
    String imageUrl = await getImageUrl(idPerson);
    File tempImage = await _downloadImage(imageUrl);
    
    setState(() {
      image = tempImage;
      isloadingProfile=false;
    });
    return image;
  } catch (e) {
    print('Error al obtener y descargar la imagen: $e');
  }
  isloadingProfile=false;
  return null;
}

Future<String> getImageUrl(int idPerson) async {
  try {
    Reference storageRef = FirebaseStorage.instance.ref('cliente/$idPerson/imagenUsuario.jpg');
    return await storageRef.getDownloadURL();
  } catch (e) {
    print('Error al obtener URL de la imagen: $e');
    throw e;
  }
}

Future<File> _downloadImage(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));

  if (response.statusCode == 200) {
    final bytes = response.bodyBytes;
    final tempDir = await getTemporaryDirectory();
    final tempImageFile = File('${tempDir.path}/${DateTime.now().toIso8601String()}.jpg');
    await tempImageFile.writeAsBytes(bytes);
    return tempImageFile;
  } else {
    throw Exception('Error al descargar imagen');
  }
}
  
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
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF5C8ECB),
                      Colors.blue[800]!,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double avatarRadius = constraints.maxWidth * 0.15;
                          
                          return image != null
                            ? InkWell(
                              onTap: () {
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
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: isloadingProfile?null: FileImage(image!),
                                    radius: avatarRadius,
                                  ),
                                  if (isloadingProfile)
                                    SizedBox(
                                      width: 60, 
                                      height: 60, 
                                      child: SpinKitCircle(
                                        color: Colors.white,
                                      ),
                                    ),
                                ],
                              ),
                            )
                            : InkWell(
                              onTap: () {
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
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                   CircleAvatar(
                                    backgroundImage: isloadingProfile?null: AssetImage('assets/univalle.png'),
                                    radius: avatarRadius,
                                  ),
                                  if (isloadingProfile)
                                    SizedBox(
                                      width: 60, 
                                      height: 60, 
                                      child: SpinKitCircle(
                                        color: Colors.white,
                                      ),
                                    ),
                                ],
                              ),
                            );
                        },
                      ),

                      SizedBox(height: 10),
                      Text(
                        miembroActual?.names ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        miembroActual?.role ?? '',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
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
                onTap:  () async {
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
                  onTap:() async {

                    miembroActual = miembroActual!;
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setInt('miembroLocal', 0);
                    chats.clear();
                    namesChats.clear();
                    image = null;
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
                                fontWeight: FontWeight.bold,
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
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5C8ECB),
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
                          fontWeight: FontWeight.bold,
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
                          fontWeight: FontWeight.bold,
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
