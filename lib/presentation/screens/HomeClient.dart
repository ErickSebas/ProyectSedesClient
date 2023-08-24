/// <summary>
/// Nombre de la aplicación: MaYpiVaC
/// Nombre del desarrollador: Equipo-Sedes-Univalle
/// Fecha de creación: 18/08/2023
/// </summary>
/// 
// <copyright file="HomeClient.dart" company="Sedes-Univalle">
// Esta clase está restringida para su uso, sin la previa autorización de Sedes-Univalle.
// </copyright>


import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttapp/services/firebase_service.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';


const MAPBOX_ACCESS_TOKEN='';

class HomeClient extends StatefulWidget {
  const HomeClient({super.key});

  @override
  _HomeClientState createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient> {
late LatLng? myPosition;
late LatLng _center = const LatLng(0, 0);
late GoogleMapController mapController;
bool estaExpandido = false;

void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.animateCamera(CameraUpdate.newLatLng(_center));
    mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_center.latitude, _center.longitude),
          zoom: 14.5,
        ),
      ),
    );
  }

  Future<void> Actualizar_Ubicacion() async {
  LatLng newLocation = LatLng(_center.latitude, _center.longitude);
  mapController.animateCamera(CameraUpdate.newLatLng(newLocation));
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

  Obtener_Ubicacion_Actual() async{
    Position posicion = await Determinar_Posicion();

    setState(() {
      myPosition = LatLng(posicion.latitude, posicion.longitude);
      _center = LatLng(posicion.latitude, posicion.longitude);
      //mapController.animateCamera(CameraUpdate.newLatLng(_center));
    });
    return posicion;
  }

  @override
  void initState(){
    Obtener_Ubicacion_Actual(); // que este metodo se ejecute cuando el mapController no sea nullo, usa await o lo q sea
    //_getLocation();
    super.initState();
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
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(-17.3895000, -66.1568000),
                            zoom: 14.5,
                          ),
                          markers: Set<Marker>.of(markersSnapshot.data!),
                          onMapCreated: _onMapCreated,
                        ),
                        Positioned(
                            top: 16.0,
                            left: 16.0,
                            child: FloatingActionButton(
                              onPressed: Actualizar_Ubicacion,
                              tooltip: 'Update Location',
                              child: Icon(Icons.location_searching),
                              backgroundColor: Color(0xFF86ABF9), 
                            ),
                          ),
                          Positioned(
                            top: 16.0,
                            right: 16.0,
                            child: Align(
            //alignment: Alignment.centerRight,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: estaExpandido ? 150 : 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  
                  
                  if (estaExpandido)
                    FloatingActionButton(
                      onPressed: () {
                        
                      },
                      child: Icon(Icons.vaccines_sharp),
                      backgroundColor: Color(0xFF86ABF9),
                    ),
                  if (estaExpandido)
                    FloatingActionButton(
                      onPressed: () {

                      },
                      child: Icon(Icons.facebook_sharp),
                      backgroundColor: Color(0xFF86ABF9),
                    ),
                  if (estaExpandido)
                    FloatingActionButton(
                      onPressed: () {

                      },
                      child: Icon(Icons.tiktok_sharp),
                      backgroundColor: Color(0xFF86ABF9),
                    ),
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
                  child: Image.asset(
                    "assets/LogoOficialVectorizado.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    "assets/MarcaDepartamental.png",
                    fit: BoxFit.contain,
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
    List<Marker> markers = [];

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
    BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
  ImageConfiguration(size: Size(50, 50)), 'assets/imgUbicacionA.png');
    markers.add(
        Marker(
          markerId: MarkerId("curr_loc"),
          position: _center,
          icon: customIcon,
          infoWindow: InfoWindow(title: 'Tú'),
        ),
        
      );

    return markers;
  }
}