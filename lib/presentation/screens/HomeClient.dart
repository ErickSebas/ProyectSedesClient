import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttapp/services/firebase_service.dart';
import 'package:flutter/services.dart';

class HomeClient extends StatelessWidget {
  const HomeClient({super.key});

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
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getByFile(),
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
                    future: _createMarkers(locations),
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
                        return GoogleMap(
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(-17.3895000, -66.1568000),
                            zoom: 14.5,
                          ),
                          markers: Set<Marker>.of(markersSnapshot.data!),
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

  Future<List<Marker>> _createMarkers(List<dynamic>? locations) async {
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

    return markers;
  }
}