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
          backgroundColor: Color.fromARGB(255, 241, 245, 255),
          title: Text('Clientes',
              style: TextStyle(color: const Color.fromARGB(255, 70, 65, 65))),
          centerTitle: true,
        ),
        body: CampaignPage(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed("/createClient");
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0xFF5C8ECB),
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
    Client('Juan', 812323423),
    Client('Pedro', 1232234),
    Client('Lucas', 8123234),
    Client('Antonio', 21232342),
    Client('Enrrique', 81232342),
    Client('Tommy', 212312234),
    Client('Lucho', 81232323),
    Client('Pepe', 21231234),
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
                        Navigator.of(context).pushNamed("/createClient");
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
          image: AssetImage('assets/Splash.png'),
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
                    color: Colors.transparent,
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
                      onTap: () => Navigator.of(context, rootNavigator: true)
                          .pushNamed("/createPet"),
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
