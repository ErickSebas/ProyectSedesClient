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
import 'package:fluttapp/presentation/screens/Carnetizador/HomeCarnetizador.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/SearchClientNew.dart';
import 'package:fluttapp/presentation/screens/Maps.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/ListMascotas.dart';
import 'package:fluttapp/presentation/screens/Login.dart';
import 'package:fluttapp/presentation/screens/Register.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/RegisterPet.dart';
import 'package:fluttapp/presentation/screens/SplashScreen.dart';
import 'package:fluttapp/presentation/screens/Cliente/HomeClient.dart';
import 'package:fluttapp/services/global_notification.dart';
import 'package:fluttapp/services/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PushNotificationService.initializeApp();
  //PushNotificationService.messagesStream.listen((message){
  //  print('MyApp: $message');
  //});

  runApp(

    MultiProvider(providers: [
      Provider<LocalNotificationService>(create: (context) => LocalNotificationService()),
      //Provider<PushNotificationService>(create: (context) => PushNotificationService(),)
    ],
    child: const MainApp(),)
    );
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
        '/viewCarnetizador': (context) => HomeCarnetizador(userId: 0),
        '/register': (context) => Register(),
        '/createPet': (context) => RegisterPet(),
        '/viewMap': (context) => VerCamapanas(),
        '/listPets': (context) => ListMascotas(),
        '/searchClientNew': (context) => ListMembersScreen(),
      },
    );
  }
}
