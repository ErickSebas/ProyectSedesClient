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
import 'package:url_launcher/url_launcher.dart';
import 'LoginClient.dart';
import 'package:fluttapp/services/firebase_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

/// Llamamos al metodo al inicio del programa para poder usar los URLs de la aplicacion
Activar_Links(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'No se encuentra un URL valido $url';
  }
}

class _SplashScreenState extends State<SplashScreen> {
  int versionactual = 1;
  late SharedPreferences preferencias;
  bool esPrimeraVez = true;
  @override
  void initState() {
    super.initState();
    Iniciar_Ver_Primera_Vez();
  }

  /// Al inicio de la pantalla de inicio te pediran permisos para el uso de la aplicacion
  void Permisos() async {
    LocationPermission permiso;
    permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
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
              Image.asset("assets/Univallenavbar.png", height: 150, width: 150),
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

  Future<void> Verificar_Version() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Center(child: Text('¡ACTUALIZAR!')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                Image.asset("assets/Univallenavbar.png",
                    height: 150, width: 150),
                Text(
                  'Parece que estas usando una version antigua de la aplicacion , Necesitas actualizarla',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  child: Text('Aceptar'),
                  onPressed: () {
                    Activar_Links("https://sedescochabamba.gob.bo");
                  },
                ),
              ],
            ));
      },
    );
  }

  /// Te lleva a la pantalla de inicio
  Future<void> Navegar_Pantalla_Main() async {
    lstlinks = await Obtener_Links();
    locations = await Obtener_Archivo();
    lstVersions = await Obtener_Version();
    print("lstVersions: $lstVersions");
    if (int.tryParse(lstVersions[0]["version"]) != versionactual) {
      print("La versión NO es igual a 1 inicializando verificarversion");
      Verificar_Version();
    } else {
      print("La versión es igual a 1, navegando a la pantalla de inicio.");
      // Continuar con la navegación normal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
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
        body: WillPopScope(
      onWillPop: () async {
        return false; // Devuelve 'true' si quieres prevenir el cierre de la aplicación
      },
      child: Stack(
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
                    Image.asset("assets/Salud.png",
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 150,
                        fit: BoxFit.contain),
                    Image.asset("assets/Univallenavbar.png",
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 150,
                        fit: BoxFit.contain),
                    Image.asset("assets/LogoSede.png",
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 150,
                        fit: BoxFit.contain),
                    Image.asset("assets/LogoUniv.png",
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 150,
                        fit: BoxFit.contain),
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
    ));
  }
}
