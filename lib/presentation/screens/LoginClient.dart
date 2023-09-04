import 'package:fluttapp/presentation/littlescreens/validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttapp/presentation/screens/RegisterClient.dart';
import 'package:fluttapp/presentation/screens/ViewClient.dart';
import 'package:fluttapp/presentation/services/alert.dart';

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

MostrarFinalizar mostrarFinalizar = MostrarFinalizar();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/SplashMaypivac.png", height: 130, width: 130),
              TextField(
                controller: correoController,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  errorText: mensajeErrorCorreo, // Muestra el mensaje de error en rojo
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
                  errorText: mensajeErrorContrasena, // Muestra el mensaje de error en rojo
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterClient(),
                        ),
                      );
                    },
                    child: Text(
                      'Regístrate!',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewClient(),
                        ),
                      );
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
                /*onPressed: () async {
                  bool camposValidos = validarCampos();
                  if (camposValidos) {
                    await mostrarFinalizar.Mostrar_Finalizados(
                      context,
                      "Inicio de Sesión Exitoso!",
                    );
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ViewClient()),
                  );
                  }
                },*/
                  onPressed: () async {
                  await mostrarFinalizar.Mostrar_Finalizados(
                      context, "Loggeo Con Éxito!");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ViewClient()),
                  );
                },
                child: Text('Iniciar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Función para validar los campos
  bool validarCampos() {
    bool correoValido = validador.validarCorreo(correoController.text);
    bool contrasenaValida = validador.validarContrasena(contrasenaController.text);

    setState(() {
      mensajeErrorCorreo = correoValido ? null : validador.mensajeErrorCorreo;
      mensajeErrorContrasena = contrasenaValida ? null : validador.mensajeErrorContrasena;
    });

    return correoValido && contrasenaValida;
  }
}
