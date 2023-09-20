import 'dart:convert';

import 'package:fluttapp/Models/Profile.dart';
import 'package:fluttapp/presentation/littlescreens/validator.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/HomeCarnetizador.dart';
import 'package:fluttapp/presentation/screens/Cliente/HomeClient.dart';
import 'package:fluttapp/presentation/screens/Cliente/HomeClientFacebook.dart';
import 'package:fluttapp/presentation/screens/Register.dart';
import 'package:fluttapp/presentation/screens/RegisterUpdate.dart';
import 'package:fluttapp/presentation/services/services_firebase.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:fluttapp/presentation/services/alert.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

MostrarFinalizarLogin mostrarFinalizar = MostrarFinalizarLogin();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ValidadorCampos validador = ValidadorCampos();
  TextEditingController correoController = TextEditingController();
  TextEditingController contrasenaController = TextEditingController();
  String? mensajeErrorCorreo;
  String? mensajeErrorContrasena;

  Future<Member?> authenticateHttp(String email, String password) async {
    final url = Uri.parse(
        'http://10.0.2.2:3000/userbyrol?correo=$email&password=$password');
    //http://181.188.191.35:3000/userbyrol?correo=pepe@gmail.com&password=827ccb0eea8a706c4c34a16891f84e7b

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final member = Member.fromJson(data);
      miembroActual = member;
      return member;
    } else if (response.statusCode == 404) {
      return null; // Usuario no encontrado
    } else {
      throw Exception('Error al autenticar el usuario');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/Univallenavbar.png",
              ),
              SizedBox(height: 20),
              TextField(
                controller: correoController,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  errorText: mensajeErrorCorreo,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlueAccent),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: contrasenaController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  errorText: mensajeErrorContrasena,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlueAccent),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      );
                    },
                    child: Text(
                      'Regístrate!',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed("/login");
                    },
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final loggedInMember = await authenticateHttp(
                    correoController.text,
                    md5
                        .convert(utf8.encode(contrasenaController.text))
                        .toString(),
                  );
                  if (loggedInMember != null) {
                    if (loggedInMember.role == "Carnetizador") {
                      // Redirigir al administrador a la pantalla de administrador
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeCarnetizador(
                            userId: loggedInMember.id,
                          ), // Pasa el ID del usuario aquí
                        ),
                      );
                    } else if (loggedInMember.role == "Cliente") {
                      // Redirigir al usuario normal a la pantalla de usuario
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewClient(
                            userId: loggedInMember.id,
                          ), // Pasa el ID del usuario aquí
                        ),
                      );
                    } else {
                      // Rol desconocido, puedes mostrar un mensaje de error o manejarlo según tus necesidades.
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Rol de usuario desconocido')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Usuario o Contraseña Incorrectos')),
                    );
                  }
                },
                child: Text('LOGIN'), // Agregar el texto "LOGIN" aquí
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'O inicia sesión con:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  _facebookLogin();
                },
                icon: Icon(Icons.facebook),
                label: Text('Facebook'),
              ),
              SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  // Aquí puedes manejar la lógica de inicio de sesión con Google
                },
                icon: Icon(Icons.message),
                label: Text('Google'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _facebookLogin() async {
// Create an instance of FacebookLogin
    final fb = FacebookLogin();
    // Log in
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile, //permiso para perfil
      FacebookPermission.email, //permiso para tener el email
    ]);
// Check result status
    switch (res.status) {
      case FacebookLoginStatus.success:
        // Logged in

        // Send access token to server for validation and auth
        final FacebookAccessToken? accessToken = res.accessToken; //get el token
        // Get profile data
        final profile = await fb.getUserProfile();

        // Get user profile image url
        final imageUrl = await fb.getProfileImageUrl(width: 100); //get imagen
        print('Access token: ${accessToken?.token}');
        print('Hello, ${profile?.name}! You ID: ${profile?.userId}');

        print('Your profile image: $imageUrl');

        // Get email (since we request email permission)
        final email = await fb.getUserEmail();
        // But user can decline permission
        if (email != null) print('And your email is $email');
// Después de obtener los datos de inicio de sesión exitosos, redirige al usuario
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeClientFacebook(
                fbAccessToken: accessToken!.token,
                profileImage: imageUrl!,
                fbName: profile!.name!,
                fbfirstname: profile!.firstName!,
                fbLastname: profile.lastName!,
                fbId: profile.userId,
                fbEmail: email!),
          ),
        );
        break;
      case FacebookLoginStatus.cancel:
        // User cancel log in
        break;
      case FacebookLoginStatus.error:
        // Log in failed
        print('Error while log in: ${res.error}');
        break;
    }
  }

  // Función para validar los campos de texto
  bool validarCampos() {
    bool correoValido = validador.validarCorreo(correoController.text);
    bool contrasenaValida =
        validador.validarContrasena(contrasenaController.text);

    setState(() {
      mensajeErrorCorreo = correoValido ? null : validador.mensajeErrorCorreo;
      mensajeErrorContrasena =
          contrasenaValida ? null : validador.mensajeErrorContrasena;
    });

    return correoValido && contrasenaValida;
  }
}
