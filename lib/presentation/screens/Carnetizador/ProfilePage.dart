import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttapp/Models/Profile.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/SearchClientNew.dart';
import 'package:fluttapp/presentation/screens/RegisterUpdate.dart';
import 'package:fluttapp/presentation/services/services_firebase.dart';
import 'package:fluttapp/presentation/screens/ChangePassword.dart';
import 'package:fluttapp/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:convert';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


class ProfilePage extends StatefulWidget {
  Member? member;
  Member? carnetizadorMember;
  

  ProfilePage({required this.member, required this.carnetizadorMember});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isloadingProfile = true;
  File? imageProfile;

  Future<Member?> recoverPassword(String email) async {
    final url = Uri.parse('http://181.188.191.35:3000/checkemail/$email');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      widget.member = Member.fromJson(data);

      return widget.member;
    } else if (response.statusCode == 404) {
      return null; // Correo no encontrado en la base de datos
    } else {
      throw Exception('Error al recuperar la contraseña');
    }
  }

  Future<bool> sendEmailAndUpdateCode(int userId) async {
    final code = generateRandomCode();
    final exists = await checkCodeExists(userId);
    final smtpServer = gmail('bdcbba96@gmail.com', 'ehbh ugsw srnj jxsf');
    final message = Message()
      ..from = Address('bdcbba96@gmail.com', 'Admin')
      ..recipients.add(widget.member!.correo)
      ..subject = 'Cambiar Contraseña MaYpiVaC'
      ..text = 'Código de recuperación de contraseña: $code';
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      // Actualiza la base de datos
      final url = exists
          ? Uri.parse(
              'http://181.188.191.35:3000/updateCode/$userId/$code') // URL para actualizar el código
          : Uri.parse(
              'http://181.188.191.35:3000/insertCode/$userId/$code'); // URL para insertar un nuevo registro
      final response = await (exists ? http.put(url) : http.post(url));
      if (response.statusCode == 200) {
        print('Código actualizado/insertado en la base de datos.');
        return true; // Devuelve true si todo fue exitoso
      } else {
        print('Error al actualizar/insertar el código en la base de datos.');
        return false; // Devuelve false en caso de error
      }
    } catch (e) {
      print('Message not sent.');
      print(e.toString());
      return false; // Devuelve false en caso de error
    }
  }

  String generateRandomCode() {
    final random = Random();
    final firstDigit =
        random.nextInt(9) + 1; // Genera un número aleatorio entre 1 y 9
    final restOfDigits = List.generate(4, (index) => random.nextInt(10)).join();
    final code = '$firstDigit$restOfDigits';
    return code;
  }

  Future<bool> checkCodeExists(int userId) async {
    var userId = widget.member?.id;
    final response = await http.get(
      Uri.parse(
          'http://181.188.191.35:3000/checkCodeExists/$userId'), // Reemplaza con la URL correcta de tu API
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data[
          'exists']; // Suponiendo que la API devuelve un booleano llamado "exists"
    } else {
      throw Exception('Error al verificar el código.');
    }
  }

  

    Future<File?> addImageToSelectedImages(int idPerson) async {
  try {
    isloadingProfile=true;
    String imageUrl = await getImageUrl(idPerson);
    File tempImage = await _downloadImage(imageUrl);
    
    setState(() {
      imageProfile = tempImage;
      isloadingProfile=false;
    });
    return imageProfile;
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
  void initState() {
    super.initState();
    addImageToSelectedImages(widget.member!.id);
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    print(widget.carnetizadorMember?.correo);
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil de ${widget.member!.names}" ,style: TextStyle(color: Color(0xFF5C8ECB))),
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF5C8ECB)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Stack(
        children: [
          /*Image.asset(
            'assets/Splash.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),*/
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          Colors.white,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(width: 3, color: Color(0xFF5C8ECB)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: imageProfile != null
                              ? CircleAvatar(
                                  backgroundImage: FileImage(imageProfile!),
                                  radius: 100,
                                )
                              : CircleAvatar(
                                  backgroundImage: AssetImage('assets/usuario.png'),
                                  radius: 100,
                                ),
                        ),
                        _buildInfoItem("Correo: ${widget.member!.correo}"),
                        _buildInfoItem("Carnet: ${widget.member!.carnet}"),
                        _buildInfoItem("Teléfono: ${widget.member!.telefono}"),
                        _buildInfoItem(
                            "Fecha de Nacimiento: ${widget.member!.fechaNacimiento?.year}-${widget.member!.fechaNacimiento?.month}-${widget.member!.fechaNacimiento?.day}"),
                        SizedBox(height: 10),
                        _buildMap(widget.member!.latitud, widget.member!.longitud),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (widget.member!.role == "Carnetizador") {
                            esCarnetizador = true;
                          }
                          final res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterUpdate(
                                isUpdate: true,
                                userData: widget.member,
                                carnetizadorMember: widget.carnetizadorMember,
                              ),
                            ),
                          );
                          if(res!=null){
                            setState(() {
                              addImageToSelectedImages(widget.member!.id);
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white, // Fondo blanco
                          padding: EdgeInsets.symmetric(
                              horizontal: 45, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(
                                color: Color.fromARGB(255, 92, 142, 203),
                                width: 3.0), // Bordes del color deseado
                          ),
                        ),
                        child: Text(
                          "Editar Perfil",
                          style: TextStyle(
                            color: Color(0xFF4D6596),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendEmailButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF4D6596),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      onPressed: () async {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return FutureBuilder(
              future: sendEmailAndUpdateCode(widget.member!.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return AlertDialog(
                    title: Text('Espere unos momentos....'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          Center(
                            child: SpinKitFadingCube(
                              color: Colors.blue,
                              size: 50.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text(
                        'Ocurrió un error al enviar el código de recuperación.'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cerrar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                } else {
                  // El proceso se completó con éxito
                  return AlertDialog(
                    title: Text('Éxito'),
                    content: Text(
                        'Se ha enviado un código a tu correo electrónico.'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cerrar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangePasswordPage(
                                member: widget.member,
                              ),
                            ),
                          );
                          isLogin = 0;
                        },
                      ),
                    ],
                  );
                }
              },
            );
          },
        );
      },
      child: Text("Cambiar Contraseña"),
    );
  }

  Widget _buildInfoItem(String text) {
    final List<String> parts =
        text.split(":"); // Dividimos el texto en dos partes

    return Container(
      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Color(0xFF5C8ECB), fontSize: 20),
          children: [
            TextSpan(
              text: "${parts[0]}: ", // Parte del título en negrita
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: parts[1], style: TextStyle(color: Colors.black) // Parte del contenido
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildMap(double lat, double lng) {
  return Container(
    height: 150, 
    width: double.infinity, 
    child: GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(lat, lng),
        zoom: 15,
      ),
      markers: {
        Marker(
          markerId: MarkerId('memberLocation'),
          position: LatLng(lat, lng),
        ),
      },
    ),
  );
}
/*
SpinKitCircle(
                      color: Color(0xFF5C8ECB),
                      size: 50.0,
                    )*/
