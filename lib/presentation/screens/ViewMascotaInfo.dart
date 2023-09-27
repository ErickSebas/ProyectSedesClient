import 'dart:convert';

import 'package:fluttapp/Models/Mascota.dart';
import 'package:fluttapp/Models/Propietario.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/ListMascotas.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewMascotasInfo extends StatelessWidget {
  final Mascota mascota;

  Future<Propietario> fetchOwnerById(int id) async {
    final response = await http
        .get(Uri.parse('http://10.10.0.14:3000/getpropietariobyid2/$id'));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      return Propietario.fromJson(data);
    } else {
      throw Exception('Failed to load owner');
    }
  }

  ViewMascotasInfo(this.mascota);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Propietario>(
      future: fetchOwnerById(mascota.idPersona),
      builder: (BuildContext context, AsyncSnapshot<Propietario> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Muestra un indicador de carga mientras se espera la respuesta.
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Propietario propietario = snapshot.data!;
          return InfoMascotas(mascota: mascota, propietario: propietario);
        }
      },
    );
  }
}

class InfoMascotas extends StatelessWidget {
  final Mascota mascota;
  final Propietario propietario;

  InfoMascotas({required this.mascota, required this.propietario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 241, 245, 255),
        title: Text('Datos de la Mascota',
            style: TextStyle(color: const Color.fromARGB(255, 70, 65, 65))),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.all(10),
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.asset('assets/Perro.png'),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                mascota.nombre, // Usar el nombre de la mascota
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Raza: " +
                                    mascota.raza, // Usar la raza de la mascota
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                mascota.edad.toString() +
                                    " de edad", // Usar la edad de la mascota
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Color: " +
                                    mascota
                                        .color, // Usar el color de la mascota
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                mascota
                                    .descripcion, // Usar la descripción de la mascota
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                mascota.sexo == 'H' ? 'Hembra' : 'Macho',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Propietario',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: EdgeInsets.all(10),
                                child: Card(
                                  color: Colors.transparent,
                                  shape: RoundedRectangleBorder(),
                                  child: SizedBox(
                                    child: Column(
                                      children: [
                                        Text(
                                          propietario
                                              .nombres, // Usar el nombre del propietario
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          propietario
                                              .apellidos, // Usar los apellidos del propietario
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          propietario
                                              .correo, // Usar el correo del propietario
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          propietario.telefono
                                              .toString(), // Usar el teléfono del propietario
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
