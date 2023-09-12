import 'package:fluttapp/presentation/littlescreens/Popout.dart';
import 'package:flutter/material.dart';

void main() => runApp(ViewClient());

class ViewClient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CampaignPage();
  }
}

Future<void> Mostrar_Informacion(BuildContext context) async {
  await InfoDialog.MostrarInformacion(context);
}

class CampaignPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 241, 245, 255),
        centerTitle: true,
        title: Row(
          children: [
            Expanded(
              child: GestureDetector(
                child: Image.asset("assets/Univallenavbar.png"),
              ),
            ),
            GestureDetector(
              onTap: () {
                Mostrar_Informacion(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/LogoU.png",
                  height: 32,
                  width: 32,
                ),
              ),
            ),
          ],
        ),
      ),
       drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Splash.png'), // Ruta de tu imagen
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF5C8ECB),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/univalle.png', // Reemplaza con tu propia imagen
                        width: 50,
                        height: 50,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Juan Topo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        'Administrador',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text('Opción 1'),
                onTap: () {
                  // Lógica al seleccionar la opción 1
                },
              ),
              ListTile(
                title: Text('Opción 2'),
                onTap: () {
                  // Lógica al seleccionar la opción 2
                },
              ),
              ListTile(
                title: Text('Opción 3'),
                onTap: () {
                  // Lógica al seleccionar la opción 1
                },
              ),
              ListTile(
                title: Text('Opción 4'),
                onTap: () {
                  // Lógica al seleccionar la opción 2
                },
              ),
              ListTile(
                title: Text('Opción 5'),
                onTap: () {
                  // Lógica al seleccionar la opción 1
                },
              ),
              ListTile(
                title: Text('Opción 6'),
                onTap: () {
                  // Lógica al seleccionar la opción 2
                },
              ),
              // Agrega más ListTile según sea necesario
            ],
          ),
        ),
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
                          width: 120,
                          height: 120,
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              size: 60,
                              color: const Color(0xFF5C8ECB),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed("/listClients");
                            },
                          ),
                        ),
                      ),
                      Text(
                        'Crear Mascota',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xFF5C8ECB),
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
                          width: 120,
                          height: 120,
                          child: IconButton(
                            icon: Icon(
                              Icons.pets,
                              size: 60,
                              color: Color(0xFF5C8ECB),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed("/listPets");
                            },
                          ),
                        ),
                      ),
                      Text(
                        'Ver Mascotas',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueAccent,
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
                          width: 120,
                          height: 120,
                          child: IconButton(
                            icon: Icon(
                              Icons.flag,
                              size: 60,
                              color: const Color(0xFF5C8ECB),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed("/viewMap");
                            },
                          ),
                        ),
                      ),
                      Text(
                        'Ver Campañas',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF5C8ECB),
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
                          width: 120,
                          height: 120,
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              size: 60,
                              color: Color(0xFF5C8ECB),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed("/updateClient");
                            },
                          ),
                        ),
                      ),
                      Text(
                        'Editar Perfil',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF5C8ECB),
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
