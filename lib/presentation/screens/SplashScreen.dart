/// <summary>
/// Nombre de la aplicación: MaYpiVaC
/// Nombre del desarrollador: Equipo-Sedes-Univalle
/// Fecha de creación: 18/08/2023
/// </summary>
/// 
// <copyright file="SplashScreen.dart" company="Sedes-Univalle">
// Esta clase está restringida para su uso, sin la previa autorización de Sedes-Univalle.
// </copyright>

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomeClient.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SharedPreferences prefs;
  bool esPrimeraVez = true;

  @override
  void initState() {
    super.initState();
    Iniciar_Ver_Primera_Vez();
  }

  Future<void> Iniciar_Ver_Primera_Vez() async {
    prefs = await SharedPreferences.getInstance();
    esPrimeraVez = prefs.getBool('isFirstTime') ?? true;

    if (esPrimeraVez) {
      Mostrar_Confirmacion();
    } else {
      Navegar_Pantalla_Main();
    }
  }

  Future<void> Mostrar_Confirmacion() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Bienvenido a MaYpiVaC')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              Text(
                'MaYpiVaC necesita acceder a tu ubicación para mostrarte los puntos de vacunación en la ciudad de Cochabamba.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                '¿Deseas permitir el acceso a tu ubicación cuando la aplicación esté activa?',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Sí, permitir acceso'),
              onPressed: () {
                prefs.setBool('isFirstTime', false);
                Navigator.of(context).pop();
                Navegar_Pantalla_Main();
              },
            ),
            TextButton(
              child: Text('No, denegar acceso'),
              onPressed: () {
                prefs.setBool('isFirstTime', true);
                Navigator.of(context).pop();
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> Navegar_Pantalla_Main() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeClient()),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 500,
              width: 500,
              child: Column(
                children: [
                  Image.asset("assets/Gobernacion.png",height: 150 ,width: 150),
                  SizedBox(height: 10),
                  Image.asset("assets/LogoAplicacion.png",height: 150 ,width: 150),
                  SizedBox(height:10),
                  Image.asset("assets/LogoSedes.png",height: 150 ,width: 150),
                  SizedBox(height: 10)
                ],
              ),
            ),
            SizedBox(height: 50),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF86ABF9)),
            )
          ],
        ),
      ),
    );
  }
}