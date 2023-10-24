import 'package:fluttapp/Models/Profile.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/SearchClientNew.dart';
import 'package:fluttapp/presentation/screens/RegisterUpdate.dart';
import 'package:fluttapp/presentation/services/services_firebase.dart';
import 'package:fluttapp/presentation/screens/ChangePassword.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:convert';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ProfilePage extends StatelessWidget {
  Member? member; //Variable que agarra el dato del perfil y hace el recorrido de cambiar de contrasena
  Member?
      carnetizadorMember; //Variable que toma el dato que entra desde search cliente , este dato , va al Update, y tambien se usa para volver al search

  Future<Member?> recoverPassword(String email) async {
    final url = Uri.parse('http://181.188.191.35:3000/checkemail/$email');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      member = Member.fromJson(data);

      return member;
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
      ..recipients.add(member!.correo)
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
    var userId = member?.id;
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

  ProfilePage({this.member, required this.carnetizadorMember});

  @override
  Widget build(BuildContext context) {
    print(carnetizadorMember?.correo);
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil de ${member!.names}"),
        backgroundColor: Color(0xFF4D6596),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ListMembersScreen(
                    userId: miembroActual!.id, //Te manda a la lista con el ID del usuario que se asigno
                  ), 
                ),
              );
            },
          ),
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/Splash.png',
            fit: BoxFit.cover, 
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: Color(
                0xFF4D6596),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FractionallySizedBox(
                    widthFactor: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoItem("Correo: ${member!.correo}"),
                        _buildInfoItem("Carnet: ${member!.carnet}"),
                        _buildInfoItem("Teléfono: ${member!.telefono}"),
                        _buildInfoItem(
                            "Fecha de Nacimiento: ${member!.fechaNacimiento?.year}-${member!.fechaNacimiento?.month}-${member!.fechaNacimiento?.day}"),
                        _buildMap(member!.latitud, member!.longitud),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (member!.role == "Carnetizador") {
                                  esCarnetizador = true;
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterUpdate(
                                        isUpdate: true,
                                        userData: member,
                                        carnetizadorMember: carnetizadorMember),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 255, 255, 255),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: Text(
                                "Editar Perfil",
                                style: TextStyle(
                                  color: Color(0xFF4D6596),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            _buildSendEmailButton(context)
                          ],
                        )
                      ],
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
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      onPressed: () async {
        // Envía el correo y actualiza la base de datos
        final success = await sendEmailAndUpdateCode(member!.id);

        if (success) {
          await Mostrar_Mensaje(
              context, "Se ha enviado un código a tu correo electrónico.");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChangePasswordPage(
                member: member,
              ),
            ),
          );
          isLogin = 0;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Ocurrió un error al enviar el código de recuperación.'),
            ),
          );
        }
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
          style: TextStyle(color: Colors.white, fontSize: 20),
          children: [
            TextSpan(
              text: "${parts[0]}: ", // Parte del título en negrita
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: parts[1], // Parte del contenido
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
