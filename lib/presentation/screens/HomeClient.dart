import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttapp/firebase_options.dart';
import 'package:fluttapp/services/firebase_service.dart';

class HomeClient extends StatelessWidget {
  const HomeClient({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CAMPAÑA DE VACUNACION 2023'),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset("assets/LogoSedes.png"),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
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
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  List? locations = snapshot.data;
                  List<Marker> markers = locations
                      !.map((location) => Marker(
                            markerId: MarkerId(location['name']),
                            position: LatLng(
                              double.parse(location['latitude']),
                              double.parse(location['longitude']),
                            ),
                            infoWindow: InfoWindow(title: location['name']),
                          ))
                      .toList();

                  return GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(-17.3895000, -66.1568000 ), // Posición inicial del mapa
                      zoom: 14.5,
                    ),
                    markers: Set<Marker>.of(markers),
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
}