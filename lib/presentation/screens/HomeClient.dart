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
import 'package:fluttapp/presentation/littlescreens/Popout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttapp/services/firebase_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeClient extends StatefulWidget {
  const HomeClient({super.key});

  @override
  _HomeClientState createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient> {
List<Marker> lstMarcadores = [];
List<LatLng> lstPuntosdeCoordenadas = [];
static LatLng miPosicion = LatLng(0, 0);
late GoogleMapController controlMapa;
bool estaExpandido = true;
bool estaSiguiendo = false;
double zoomActual = 14.5;


@override
void initState(){
  super.initState();
}

///Llama al mapa que usamos de la libreria de google
void Creando_Mapa(GoogleMapController controller) {
  controlMapa = controller;
  Localizacion_Usuario();
  Location location = Location();
  location.getLocation().then((location){
  });
  location.onLocationChanged.listen((newLoc) {
    miPosicion =LatLng(newLoc.latitude!, newLoc.longitude!);
    if(estaSiguiendo){
      controlMapa.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(newLoc.latitude!, newLoc.longitude!),
      zoom: zoomActual,
      )));
    }
  });
}

/// Localizamos la ubicacion exacta del usuario
Future<void> Localizacion_Usuario() async {
  final Position position = await Geolocator.getCurrentPosition();
  controlMapa.animateCamera(CameraUpdate.newCameraPosition(
    CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14.5,
    ),
  ));
}

/// Llamamos al metodo al inicio del programa para poder usar los URLs de la aplicacion
Activar_Links(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'No se encuentra un URL valido $url';
  }
}

  ///Metodo que obtiene las distancias acordadas entre los puntos: Direccion actual
  ///del usuario y la direccion a la que quiera llegar
  Future<void> Obtener_Distancias_Acordadas(LatLng destination) async {
    lstPuntosdeCoordenadas.clear();
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    "AIzaSyD8VxZxvKCkDbGNwfoCoTMDfUODjnccBlM", 
    PointLatLng(miPosicion.latitude, miPosicion.longitude),
    PointLatLng(destination.latitude, destination.longitude)
  );

  if(result.points.isNotEmpty){
    result.points.forEach(
      (PointLatLng point) => lstPuntosdeCoordenadas.add(
        LatLng(point.latitude, point.longitude),
      ),
    );
    estaSiguiendo = true;//cambiar true
    setState(() {  });
  }
}
///Vamos a llamar al metodo mostrar informacion que viene desde Popout.dart
///en este metodo se tiene la pantalla emergente que aparece al dar click en el boton 
///de univalle
Future<void> Mostrar_Informacion() async {
    await InfoDialog.MostrarInformacion(context);
  }
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
          Mostrar_Informacion();
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
      body:Column(
        children: [
          Expanded(
            child:  FutureBuilder<List<Marker>>(
                    future: Crear_Puntos(locations),
                    builder: (context, markersSnapshot) {
                      if (markersSnapshot.connectionState == ConnectionState.waiting) {
                        return GoogleMap(
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(-17.3895000, -66.1568000),
                            zoom: 14.5,
                          ),
                        );
                      } else if (markersSnapshot.hasError) {
                        return Center(
                          child: Text('Error: ${markersSnapshot.error}'),
                        );
                      } else if (markersSnapshot.hasData) {
                        return Stack(children: [
                          GoogleMap(
                          onCameraMove: (CameraPosition position) {
                            zoomActual = position.zoom;
                          },
                          myLocationEnabled: true,
                          key: ValueKey("key"),
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(-17.3895000, -66.1568000),
                            zoom: 14.5,
                          ),
                          markers: Set<Marker>.of(lstMarcadores),
                          onMapCreated: Creando_Mapa,
                          minMaxZoomPreference: MinMaxZoomPreference(12,18),
                          polylines: {
                            Polyline(
                              polylineId: PolylineId("route"),
                              points: lstPuntosdeCoordenadas,
                              color: Color(0xFF7B61FF),
                              width: 6,
                            ),
                          },
                        ),
                        Positioned(
                            top: 16.0,
                            left: 16.0,
                            child: Align(
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                    estaSiguiendo ? ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          estaSiguiendo = false;
                                          lstPuntosdeCoordenadas.clear();
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.close, color: Colors.white),
                                          SizedBox(width: 5), 
                                          Text('Cancelar', style: TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF5A7999),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), 
                                      ),
                                    )
                                    : Container(),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ),
                          Positioned(
                            bottom: 16.0,
                            left: 16.0,
                            child: Align(
                            child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (estaExpandido)
                                  FloatingActionButton(
                                    onPressed: () {
                                      Activar_Links(lstlinks[0]["link"]);
                                      },
                                      child: Icon(Icons.tiktok_rounded),
                                       backgroundColor: Color.fromRGBO(58,164,64,1),
                                        ),
                                if (estaExpandido)
                                  SizedBox(height: 10),
                                    FloatingActionButton(
                                      onPressed: () {
                                        Activar_Links(lstlinks[1]["link"]);
                                        },
                                        child: Icon(Icons.tiktok_sharp),
                                        backgroundColor: Color.fromRGBO(58,164,64,1),
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
                    Activar_Links("https://gobernaciondecochabamba.bo");
                    },
                    child: Image.asset(
                      "assets/MarcaDepartamental.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                    Activar_Links("https://sedescochabamba.gob.bo");
                    },
                    child: Image.asset(
                      "assets/LogoSede.png",
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

  /// Crea las ubicaciones para que aparezcan en el mapa , heredando
  /// los puntos que llegan desde Firebase
    Future<List<Marker>> Crear_Puntos(List<dynamic>? locations) async {
    var cont = 1;
    for (var location in locations!) {
    BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
    ImageConfiguration(size: Size(100, 100)), 'assets/Waypoint.png');
      lstMarcadores.add(
        Marker(
          markerId: MarkerId(cont.toString()),
          position: LatLng(
            double.parse(location['latitude']),
            double.parse(location['longitude']),
          ),
          icon: customIcon,
          infoWindow: InfoWindow(title: location['name']),
          onTap: () {
            Mostrar_Direccion_Destino(LatLng(
              double.parse(location['latitude']),
              double.parse(location['longitude']),
            ), location['name']);
          },
        )
      );
      cont ++;
    }
    return lstMarcadores;
  }

  /// Apartado que muestra la distancia entre el usuario y el punto establecido antes
  /// de trazar la ruta.
  void Mostrar_Direccion_Destino(LatLng destination, String nombre) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
        return SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.only(top: 65.0, left: 12.0, right: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    elevation: 2,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/comollegar1.png', 
                          width: 24, 
                          height: 24, 
                        ),
                        Text('Tu Ubicación', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/comollegar2.png', 
                          width: 24, 
                          height: 24, 
                        ),
                        Text('Destino: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Flexible(
                          child: Text(
                            '${nombre}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2, 
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await Obtener_Distancias_Acordadas(LatLng(destination.latitude, destination.longitude));
                    },
                    child: Text('Cómo llegar'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}