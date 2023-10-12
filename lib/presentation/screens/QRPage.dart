import 'dart:convert';

import 'package:fluttapp/Models/Mascota.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/HomeCarnetizador.dart';
import 'package:fluttapp/presentation/screens/ViewMascotaInfo.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isProcessing = false;


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
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.blue),
            onPressed: () { 
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (isProcessing) {
        return; 
      }
      isProcessing = true; 
      await controller.pauseCamera();
      print('QR Data: ${scanData.code}');
      getPetById(scanData.code.toString()).then((value) async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) => ViewMascotasInfo(value)));
        controller.resumeCamera();
        isProcessing = false; 
      });
    });
  }

 

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
  
  Future<Mascota> getPetById(String id) async {
    final response = await http.get(
        Uri.parse('http://181.188.191.35:3000/getpetbyid/'+id)); 

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Mascota pet = Mascota.fromJson(data[0]);
      return pet;
    } else {
      throw Exception('Failed to load member');
    }
  }
}