/// <summary>
/// Nombre de la aplicación: MaYpiVaC
/// Nombre del desarrollador: Equipo-Sedes-Univalle
/// Fecha de creación: 28/08/2023
/// </summary>
/// 
// <copyright file="Popout.dart" company="Sedes-Univalle">
// Esta clase está restringida para su uso, sin la previa autorización de Sedes-Univalle.
// </copyright>
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoDialog {
  static Future<void> MostrarInformacion(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('MaYpiVaC')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                Image.asset("assets/LogoUnivalle.png", height: 150, width: 150),
                SizedBox(height: 10),
                Text(
                  'Responsables de desarrollo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Docente Administrativo',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        Text('Christian Montaño Salvatierra'),
                        GestureDetector(
                          onTap: () {
                            launch('mailto:cmontanosa@univalle.edu');
                          },
                          child: Text(
                            'cmontanosa@univalle.edu',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Estudiantes:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        Text('Pedro Conde Valdez'),
                        Text('Erick Urquiza Mendoza'),
                        Text('Fabian Mendez Mejia'),
                        Text('Jose Bascope Tejada'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Icon by Vitaly Gorbachev\n',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launch(
                                'https://www.freepik.com/search?format=search&last_filter=page&last_value=2&page=2&query=perro&type=icon');
                          },
                      ),
                      TextSpan(
                        text: 'Icon by Smashicons\n',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launch(
                                'https://www.freepik.com/search?format=search&last_filter=query&last_value=cat&query=cat&type=icon');
                          },
                      ),
                      TextSpan(
                        text: 'Imagen de starline en Freepik\n',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launch(
                                'https://www.freepik.es/vector-gratis/fondo-patron-huella-lindo-jugueton-diversion-fauna_45018544.htm#query=fondo%20mascotas&position=14&from_view=search&track=ais');
                          },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text('©Univalle-MaYpiVaC 2023', style: TextStyle(fontSize: 16)),
                Text('Todos los derechos reservados', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          actions: <Widget>[
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                color: Color(0xFF86ABF9),
                child: Center(
                  child: SizedBox(
                    width: 300,
                    height: 40,
                    child: TextButton(
                      child: Text(
                        'Cerrar',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}