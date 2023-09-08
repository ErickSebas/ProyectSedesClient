import 'package:fluttapp/presentation/screens/ListMascotas.dart';
import 'package:flutter/material.dart';

void main() => runApp(ViewMascotasInfo());

class ViewMascotasInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InfoMascotas();
  }
}

class InfoMascotas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 241, 245, 255),
        title: Text('Datos de la Mascota',
            style: TextStyle(color: const Color.fromARGB(255, 70, 65, 65))),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.all(10),
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.asset('assets/Perro.png'),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Doggy',
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'French Mastiff',
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '8 meses',
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Naranja',
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Tiene una patita coja',
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Vacuna Antirrabica',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Dueño',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: EdgeInsets.all(10),
                                child: Card(
                                  color: Colors.transparent,
                                  shape: RoundedRectangleBorder(),
                                  child: SizedBox(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Juan Pedro',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Topo Quispe',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Goku1234@gmail.com',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Av. Simon Lopez y Bejing',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ListMascotas()),
                      );
                    },
                    child: Card(
                      color: Colors.transparent,
                      child: Container(
                        width: 120,
                        height: 60,
                        child: Center(
                          child: Text(
                            'Volver',
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
