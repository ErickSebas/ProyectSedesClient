import 'dart:convert';

import 'package:card_swiper/card_swiper.dart';
import 'package:fluttapp/Models/Mascota.dart';
import 'package:fluttapp/Models/Propietario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewMascotasInfo extends StatelessWidget {
  final Mascota mascota;

  Future<Propietario> fetchOwnerById(int id) async {
    final response = await http
        .get(Uri.parse('http://10.10.0.146:3000/getpropietariobyid2/$id'));

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
          return CircularProgressIndicator();
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

// ignore: must_be_immutable
class InfoMascotas extends StatelessWidget {
  final Mascota mascota;
  final Propietario propietario;

  InfoMascotas({required this.mascota, required this.propietario});

  List<String> imagenes = [
    'assets/Perro.png',
    'assets/Perro.png',
    'assets/Perro.png',
    'assets/Perro.png',
    'assets/Perro.png',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 241, 245, 255),
          title: Text(
            'Datos de la Mascota',
            style: TextStyle(color: const Color.fromARGB(255, 70, 65, 65)),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Splash.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              /* con sin sombras
              Expanded(
                flex: 2,
                child: Swiper(
                  itemCount: imagenes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          image: DecorationImage(
                            image: AssetImage(imagenes[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              */
              Expanded(
                //con sombras
                flex: 2,
                child: Swiper(
                  itemCount: imagenes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            // Añade un sombreado
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.5), // Color del sombreado
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(
                                  0, 3), // Cambia la dirección del sombreado
                            ),
                          ],
                          image: DecorationImage(
                            image: AssetImage(imagenes[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Card(
                  margin: EdgeInsets.all(10),
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
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
                        mascota.raza, // Usar la raza de la mascota
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        mascota.edad.toString(), // Usar la edad de la mascota
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        mascota.color, // Usar el color de la mascota
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
                        mascota.sexo, // Usar el sexo de la mascota
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Card(
                  margin: EdgeInsets.all(10),
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Propietario',
                        style: TextStyle(color: Colors.black, fontSize: 20),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
