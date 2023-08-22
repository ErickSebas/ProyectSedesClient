import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttapp/firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
runApp(const HomeClient());
}

class HomeClient extends StatelessWidget {
  const HomeClient({super.key});

  static const LatLng sourceLocation = LatLng(37.3350926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: sourceLocation,
                  zoom: 14.5,
                ),
                markers: {
                  const Marker(
                    markerId: MarkerId("sourceMarker"),
                    position: sourceLocation,
                    infoWindow: InfoWindow(title: "Origen"),
                  ),
                  const Marker(
                    markerId: MarkerId("destinationMarker"),
                    position: destination,
                    infoWindow: InfoWindow(title: "Destino"),
                  ),
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset("assets/LogoOficialVectorizado.png", height: 70, width: 200),
                  Image.asset("assets/MarcaDepartamental.png", height: 70, width: 200),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}