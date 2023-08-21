

import 'package:fluttapp/presentation/screens/HomeClient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToMainScreen(); // Navega a la pantalla principal después de un tiempo determinado
  }

  Future<void> _navigateToMainScreen() async {
    await Future.delayed(const Duration(seconds: 2)); // Espera 2 segundos
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeClient()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Establece el color de fondo de tu splash screen
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white, // Color de fondo del splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 350,
              width: 350,
              child: Column(
                children: [
                  Image.asset("assets/univalle.png",height: 100 ,width: 100),
                  SizedBox(height: 10),
                  Image.asset("assets/univalle.png",height: 100 ,width: 100),
                  SizedBox(height:10),
                  Image.asset("assets/univalle.png",height: 100 ,width: 100),
                  SizedBox(height: 10)
                ],
              )),
            //FlutterLogo(size: 150), // Puedes reemplazar esto con tu propio logo
            const SizedBox(height: 50),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7E1670)),
            )
          ],
        ),
      ),
    );
  }
}
