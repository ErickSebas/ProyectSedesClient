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
                              120, // Ajusta el tamaño del Container según tus preferencias
                          height:
                              120, // Ajusta el tamaño del Container según tus preferencias

                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              size: 60,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Text(
                        'Crear Mascota',
                        style: TextStyle(
                          fontSize:
                              16, // Ajusta el tamaño del texto según tus preferencias
                          color: Colors
                              .white, // Cambia el color del texto según tus preferencias
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
                              120, // Ajusta el tamaño del Container según tus preferencias
                          height:
                              120, // Ajusta el tamaño del Container según tus preferencias

                          child: IconButton(
                            icon: Icon(
                              Icons.pets,
                              size: 60,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Text(
                        'Ver Mascotas',
                        style: TextStyle(
                          fontSize:
                              16, // Ajusta el tamaño del texto según tus preferencias
                          color: Colors
                              .white, // Cambia el color del texto según tus preferencias
                        ),
                      ),
                    ],
                  )
                ],
              ),

              SizedBox(height: 20), // Espacio entre filas de botones
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Card(
                        color: Colors.transparent,
                        child: Container(
                          width:
                              120, // Ajusta el tamaño del Container según tus preferencias
                          height:
                              120, // Ajusta el tamaño del Container según tus preferencias
                          child: IconButton(
                            icon: Icon(
                              Icons.flag,
                              size: 60,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Text(
                        'Ver Campañas',
                        style: TextStyle(
                          fontSize:
                              16, // Ajusta el tamaño del texto según tus preferencias
                          color: Colors
                              .white, // Cambia el color del texto según tus preferencias
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
                              120, // Ajusta el tamaño del Container según tus preferencias
                          height:
                              120, // Ajusta el tamaño del Container según tus preferencias

                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              size: 60,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ), // Espacio entre el icono y el texto
                        ),
                      ),
                      Text(
                        'Editar Perfil',
                        style: TextStyle(
                          fontSize:
                              16, // Ajusta el tamaño del texto según tus preferencias
                          color: Colors
                              .white, // Cambia el color del texto según tus preferencias
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
