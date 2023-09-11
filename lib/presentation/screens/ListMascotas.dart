import 'package:fluttapp/presentation/screens/RegisterPet.dart';
import 'package:fluttapp/presentation/screens/ViewClient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttapp/presentation/screens/ViewMascotaInfo.dart';

void main() => runApp(ListMascotas());

class ListMascotas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 241, 245, 255),
          title: Text('Mascotas',
              style: TextStyle(color: const Color.fromARGB(255, 70, 65, 65))),
          centerTitle: true,
        ),
        body: CampaignPage(),
      ),
    );
  }
}

class CampaignPage extends StatefulWidget {
  @override
  _CampaignPageState createState() => _CampaignPageState();
}

class Mascota {
  final String nombre;
  final String raza;
  final int CIPropietario; // Cambiado a tipo int

  Mascota({
    required this.nombre,
    required this.raza,
    required this.CIPropietario,
  });
}

List<Mascota> mascotas = [
  Mascota(
    nombre: 'Doggy',
    raza: 'French Mastiff',
    CIPropietario: 8, // Cambiado a tipo int
  ),
  Mascota(
    nombre: 'Tommy',
    raza: 'Labrador',
    CIPropietario: 2, // Cambiado a tipo int
  ),
  // Otras mascotas...
];

class _CampaignPageState extends State<CampaignPage> {
  String filtro = '';

  void eliminarMascota(int index) {
    setState(() {
      mascotas.removeAt(index);
    });
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
              onChanged: (value) {
                setState(() {
                  filtro = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                labelText: 'Buscar',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlueAccent),
                ),
              ),
            ),
          ),
          Expanded(
            child: SlidableAutoCloseBehavior(
              child: ListView.builder(
                itemCount: mascotas.length,
                itemBuilder: (context, index) {
                  final mascota = mascotas[index];
                  if (filtro.isNotEmpty &&
                      !(mascota.nombre.toLowerCase().contains(filtro) ||
                          mascota.raza.toLowerCase().contains(filtro) ||
                          mascota.CIPropietario.toString().contains(filtro))) {
                    return Container();
                  }

                  return Slidable(
                    endActionPane: ActionPane(
                      motion: StretchMotion(),
                      children: [
                        SlidableAction(
                          onPressed: ((context) {
                            eliminarMascota(
                                index); // Elimina el elemento de la lista
                          }),
                          borderRadius: BorderRadius.circular(20),
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                        ),
                        SlidableAction(
                          onPressed: ((context) {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed("/createPet");
                          }),
                          borderRadius: BorderRadius.circular(20),
                          backgroundColor: Color(0xFF5C8ECB),
                          icon: Icons.edit,
                        ),
                      ],
                    ),
                    child: Card(
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
                        onTap: () => Navigator.of(context, rootNavigator: true)
                            .pushNamed("/createPet"),
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
