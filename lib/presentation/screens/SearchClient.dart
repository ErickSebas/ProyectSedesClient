import 'dart:async';

import 'package:fluttapp/presentation/screens/RegisterClient.dart';
import 'package:fluttapp/presentation/screens/RegisterPet.dart';
import 'package:flutter/material.dart';

void main() => runApp(ListClient());

class ListClient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 11, 29, 61),
          title: Text('Mascotas', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: CampaignPage(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterPet(),
              ),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Color.fromARGB(255, 11, 29, 61),
        ),
      ),
    );
  }
}

class Client {
  final String nombre;
  final int CI;

  Client(this.nombre, this.CI);
}

class CampaignPage extends StatefulWidget {
  @override
  _CampaignPageState createState() => _CampaignPageState();
}

class _CampaignPageState extends State<CampaignPage> {
  List<Client> mascotas = [
    Client('Doggy', 812323423),
    Client('Tommy', 1232234),
    Client('Doggy', 8123234),
    Client('Tommy', 21232342),
    Client('Doggy', 81232342),
    Client('Tommy', 212312234),
    Client('Doggy', 81232323),
    Client('Tommy', 21231234),
    // Agrega el resto de las mascotas aquí
  ];

  String filtro = '';
  Timer? _debounce;

  void mostrarPopupNoEncontrado() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Card(
                color: Color.fromARGB(255, 51, 159, 179),
                child: Container(
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.zoom_out,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
              'No se encontraron resultados que coincidan con la búsqueda.'),
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
                        'Desea crear un nuevo Cliente',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterClient()),
                        );
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/BackGround.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: <Widget>[
          Card(
            child: TextField(
              onSubmitted: (value) {
                if (_debounce != null && _debounce!.isActive) {
                  _debounce!.cancel();
                }

                _debounce = Timer(const Duration(milliseconds: 500), () {
                  setState(() {
                    filtro = value.toLowerCase();
                    if (mascotas.every(
                        (mascota) => !mascota.CI.toString().contains(filtro))) {
                      mostrarPopupNoEncontrado();
                    }
                  });
                });
              },
              decoration: InputDecoration(
                labelText: 'Buscar por CI del Cliente',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlueAccent),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: mascotas.length,
                itemBuilder: (context, index) {
                  final mascota = mascotas[index];

                  if (filtro.isNotEmpty &&
                      !mascota.CI.toString().contains(filtro)) {
                    return Container(); // Ocultar elementos que no coincidan con la búsqueda
                  } else if (filtro.isEmpty) {
                    return Container(); // Ocultar elementos cuando no haya búsqueda
                  }

                  return Card(
                    margin: EdgeInsets.all(10),
                    color: Color.fromARGB(255, 85, 144, 189),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/Perro.png'),
                        radius: 30,
                      ),
                      title: Text(
                        mascota.nombre,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        'CI del cliente: ${mascota.CI.toString()}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPet(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
