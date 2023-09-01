import 'dart:io';
import 'package:fluttapp/presentation/screens/HomeClient.dart';
import 'package:fluttapp/presentation/services/alert.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPet extends StatefulWidget {
  @override
  _RegisterPetState createState() => _RegisterPetState();
}

class _RegisterPetState extends State<RegisterPet> {
  List<File?> _selectedImages = []; 
  MostrarFinalizar mostrarFinalizar = MostrarFinalizar();
  Future<void> Confirmacion_Eliminar_Imagen(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Imagen'),
          content: Text('¿Estás seguro de que deseas eliminar esta imagen?'),
          actions: <Widget>[
            TextButton(
              child: Text('Sí'),
              onPressed: () {
                setState(() {
                  _selectedImages.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Mascota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset("assets/SplashMaypivac.png", height: 130, width: 130),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nombre de la Mascota',
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Descripción de la Mascota',
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Edad de la Mascota',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Raza de la Mascota',
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Color del Animal',
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (_selectedImages.length < 3) {
                    final picker = ImagePicker();
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);

                    if (pickedFile != null) {
                      setState(() {
                        _selectedImages.add(File(pickedFile.path));
                      });
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Se ha alcanzado el límite de 3 imágenes.'),
                    ));
                  }
                },
                child: Text('Cargar Foto del Animal'),
              ),
                            SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _selectedImages.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final File? image = entry.value;
                    return GestureDetector(
                      onTap: () {
                        Confirmacion_Eliminar_Imagen(index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: image != null
                            ? Image.file(
                                image,
                                width: 100,
                                height: 100,
                              )
                            : SizedBox(),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await mostrarFinalizar.Mostrar_Finalizados(context, "Registro Con Éxito!");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeClient()),
                  );
                },
                child: Text('Registrar Mascota'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}