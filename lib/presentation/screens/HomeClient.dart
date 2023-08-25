/// <summary>
/// Nombre de la aplicación: MaYpiVaC
/// Nombre del desarrollador: Equipo-Sedes-Univalle
/// Fecha de creación: 18/08/2023
/// </summary>
/// 
// <copyright file="HomeClient.dart" company="Sedes-Univalle">
// Esta clase está restringida para su uso, sin la previa autorización de Sedes-Univalle.
// </copyright>


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttapp/services/firebase_service.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeClient extends StatefulWidget {
  const HomeClient({super.key});

  @override
  _HomeClientState createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient> {
final Completer<GoogleMapController> _controllerCompleter = Completer<GoogleMapController>();
List<Marker> markers = [];
late LatLng? myPosition;
late LatLng _center = const LatLng(0, 0);
late GoogleMapController mapController;
bool estaExpandido = true;
ValueNotifier<List<Marker>> markersNotifier = ValueNotifier(([]));
ValueNotifier<LatLng> centerNotifier = ValueNotifier(LatLng(0, 0));

void _onMapCreated(GoogleMapController controller) {
  mapController = controller;
  _goToUserLocation();
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

void Permisos() async{
  LocationPermission permiso;
    permiso = await Geolocator.checkPermission();
    if(permiso == LocationPermission.denied){
      permiso = await Geolocator.requestPermission();
      if(permiso == LocationPermission.denied){
        return Future.error('error');
      }
  }
}

Future<void> _goToUserLocation() async {
  Permisos();
  final Position position = await Geolocator.getCurrentPosition();
  mapController.animateCamera(CameraUpdate.newCameraPosition(
    CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14.5,
    ),
  ));
}



  Future<Position> Determinar_Posicion() async {
    LocationPermission permiso;
    permiso = await Geolocator.checkPermission();
    if(permiso == LocationPermission.denied){
      permiso = await Geolocator.requestPermission();
      if(permiso == LocationPermission.denied){
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

 

  @override
  void initState(){
    super.initState();
    Permisos();
    //_goToUserLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('MaYpiVaC'),
        backgroundColor: Color(0xFF86ABF9),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset("assets/LogoSedes.png"),
        ),
        actions: [
  IconButton(
    icon: Icon(Icons.close),
    onPressed: () {
      // Cierra la aplicación por completo
      SystemNavigator.pop();
    },
  ),
],
      ),
      body:Column(
        children: [
          
          Expanded(
            child: FutureBuilder(
              future: Obtener_Archivo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF86ABF9)),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  List? locations = snapshot.data;
                      return FutureBuilder<List<Marker>>(
                    // Build the list of markers asynchronously
                    future: Crear_Puntos(locations),
                    builder: (context, markersSnapshot) {
                      if (markersSnapshot.connectionState == ConnectionState.waiting) {
                        return GoogleMap(
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(-17.3895000, -66.1568000),
                            zoom: 14.5,
                          ),
                          onMapCreated: _onMapCreated,
                        );
                      } else if (markersSnapshot.hasError) {
                        return Center(
                          child: Text('Error: ${markersSnapshot.error}'),
                        );
                      } else if (markersSnapshot.hasData) {
                        return Stack(children: [
                          GoogleMap(
                            myLocationEnabled: true,
                            key: ValueKey("key"),
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(-17.3895000, -66.1568000),
                            zoom: 14.5,
                          ),
                          markers: Set<Marker>.of(markers),
                          onMapCreated: _onMapCreated,
                          minMaxZoomPreference: MinMaxZoomPreference(12,18),
                        ),
                          Positioned(
                            bottom: 16.0,
                            left: 16.0,
                            child: Align(
            //alignment: Alignment.centerRight,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              //width: estaExpandido ? 150 : 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (estaExpandido)
                    FloatingActionButton(
                      onPressed: () {
                        _launchURL("https://vm.tiktok.com/ZMjeVX9LC/");
                      },
                      child: Icon(Icons.tiktok_rounded),
                      backgroundColor: Color.fromRGBO(58,164,64,1),
                    ),
                  if (estaExpandido)

                    SizedBox(height: 10),
                    FloatingActionButton(
                      onPressed: () {
                        _launchURL("https://vm.tiktok.com/ZMjeVX9LC/");
                      },
                      child: Icon(Icons.tiktok_sharp),
                      backgroundColor: Color.fromRGBO(58,164,64,1),
                      //backgroundColor: Color.fromRGBO(251,234,3,1),
                    ),
                    SizedBox(height: 10),
                ],
              ),
            ),
          ),
                          ),
                        ],
                        );
                      } else {
                        return const Center(
                          child: Text('No hay datos disponibles.'),
                        );
                      }
                    },
                  );

                  
                  
                  
                } else {
                  return const Center(
                    child: Text('No hay datos disponibles.'),
                  );
                }
              },
            ),
          ),
    Align(
  alignment: Alignment.bottomCenter,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Expanded(
        child: GestureDetector(
          onTap: () {
          _launchURL("https://gobernaciondecochabamba.bo");
          
          },
          child: Image.asset(
            "assets/LogoOficialVectorizado.png",
            fit: BoxFit.contain,
          ),
        ),
      ),
      Expanded(
        child: GestureDetector(
          onTap: () {
          _launchURL("https://sedescochabamba.gob.bo");

          },
          child: Image.asset(
            "assets/MarcaDepartamental.png",
            fit: BoxFit.contain,
          ),
        ),
      ),
    ],
  ),
),
        ],
      ),
    );
  }

  Future<List<Marker>> Crear_Puntos(List<dynamic>? locations) async {
    for (var location in locations!) {
    BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
    ImageConfiguration(size: Size(100, 100)), 'assets/Way.png');
      markers.add(
        Marker(
          markerId: MarkerId(location['name']),
          position: LatLng(
            double.parse(location['latitude']),
            double.parse(location['longitude']),
          ),
          icon: customIcon,
          infoWindow: InfoWindow(title: location['name']),
          
        ),
      );
    }
    return markers;
  }
}