
import 'package:fluttapp/presentation/screens/SplashScreen.dart';
import 'package:flutter/material.dart';

 

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MainApp());

}

class MainApp extends StatelessWidget {

  const MainApp({Key? key}) : super(key: key);

 

  @override

  Widget build(BuildContext context) {

    return  MaterialApp(

        debugShowCheckedModeBanner: false,

        theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7E1670)),

          primaryColor: const Color(0xFF7E1670),

        ),

        initialRoute: '/home',

        routes: {

          //Pantalla principal

          '/home': (context) => const SplashScreen(),

        },

      );

  }

}

 