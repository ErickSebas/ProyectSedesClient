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

class _CampaignPageState extends State<CampaignPage> {
  List<String> mascotas = [
    'Doggy\nFrench Mastiff\n8 meses',
    'Tommy\nLabrador\n2 años',
    'Loky\nSiamese Cat\n1 año',
    'Pepe\nSiamese Cat\n1 año',
    'Ruso\nSiamese Cat\n1 año',
    'Rudo\nSiamese Cat\n1 año',
    'Puro\nSiamese Cat\n1 año',
    'Lano\nSiamese Cat\n1 año',
    'Doggy\nFrench Mastiff\n8 meses',
    'Tommy\nLabrador\n2 años',
    'Whiskers\nSiamese Cat\n1 año',
    'Buddy\nGolden Retriever\n4 meses',
    'Fluffy\nPersian Cat\n6 meses',
    'Rocky\nGerman Shepherd\n3 años',
    'Coco\nChihuahua\n1 año',
    'Lola\nBoxer\n2 años',
    'Milo\nPoodle\n5 meses',
    'Lucy\nBeagle\n7 meses',
  ];

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
                  final mascotaLowerCase = mascota.toLowerCase();

                  if (filtro.isNotEmpty && !mascotaLowerCase.contains(filtro)) {
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
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPet(),
                              ),
                            );
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
                          mascota,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InfoMascotas(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            height: 120.0, // Establece la altura fija del botón
            child: Center(
              child: FractionallySizedBox(
                widthFactor:
                    0.8, // Ajusta el ancho del botón al 80% del ancho de la pantalla
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewClient(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary:
                          Color(0xFF5C8ECB), // Cambiar el color del botón aquí
                    ),
                    child: Text('Atras'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
