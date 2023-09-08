import 'dart:io';
import 'package:fluttapp/presentation/littlescreens/validator.dart';
import 'package:fluttapp/presentation/screens/ListMascotas.dart';
import 'package:fluttapp/presentation/screens/SearchClient.dart';
import 'package:fluttapp/presentation/screens/ViewClient.dart';
import 'package:fluttapp/presentation/services/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPet extends StatefulWidget {
  @override
  _RegisterPetState createState() => _RegisterPetState();
}

class _RegisterPetState extends State<RegisterPet> {
  ValidadorCamposMascota validador = ValidadorCamposMascota();
  TextEditingController nombreController = TextEditingController();
  TextEditingController edadController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController razaController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  String? mensajeError;
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
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ListClient()),
          );
          return false; // Devuelve 'true' si quieres prevenir el cierre de la aplicación
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 241, 245, 255),
            title: Text('Registro Mascota',
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
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.asset(
                    "assets/Univallenavbar.png",
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre de la Mascota',
                      errorText: validador.mensajeErrorNombreMascota,
                    ),
                  ),
                  TextFormField(
                    controller: descripcionController,
                    decoration: InputDecoration(
                      labelText: 'Descripción de la Mascota',
                      errorText: validador.mensajeErrorDescripcionMascota,
                      counterText: '',
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    maxLength: 200,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  ),
                  TextField(
                    controller: edadController,
                    decoration: InputDecoration(
                      labelText: 'Edad de la Mascota',
                      errorText: validador.mensajeErrorEdadMascota,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: razaController,
                    decoration: InputDecoration(
                      labelText: 'Raza de la Mascota',
                      errorText: validador.mensajeErrorRazaMascota,
                    ),
                  ),
                  TextField(
                    controller: colorController,
                    decoration: InputDecoration(
                      labelText: 'Color del Animal',
                      errorText: validador.mensajeErrorColorMascota,
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
                          content:
                              Text('Se ha alcanzado el límite de 3 imágenes.'),
                        ));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary:
                          Color(0xFF5C8ECB), // Cambiar el color del botón aquí
                    ),
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
                      bool camposValidos = validarCampos();
                      if (camposValidos) {
                        await mostrarFinalizar.Mostrar_Finalizados(
                            context, "Registro Con Éxito!");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListMascotas(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary:
                          Color(0xFF5C8ECB), // Cambiar el color del botón aquí
                    ),
                    child: Text('Registrar Mascota'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListMascotas(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary:
                          Color(0xFF5C8ECB), // Cambiar el color del botón aquí
                    ),
                    child: Text('Cancelar'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  bool validarCampos() {
    bool nombreValido = validador.validarNombreMascota(nombreController.text);
    bool descripcionValido =
        validador.validarDescripcionMascota(descripcionController.text);
    bool edadValido = validador.validarEdadMascota(edadController.text);
    bool razaValido = validador.validarRazaMascota(razaController.text);
    bool colorValido = validador.validarColorMascota(colorController.text);

    setState(() {
      validador.mensajeErrorNombreMascota =
          nombreValido ? null : validador.mensajeErrorNombreMascota;
      validador.mensajeErrorDescripcionMascota =
          descripcionValido ? null : validador.mensajeErrorDescripcionMascota;
      validador.mensajeErrorEdadMascota =
          edadValido ? null : validador.mensajeErrorEdadMascota;
      validador.mensajeErrorRazaMascota =
          razaValido ? null : validador.mensajeErrorRazaMascota;
      validador.mensajeErrorColorMascota =
          colorValido ? null : validador.mensajeErrorColorMascota;
    });

    return nombreValido &&
        descripcionValido &&
        edadValido &&
        razaValido &&
        colorValido;
  }
}
