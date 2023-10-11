import 'dart:convert';
import 'dart:io';
import 'package:fluttapp/presentation/littlescreens/validator.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/ListMascotas.dart';
import 'package:fluttapp/presentation/services/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image/image.dart' as img;

int? idUser;

class RegisterPet extends StatefulWidget {
  late final int userId;
  RegisterPet({required this.userId}) {
    idUser = this.userId;
    print('ID de usuario en Buscar Clientes: $idUser');
  }

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

  Future<List<int>> compressImage(File imageFile) async {
    // Leer la imagen
    List<int> imageBytes = await imageFile.readAsBytes();

    // Decodificar la imagen
    img.Image image = img.decodeImage(Uint8List.fromList(imageBytes))!;

    // Comprimir la imagen con una calidad específica (85 en este caso)
    List<int> compressedBytes = img.encodeJpg(image, quality: 85);

    return compressedBytes;
  }

  Future<bool> uploadImages(List<File?> images) async {
    try {
      final firebase_storage.Reference storageRef =
          firebase_storage.FirebaseStorage.instance.ref();
      int ultimoId = await fetchLastPetId();
      print("Ultimo ID ======== $ultimoId" + "---" + widget.userId.toString());
      String carpeta = 'cliente/${widget.userId}/$ultimoId';

      int contador = 1;

      for (var image in images) {
        if (image != null) {
          String imageName = '$contador';

          firebase_storage.Reference imageRef =
              storageRef.child('$carpeta/$imageName.jpg');

          // Comprimir la imagen antes de subirla
          List<int> compressedBytes = await compressImage(image);

          await imageRef.putData(Uint8List.fromList(compressedBytes));

          contador++;
        }
      }

      return true;
    } catch (e) {
      print('Error al subir imágenes: $e');
      return false;
    }
  }

  Future<int> fetchLastPetId() async {
    final response =
        await http.get(Uri.parse('http://10.10.0.42:3000/lastidmascota'));

    final dynamic data = json.decode(response.body);
    return data['ultimo_id'] as int;
  }

/*
comprimir

Future<List<int>> compressImage(File imageFile) async {
  // Leer la imagen
  List<int> imageBytes = await imageFile.readAsBytes();

  // Decodificar la imagen
  img.Image image = img.decodeImage(Uint8List.fromList(imageBytes))!;

  // Calcular la calidad de compresión necesaria para que el tamaño sea inferior a 200 KB
  int quality = 100;
  while (image.length > 200 * 1024 && quality > 0) {
    quality -= 5;
    List<int> compressedBytes = img.encodeJpg(image, quality: quality);
    image = img.decodeImage(Uint8List.fromList(compressedBytes))!;
  }

  return img.encodeJpg(image, quality: quality);
}

Future<bool> uploadImages(List<File?> images) async {
  try {
    final firebase_storage.Reference storageRef =
        firebase_storage.FirebaseStorage.instance.ref();

    String carpeta = 'cliente/16';

    for (var image in images) {
      if (image != null) {
        String imageName = DateTime.now().millisecondsSinceEpoch.toString();
        firebase_storage.Reference imageRef =
            storageRef.child('$carpeta/$imageName.jpg');

        // Comprimir la imagen antes de subirla
        List<int> compressedBytes = await compressImage(image);

        await imageRef.putData(Uint8List.fromList(compressedBytes));
      }
    }

    return true;
  } catch (e) {
    print('Error al subir imágenes: $e');
    return false;
  }
}

subir imagenes
Future<bool> uploadImages(List<File?> images) async {
    try {
      final firebase_storage.Reference storageRef =
          firebase_storage.FirebaseStorage.instance.ref();

      // Obtener el último ID de mascota
      //int ultimoId = await fetchLastPetId();
      //print("Ultimo ID ======== $ultimoId");

      // Crear el nombre de la carpeta
      //String carpeta = 'cliente/$ultimoId';
      String carpeta = 'cliente/16';
      // Iterar sobre las imágenes y subirlas
      for (var image in images) {
        if (image != null) {
          String imageName = DateTime.now().millisecondsSinceEpoch.toString();
          // Usar el nombre de la carpeta en la ruta
          firebase_storage.Reference imageRef =
              storageRef.child('$carpeta/$imageName.jpg');

          await imageRef.putFile(image);
        }
      }

      return true;
    } catch (e) {
      print('Error al subir imágenes: $e');
      return false;
    }
  }

  Future<int> fetchLastPetId() async {
    final response =
        await http.get(Uri.parse('http://181.188.191.35:3000/lastidmascota'));

    final dynamic data = json.decode(response.body);
    return data['ultimo_id'] as int;
  }
*/
  Future<void> registerPet() async {
    final url = Uri.parse('http://181.188.191.35:3000/registerPet');

    final response = await http.post(
      url,
      body: jsonEncode({
        'Nombre': nombreController.text,
        'Raza': razaController.text,
        'Edad': edadController.text,
        'Color': colorController.text,
        'Descripcion': descripcionController.text,
        'IdPersona': '${widget.userId}',
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

/*
  Future<void> registerPet() async {
    final url = Uri.parse('http://181.188.191.35:3000/registerPet2');

    var request = http.MultipartRequest('POST', url);

    // Agregar las imágenes a la petición
    for (var image in _selectedImages) {
      if (image != null) {
        print('Nombre del archivo: ${image.path.split('/').last}');

        var stream = http.ByteStream(Stream.castFrom(image.openRead()));
        var length = await image.length();

        var multipartFile = http.MultipartFile('Imagenes', stream, length,
            filename: image.path.split('/').last);
        print('MultipartFile: $multipartFile');
        request.files.add(multipartFile);
      }
    }

    // Agregar los otros datos
    request.fields.addAll({
      'Nombre': nombreController.text,
      'Raza': razaController.text,
      'Edad': edadController.text,
      'Color': colorController.text,
      'Descripcion': descripcionController.text,
      'IdPersona': '9',
      'Sexo': 'H',
      'IdQr': '1',
    });

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        // Registro exitoso
        print('Mascota registrada con éxito');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar la mascota')),
        );
      }
    } catch (error) {
      print('Error en la solicitud: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar la solicitud')),
      );
    }
  }
*/

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
                  if (_selectedImages.length >= 5) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Se ha alcanzado el límite de 5 imágenes.'),
                    ));
                    return;
                  }

                  final picker = ImagePicker();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);

                  if (pickedFile != null) {
                    setState(() {
                      _selectedImages.add(File(pickedFile.path));
                    });
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

                  if (_selectedImages.length < 3) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Debe cargar al menos 3 imágenes.'),
                    ));
                    return; // Sale de la función si no hay suficientes imágenes.
                  }

                  if (camposValidos) {
                    print("1.-" +
                        nombreController.text +
                        razaController.text +
                        edadController.text +
                        colorController.text +
                        descripcionController.text);
                    await registerPet();

                    // Aquí se ejecuta el método uploadImages
                    await uploadImages(_selectedImages);

                    await mostrarFinalizar.Mostrar_Finalizados(
                        context, "Registro Con Éxito!");
                    print("3.-" +
                        nombreController.text +
                        razaController.text +
                        edadController.text +
                        colorController.text +
                        descripcionController.text);
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
