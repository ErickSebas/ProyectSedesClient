import 'package:fluttapp/presentation/screens/ViewClient.dart';
import 'package:flutter/material.dart';

void main() => runApp(ViewMascotas());

class ViewMascotas extends StatelessWidget {
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
        backgroundColor: Color.fromARGB(255, 11, 29, 61),
        title:
            Text('Datos de la Mascota', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/BackGround.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.all(10),
                color: Color.fromARGB(255, 18, 58, 88),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                20.0), // Ajusta el radio según tus preferencias
                            child: Image.asset(
                                'assets/Perro.png'), // Imagen con radio de contorno
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Doggy',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'French Mastiff',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '8 meses',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Naranja',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Tiene una patita coja',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Vacuna Antirrabica',
                                style: TextStyle(color: Colors.white),
                              ),
                              // Otros widgets de información
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
                                    color: Colors.white, fontSize: 20),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: EdgeInsets.all(10),
                                child: Card(
                                  color: Color.fromARGB(255, 18, 58, 88),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
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
                height: 20, // Espacio entre el Card y el botón
              ),
              Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ViewClient()),
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
                            style: TextStyle(color: Colors.white),
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
