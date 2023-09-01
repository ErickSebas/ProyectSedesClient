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
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomeClient.dart';
import 'LoginClient.dart';
import 'package:fluttapp/services/firebase_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  late SharedPreferences preferencias;
  bool esPrimeraVez = true;
  @override
  void initState() {
    super.initState();
    Iniciar_Ver_Primera_Vez();
  }

  
/// Al inicio de la pantalla de inicio te pediran permisos para el uso de la aplicacion
void Permisos() async{
  LocationPermission permiso;
    permiso = await Geolocator.checkPermission();
    if(permiso == LocationPermission.denied){
      permiso = await Geolocator.requestPermission();
      if(permiso == LocationPermission.denied){
        return Future.error('error');
      }
  }
}

  ///Se usa para que la primera vez que se inicie la aplicacion en el
  ///dispositivo abra una ventana de confirmacion y si no. ingresa 
  ///de manera normal
  Future<void> Iniciar_Ver_Primera_Vez() async {
    preferencias = await SharedPreferences.getInstance();
    esPrimeraVez = preferencias.getBool('isFirstTime') ?? true;
    if (esPrimeraVez) {
      Mostrar_Confirmacion();
    } else {
      
      Navegar_Pantalla_Main();
    }
  }
  ///Crea una ventana emergente en la pantalla que te indica el uso de ubicacion
  ///en tiempo real en el dispositivo
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
              Image.asset("assets/LogoAplicacion.png",height: 150 ,width: 150),
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
              onPressed: () async {
                preferencias.setBool('isFirstTime', false);
                Permisos();
                Navigator.of(context).pop();
                Navegar_Pantalla_Main();
              },
            ),
            TextButton(
              child: Text('No, denegar acceso'),
              onPressed: () {
                preferencias.setBool('isFirstTime', true);
                Navigator.of(context).pop();
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }
  /// Te lleva a la pantalla de inicio
  Future<void> Navegar_Pantalla_Main() async {
    lstlinks = await Obtener_Links();
    locations = await Obtener_Archivo();
    //await Future.delayed(const Duration(seconds: 2));
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
    body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Splash.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Image.asset("assets/Salud.png", width: MediaQuery.of(context).size.width * 0.8, height: 150, fit: BoxFit.contain),
                  Image.asset("assets/Univallenavbar.png", width: MediaQuery.of(context).size.width * 0.8, height: 150, fit: BoxFit.contain),
                  Image.asset("assets/LogoSede.png", width: MediaQuery.of(context).size.width * 0.8, height: 150, fit: BoxFit.contain),
                  Image.asset("assets/LogoUniv.png", width: MediaQuery.of(context).size.width * 0.8, height: 150, fit: BoxFit.contain),
                ],
              ),
              SizedBox(height: 50),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF86ABF9)),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}