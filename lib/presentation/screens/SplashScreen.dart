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
    // ignore: use_build_context_synchronously
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
              )),
            const SizedBox(height: 50),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF86ABF9)),
            )
          ],
        ),
      ),
    );
  }
}
