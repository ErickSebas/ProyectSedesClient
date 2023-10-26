import 'package:fluttapp/presentation/screens/Maps.dart';
import 'package:fluttapp/presentation/services/services_firebase.dart';
import 'package:fluttapp/services/connectivity_service.dart';
import 'package:fluttapp/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttapp/Models/CampaignModel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

int estadoPerfil = 0;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campañas',
      theme: ThemeData(
        primarySwatch: myColorMaterial,
      ),
      home: ListCampaignPage(),
    );
  }
}

class ListCampaignPage extends StatefulWidget {
  @override
  _CampaignStateState createState() => _CampaignStateState();
}

class _CampaignStateState extends State<ListCampaignPage> {
  List<Campaign> filteredCampaigns = campaigns;
  final ConnectivityService _connectivityService = ConnectivityService();
  
  bool isLoading=false;

  void searchCampaign(String query) {
    setState(() {
      filteredCampaigns = campaigns
          .where((campaign) =>
              campaign.nombre.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _connectivityService.initialize(context);
  }

  @override
  void dispose() {
    _connectivityService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchField = Padding(
      padding: const EdgeInsets.all(12),
      child: TextFormField(
        style: TextStyle(color: Color(0xFF5C8ECB)),
        decoration: InputDecoration(
          hintText: 'Buscar',
          hintStyle: TextStyle(color: Color(0xFF5C8ECB)),
          prefixIcon: Icon(Icons.search, color: Color(0xFF5C8ECB)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Color(0xFF5C8ECB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Color(0xFF5C8ECB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Color(0xFF5C8ECB)),
          ),
        ),
        onChanged: searchCampaign,
      ),
    );

    return  Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 245, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 241, 245, 255),
        title: Text('Campañas', style: TextStyle(color: Color(0xFF5C8ECB))),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF5C8ECB)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: isConnected.value? isLoading?SpinKitCircle(
                      color: Color.fromARGB(255, 221, 236, 255),
                      size: 50.0,
                    ): Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
        children: [
          searchField,
          Expanded(
            child: ListView.builder(
              itemCount: filteredCampaigns.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: const BorderSide(width: 2, color: Color(0xFF5C8ECB))
                  ),
                  margin: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text(
                      filteredCampaigns[index].nombre,
                      style: TextStyle(
                          color: Color(0xFF5C8ECB),
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      filteredCampaigns[index].descripcion,
                      style: TextStyle(color: Color(0xFF5C8ECB)),
                    ),
                   onTap: () async {
                      showLoadingDialog(context); 

                      locations = await Obtener_Archivo(filteredCampaigns[index].id);

                      Navigator.pop(context); 

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerCamapanas(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),) : Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(child: Text('Error: Connection failed')))
    );
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Evita que los usuarios cierren el diálogo
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SpinKitCircle(
                      color: Color(0xFF5C8ECB),
                      size: 50.0,
                    ),
            SizedBox(width: 15),
            Text("Cargando..."),
          ],
        ),
      );
    },
  );
}

