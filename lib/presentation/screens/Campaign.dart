import 'package:fluttapp/presentation/screens/Maps.dart';
import 'package:fluttapp/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttapp/Models/CampaignModel.dart';

int estadoPerfil = 0;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campañas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  Widget build(BuildContext context) {
    final searchField = Padding(
      padding: const EdgeInsets.all(12),
      child: TextFormField(
        style: TextStyle(color: Colors.blueAccent),
        decoration: InputDecoration(
          hintText: 'Buscar',
          hintStyle: TextStyle(color: Colors.blueAccent),
          prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
        ),
        onChanged: searchCampaign,
      ),
    );

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 245, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 241, 245, 255),
        title: Text('Campañas', style: TextStyle(color: Colors.blueAccent)),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.blueAccent),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: isLoading?CircularProgressIndicator(): Container(
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
                  ),
                  margin: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text(
                      filteredCampaigns[index].nombre,
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      filteredCampaigns[index].descripcion,
                      style: TextStyle(color: Colors.blueAccent),
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
      ),) 
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
            CircularProgressIndicator(),
            SizedBox(width: 15),
            Text("Cargando..."),
          ],
        ),
      );
    },
  );
}

