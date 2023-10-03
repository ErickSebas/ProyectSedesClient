import 'dart:convert';
import 'dart:io';
import 'package:fluttapp/Models/Profile.dart';
import 'package:fluttapp/presentation/littlescreens/validator.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/ListMascotas.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/SearchClient.dart';
import 'package:fluttapp/presentation/screens/Cliente/HomeClient.dart';
import 'package:fluttapp/presentation/services/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

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

  Future<void> registerPet() async {
    final url = Uri.parse('http://10.10.0.146:3000/registerPet');

    final response = await http.post(
      url,
      body: jsonEncode({
        'Nombre': nombreController.text,
        'Raza': razaController.text,
        'Edad': edadController.text,
        'Color': colorController.text,
        'Descripcion': descripcionController.text,
        'IdPersona': '9',
        'Sexo': 'H',
        'IdQr': '1'
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Registro exitoso
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar la mascota')),
      );
    }
  }

  String valorSeleccionado = 'H'; // Valor por defecto seleccionado

  List<String> opciones = ['Hembra', 'Macho']; // Lista de opciones

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                      30), // Limita a 30 caracteres
                ],
                maxLength:
                    30, // Puedes usar esta propiedad también para indicar el límite máximo
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
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                      30), // Limita a 30 caracteres
                ],
                maxLength:
                    30, // Puedes usar esta propiedad también para indicar el límite máximo
              ),
              Row(
                children: [
                  Expanded(
                    child: Text("Sexo de la mascota"),
                  ),
                  SizedBox(width: 10), // Espacio entre el TextField y el Text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sexo'),
                      DropdownButton<String>(
                        value: valorSeleccionado,
                        onChanged: (String? newValue) {
                          setState(() {
                            valorSeleccionado = newValue!;
                          });
                        },
                        items: opciones
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value == 'Hembra' ? 'H' : 'M',
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
              TextField(
                controller: colorController,
                decoration: InputDecoration(
                  labelText: 'Color del Animal',
                  errorText: validador.mensajeErrorColorMascota,
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                      30), // Limita a 30 caracteres
                ],
                maxLength:
                    30, // Puedes usar esta propiedad también para indicar el límite máximo
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
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF5C8ECB), // Cambiar el color del botón aquí
                ),
                child: Text('Cargar Fotos de la Mascota'),
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
                    print("1.-" +
                        nombreController.text +
                        razaController.text +
                        edadController.text +
                        colorController.text +
                        descripcionController.text);
                    await registerPet();

                    await mostrarFinalizar.Mostrar_Finalizados(
                        context, "Registro Con Éxito!");
                    print("3.-" +
                        nombreController.text +
                        razaController.text +
                        edadController.text +
                        colorController.text +
                        descripcionController.text);
                    MaterialPageRoute(
                      builder: (context) =>
                          ListMascotas(), // Pasa el ID del usuario aquí
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF5C8ECB), // Cambiar el color del botón aquí
                ),
                child: Text('Registrar Mascota'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pushNamed("/listPets");
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF5C8ECB), // Cambiar el color del botón aquí
                ),
                child: Text('Cancelar'),
              ),
            ],
          ),
        ),
      ),
    );
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
