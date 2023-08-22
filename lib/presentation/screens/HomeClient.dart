import 'package:fluttapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(const HomeClient());



List<LatLng> polylineCoordinates = [];
class HomeClient extends StatelessWidget {
  const HomeClient({super.key});

  static const LatLng sourceLocation = LatLng(37.3350926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CAMPAÑA DE VACUNACION 2023'),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset("assets/cocacola.png"),
        ),
      ),
      body: GoogleMap(
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
    );
  }
}
