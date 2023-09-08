import 'package:fluttapp/presentation/screens/ActualizarCliente.dart';
import 'package:fluttapp/presentation/screens/HomeClient.dart';
import 'package:fluttapp/presentation/screens/ListMascotas.dart';
import 'package:fluttapp/presentation/screens/RegisterPet.dart';
import 'package:flutter/material.dart';

void main() => runApp(ViewClient());

class ViewClient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CampaignPage();
  }
}

class CampaignPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 11, 29, 61),
        title: Text('MAYPIVAC', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/BackGround.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Card(
                        color: Colors.transparent,
                        child: Container(
                          width:
                              120,
                          height:
                              120,

                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              size: 60,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPet()),
                              );
                            },
                          ),
                        ),
                      ),
                      Text(
                        'Crear Mascota',
                        style: TextStyle(
                          fontSize:
                              16,
                          color: Colors
                              .white, 
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 20), // Espacio entre botones
                  Column(
                    children: <Widget>[
                      Card(
                        color: Colors.transparent,
                        child: Container(
                          width:
                              120,
                          height:
                              120,
                          child: IconButton(
                            icon: Icon(
                              Icons.pets,
                              size: 60,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListMascotas()),
                              );
                            },
                          ),
                        ),
                      ),
                      Text(
                        'Ver Mascotas',
                        style: TextStyle(
                          fontSize:
                              16,
                          color: Colors
                              .white, 
                        ),
                      ),
                    ],
                  )
                ],
              ),

              SizedBox(height: 20), 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Card(
                        color: Colors.transparent,
                        child: Container(
                          width:
                              120, 
                          height:
                              120, 
                          child: IconButton(
                            icon: Icon(
                              Icons.flag,
                              size: 60,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeClient()),
                              );
                            },
                          ),
                        ),
                      ),
                      Text(
                        'Ver Campañas',
                        style: TextStyle(
                          fontSize:
                              16,
                          color: Colors
                              .white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 20), 
                  Column(
                    children: <Widget>[
                      Card(
                        color: Colors.transparent,
                        child: Container(
                          width:
                              120,
                          height:
                              120,

                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              size: 60,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ActualizarCliente()),
                              );
                            },
                          ),
                        ),
                      ),
                      Text(
                        'Editar Perfil',
                        style: TextStyle(
                          fontSize:
                              16,
                          color: Colors
                              .white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
