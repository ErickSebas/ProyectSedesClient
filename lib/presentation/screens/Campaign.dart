import 'package:fluttapp/presentation/screens/Maps.dart';
import 'package:fluttapp/presentation/services/services_firebase.dart';
import 'package:fluttapp/services/connectivity_service.dart';
import 'package:fluttapp/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttapp/Models/CampaignModel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

int estadoPerfil = 0;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Actividades',
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
  String selectedCategory = 'Vacuna'; 
  List<String> categories = ['Vacuna', 'Carnetizacion', 'Control de Foco', 'Vacunación Continua', 'Rastrillaje']; 
  
  bool isLoading=false;
  final now = DateTime.now();
  int cont = 0;

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
    fetchCampaigns().then((value) => {
      setState((){
        campaigns = value;
      })
    });
    _connectivityService.initialize(context);
  }

  @override
  void dispose() {
    _connectivityService.dispose();
    super.dispose();
  }

    Color getStatusColor(DateTime start, DateTime end) {

    if (now.isAfter(end)) {
      return Colors.red; 
    } else if (now.isBefore(start)) {
      return Colors.blue; 
    } else {
      return Colors.green; 
    }
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
        title: Text('Actividades', style: TextStyle(color: Color(0xFF5C8ECB))),
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
                      color: Colors.white,
        /*decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Splash.png'),
            fit: BoxFit.cover,
          ),
        ),*/
        child: Column(
        children: [
          searchField,
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Color.fromARGB(255, 92, 142, 203),
                  width: 2.0,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true, 
                        value: selectedCategory,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Color(0xFF4D6596)),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                          });
                        },
                        items: categories.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCampaigns.length,
              itemBuilder: (context, index) {
                if(filteredCampaigns[index].categoria!=selectedCategory){
                  return SizedBox.shrink();
                }
                if (now.isAfter(filteredCampaigns[index].dateEnd)) {
                  return SizedBox.shrink(); 
                }
                return Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: const BorderSide(width: 2, color: Color(0xFF5C8ECB))
                  ),
                  margin: const EdgeInsets.all(10.0),
                  child:  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            filteredCampaigns[index].nombre,
                            style: TextStyle(
                              color: Color(0xFF4D6596),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: getStatusColor(
                              filteredCampaigns[index].dateStart,
                              filteredCampaigns[index].dateEnd,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            now.isAfter(filteredCampaigns[index].dateEnd)
                                ? 'Finalizado'
                                : now.isBefore(filteredCampaigns[index].dateStart)
                                    ? 'En espera'
                                    : 'En curso',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          filteredCampaigns[index].descripcion,
                          style: TextStyle(color: Color(0xFF4D6596)),
                        ),
                        Text(
                          "${DateFormat('dd/MM/yy').format(filteredCampaigns[index].dateStart)} - ${DateFormat('dd/MM/yy').format(filteredCampaigns[index].dateEnd)}",
                          style: TextStyle(
                            color: Color(0xFF4D6596),
                            fontSize: 12.0,
                          ),
                        ),
                      ],
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

