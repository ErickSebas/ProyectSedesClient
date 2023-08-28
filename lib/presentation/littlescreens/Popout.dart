/// <summary>
/// Nombre de la aplicación: MaYpiVaC
/// Nombre del desarrollador: Equipo-Sedes-Univalle
/// Fecha de creación: 28/08/2023
/// </summary>
/// 
// <copyright file="Popout.dart" company="Sedes-Univalle">
// Esta clase está restringida para su uso, sin la previa autorización de Sedes-Univalle.
// </copyright>

import 'package:flutter/material.dart';

class InfoDialog {
  static Future<void> MostrarInformacion(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('MaYpiVaC')),
          content: Column(
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
                        Text(' Christian Montaño Salvatierra'),
                        Text('cmontanosa@univalle.edu'),
                      ],
                    )),
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
                        Text('Erick Urquiza Mendoza'),
                        Text('Fabian Mendez Mejia'),
                        Text('Pedro Conde Valdez'),
                        Text('Jose Bascope Tejada'),
                      ],
                    )),
              ),
              SizedBox(height: 10),
              Text('©Univalle-MaYpiVaC 2023', style: TextStyle(fontSize: 16)),
              Text('Todos los derechos reservados',
                  style: TextStyle(fontSize: 16)),
            ],
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
                    width: 80,
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