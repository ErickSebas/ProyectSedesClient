import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttapp/presentation/littlescreens/Popout.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomeClientFacebookState extends State<HomeClientFacebook> {
  @override
  Widget build(BuildContext context) {
    // Aquí puedes construir el widget de tu página
    return HomeClientFacebookPage(widget: widget);
  }
}
class HomeClientFacebook extends StatefulWidget {
  final String profileImage;
  final String fbName;
  final String fbLastname;
  final String fbEmail;
  final String fbId;
  final String fbfirstname;
  final String fbAccessToken;
  const HomeClientFacebook(
      {Key? key,
      required this.fbAccessToken,
      required this.fbId,
      required this.fbEmail,
      required this.fbfirstname,
      required this.fbName,
      required this.fbLastname,
      required this.profileImage})
      : super(key: key);
      
 @override
  State<StatefulWidget> createState() {
    // Devuelve una instancia de HomeClientFacebookState
    return HomeClientFacebookState();
  }
}

Future<void> Mostrar_Informacion(BuildContext context) async {
  await InfoDialog.MostrarInformacion(context);
}

// ignore: must_be_immutable
class HomeClientFacebookPage extends StatelessWidget {
  final HomeClientFacebook widget;
  HomeClientFacebookPage({required this.widget});
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
        child: Column(
          // Envuelve CachedNetworkImage y ListView en un Column
          children: [
            Expanded(
              // Usa Expanded para asegurarte de que el ListView ocupe todo el espacio restante
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
            CachedNetworkImage(
              imageUrl: widget.profileImage,
              progressIndicatorBuilder: (context, url, progress) =>
                  CircularProgressIndicator(value: progress.progress),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
                          SizedBox(height: 10),
                          Text(
                            widget.fbName,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            widget.fbEmail,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
                  // Espacio entre botones
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
                              Navigator.of(context).pushNamed("/viewPetInfo");
                            },
                          ),
                        ),
                      ),
                      Text(
                        'Ver Tus Mascotas',
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
                              //Navigator.of(context).pushNamed("/updateClient", arguments: loggedInPerson);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //NAVEGACION A LOS COSOS DEL QR
        },
        child: Icon(Icons.qr_code),
        backgroundColor: Color(0xFF5C8ECB),
      ),
    );
  }
}
