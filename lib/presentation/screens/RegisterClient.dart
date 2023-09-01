import 'package:fluttapp/presentation/screens/HomeClient.dart';
import 'package:fluttapp/presentation/screens/LoginClient.dart';
import 'package:flutter/material.dart';

class RegisterClient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/SplashMaypivac.png", height: 130, width: 130),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Apellido',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Fecha de nacimiento',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent),
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Repite Contraseña',
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
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        '¿Ya tienes cuenta? Inicia sesión aquí',
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
                    MaterialPageRoute(builder: (context) => HomeClient()),
                    );
                  },
                  child: Text('Registrarse'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RegisterClient(),
    debugShowCheckedModeBanner: false,
  ));
}