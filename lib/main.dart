/// <summary>
/// Nombre de la aplicación: MaYpiVaC
/// Nombre del desarrollador: Equipo-Sedes-Univalle
/// Fecha de creación: 18/08/2023
/// </summary>
///
// <copyright file="main.dart" company="Sedes-Univalle">
// Esta clase está restringida para su uso, sin la previa autorización de Sedes-Univalle.
// </copyright>

import 'package:firebase_core/firebase_core.dart';
import 'package:fluttapp/firebase_options.dart';
import 'package:fluttapp/presentation/screens/ActualizarCliente.dart';
import 'package:fluttapp/presentation/screens/HomeClient.dart';
import 'package:fluttapp/presentation/screens/ListMascotas.dart';
import 'package:fluttapp/presentation/screens/LoginClient.dart';
import 'package:fluttapp/presentation/screens/RegisterClient.dart';
import 'package:fluttapp/presentation/screens/RegisterPet.dart';
import 'package:fluttapp/presentation/screens/SearchClient.dart';
import 'package:fluttapp/presentation/screens/SplashScreen.dart';
import 'package:fluttapp/presentation/screens/ViewClient.dart';
import 'package:fluttapp/presentation/screens/ViewMascotaInfo.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF5C8ECB)),
        primaryColor: Color(0xFF5C8ECB),
      ),
      initialRoute: '/home',
      routes: {
        //Pantalla principal
        '/home': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/viewClient': (context) => ViewClient(userId: 0),
        '/createClient': (context) => RegisterClient(),
        '/createPet': (context) => RegisterPet(),
        '/viewMap': (context) => HomeClient(),
        '/updateClient': (context) => ActualizarCliente(datosClient: null,),
        '/listPets': (context) => ListMascotas(),
        '/listClients': (context) => ListClient(),
        '/viewPetInfo': (context) => ViewMascotasInfo(),
      },
    );
  }
}
