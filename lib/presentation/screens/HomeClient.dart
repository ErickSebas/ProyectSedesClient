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
import 'package:fluttapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttapp/services/firebase_service.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeClient extends StatefulWidget {
  const HomeClient({super.key});

  @override
  _HomeClientState createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient> {
final Completer<GoogleMapController> _controllerCompleter = Completer<GoogleMapController>();
List<LatLng> polylinePointsCoordinates = [];
List<Marker> markers = [];
LocationData? currentLocation;
static LatLng myPosition = LatLng(0, 0);
static LatLng destination = LatLng(0, 0);
late LatLng _center = const LatLng(0, 0);
double currentZoom = 14.5;
late GoogleMapController mapController;
bool estaExpandido = true;
bool follow = false;
ValueNotifier<List<Marker>> markersNotifier = ValueNotifier(([]));
ValueNotifier<LatLng> centerNotifier = ValueNotifier(LatLng(0, 0));

void _onMapCreated(GoogleMapController controller) async {
  mapController = controller;
  _goToUserLocation();
  //originDestination(); 

  Location location = Location();

  location.getLocation().then((location){

  });

  location.onLocationChanged.listen((newLoc) {
    myPosition =LatLng(newLoc.latitude!, newLoc.longitude!);
    if(follow){
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(newLoc.latitude!, newLoc.longitude!),
      zoom: currentZoom,
      )));
    }
  });
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
  myPosition = LatLng(position.latitude, position.longitude);
  mapController.animateCamera(CameraUpdate.newCameraPosition(
    CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14.5,
    ),
  ));

  
}

void originDestination() async{
  destination = LatLng(markers.last.position.latitude, markers.last.position.longitude);
  
  markers.add(
    Marker(
      markerId: MarkerId("destination"),
      position: destination,
    ),
  );
}

Future<void> getPolyPoints(LatLng destination) async {
  polylinePointsCoordinates.clear();
  PolylinePoints polylinePoints = PolylinePoints();
  

  PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    "AIzaSyD8VxZxvKCkDbGNwfoCoTMDfUODjnccBlM", 
    PointLatLng(myPosition.latitude, myPosition.longitude),
    PointLatLng(destination.latitude, destination.longitude)
  );

  if(result.points.isNotEmpty){
    result.points.forEach(
      (PointLatLng point) => polylinePointsCoordinates.add(
        LatLng(point.latitude, point.longitude),
      ),
    );
    follow = true;
    setState(() {  });
  }
}



  @override
  void initState(){
    super.initState();
    Permisos();
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
            icon: Image.asset(
              "assets/LogoUnivalle2.png",
              height: 50,
              width: 50,
            ),
            onPressed: () {
              // Informacion acerca de los desarrolladores
              Mostrar_Confirmacion();
            },
          ),   
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
                          //onMapCreated: _onMapCreated,
                        );
                      } else if (markersSnapshot.hasError) {
                        return Center(
                          child: Text('Error: ${markersSnapshot.error}'),
                        );
                      } else if (markersSnapshot.hasData) {
                        return Stack(children: [
                          GoogleMap(
                            onCameraMove: (CameraPosition position) {
                              currentZoom = position.zoom;
                            },
                            myLocationEnabled: true,
                            key: ValueKey("key"),
                            initialCameraPosition: const CameraPosition(
                              target: LatLng(-17.3895000, -66.1568000),
                              zoom: 14.5,
                            ),
                            markers: Set<Marker>.of(markers),
                            onMapCreated: _onMapCreated,
                            minMaxZoomPreference: MinMaxZoomPreference(12,18),
                            polylines: {
                              Polyline(
                                polylineId: PolylineId("route"),
                                points: polylinePointsCoordinates,
                                color: primaryColor,
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
                                    follow ? ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          follow = false;
                                          polylinePointsCoordinates.clear();
                                        });
                                        
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.close, color: Colors.white), // Icono de una "X"
                                          SizedBox(width: 5), // Espacio entre el ícono y el texto
                                          Text('Cancelar', style: TextStyle(color: Colors.white)), // Texto "Cancelar"
                                        ],
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF5A7999), // Color de fondo
                                        shape: RoundedRectangleBorder( // Forma cuadrada con bordes redondeados
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Espaciado interno
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
          onTap: () {
            _showDirectionsButton(LatLng(
              double.parse(location['latitude']),
              double.parse(location['longitude']),
            ), location['name']);
          },
        )
      );
      
    }
    //
    
    return markers;
  }

  void _showDirectionsButton(LatLng destination, String nombre) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.transparent, // Hacerlo transparente para permitir interacciones con el fondo
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
                          maxLines: 2, // Puedes ajustar esto según tus necesidades
                        ),
                      )

                    ],
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await getPolyPoints(LatLng(destination.latitude, destination.longitude));
                    
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





  Future<void> Mostrar_Confirmacion() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('MaYpiVaC')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              Image.asset("assets/LogoUnivalle.png", height: 150, width: 150),
              SizedBox(height: 10),
              Text(
                'Responsables de desarrollo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Card(
                elevation: 4,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Docente Administrativo',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        Text(' Christian Montaño Salvatierra'),
                        Text('cmontanosa@univalle.edu'),
                      ],
                    )),
              ),
              Card(
                elevation: 4,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Estudiantes:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        Text('Erick Urquiza Mendoza'),
                        Text('Fabian Mendez Mejia'),
                        Text('Pedro Conde Valdez'),
                        Text('Jose Bascope Tejada'),
                      ],
                    )),
              ),
              SizedBox(height: 10),
              Text('©Univalle-MaYpiVaC 2023', style: TextStyle(fontSize: 16)),
              Text('Todos los derechos reservados',
                  style: TextStyle(fontSize: 16)),
            ],
          ),
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
                    width: 80, // Adjust width as needed
                    height: 40, // Adjust height as needed
                    child: TextButton(
                      child: Text(
                        'Cerrar',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
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
}