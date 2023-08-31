import 'package:fluttapp/presentation/screens/HomeClient.dart';
import 'package:fluttapp/presentation/screens/RegisterClient.dart';
import 'package:flutter/material.dart';
import 'package:fluttapp/presentation/littlescreens/ValidationField.dart';

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

class LoginPage extends StatelessWidget {
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
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlueAccent),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
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
                    MaterialPageRoute(builder: (context) => RegisterClient()),
                  );
                    },
                    child: Text(
                      'Regístrate!',                      
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      //preparado para llevarte a la pagina de recuperacion de contrasenia
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
  onPressed: () {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HomeClient(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  },
  child: Text('Iniciar sesión'),
)
            ],
          ),
        ),
      ),
    );
  }
}
