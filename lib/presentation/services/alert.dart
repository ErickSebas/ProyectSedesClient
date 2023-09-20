import 'package:fluttapp/Models/Profile.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/HomeCarnetizador.dart';
import 'package:fluttapp/presentation/screens/Cliente/HomeClient.dart';
import 'package:fluttapp/presentation/screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Member? personaMember;

class MostrarFinalizar {
  Future<void> Mostrar_Finalizados(BuildContext context, String mensaje) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 50),
              SizedBox(height: 10),
              Text(mensaje),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Hecho',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
            ),
          ],
        );
      },
    );
  }
}

void Mostrar_Error(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: Text(errorMessage),
        actions: <Widget>[
          TextButton(
            child: Text('Aceptar', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class Mostrar_Finalizados_Update {
  Future<void> Mostrar_Finalizados_Clientes(
      BuildContext context, String mensaje, int persona) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 50),
              SizedBox(height: 10),
              Text(mensaje),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Hecho',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewClient(
                            userId: persona,
                          )),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> Mostrar_Finalizados_Carnetizadores(
      BuildContext context, String mensaje, int persona) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 50),
              SizedBox(height: 10),
              Text(mensaje),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Hecho',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeCarnetizador(
                            userId: persona,
                          )),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class MostrarFinalizarLogin {
  Future<void> Mostrar_Finalizados(BuildContext context, String mensaje) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 50),
              SizedBox(height: 10),
              Text(mensaje),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Hecho',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
