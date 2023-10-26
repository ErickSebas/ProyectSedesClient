import 'dart:convert';
import 'dart:io';
import 'package:fluttapp/presentation/littlescreens/validator.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/ListMascotas.dart';
import 'package:fluttapp/presentation/screens/Cliente/HomeClient.dart';
import 'package:fluttapp/presentation/services/alert.dart';
import 'package:fluttapp/presentation/services/services_firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image/image.dart' as img;
import 'package:qr_flutter/qr_flutter.dart';

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
class LettersOnlyTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String newText = newValue.text.replaceAll(RegExp(r'[^a-zA-Z\s]'), '');
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
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
  Mostrar_Finalizados_Update mostrarFinalizar = Mostrar_Finalizados_Update();
  @override
  void initState() {
    super.initState();
    getPersonData();
    print("Estan llegando los datos del chico");
    print(miembroMascota!.names);
  }

  Future<void> getPersonData() async {
    miembroMascota = await getPersonById(idUsuario!);
  }

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

  Future<void> registerQr(int id) async {
    final url = Uri.parse('http://181.188.191.35:3000/registerqr');

    final response = await http.post(
      url,
      body: jsonEncode({
        'id': id.toString(),
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Registro exitoso
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar el qr')),
      );
    }
  }

  Future<bool> uploadImages(List<File?> images) async {
    try {
      final firebase_storage.Reference storageRef =
          firebase_storage.FirebaseStorage.instance.ref();
      int ultimoId = await fetchLastPetId();
      print("Ultimo ID ======== $ultimoId" + "---" + widget.userId.toString());
      String carpeta = 'cliente/${widget.userId}/$ultimoId';

      await registerQr(ultimoId);

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
        await http.get(Uri.parse('http://181.188.191.35:3000/lastidmascota'));

    final dynamic data = json.decode(response.body);
    return data['ultimo_id'] as int;
  }

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
  String valorSeleccionado = 'H'; // Valor por defecto seleccionado

  List<String> opciones = ['Hembra', 'Macho']; // Lista de opciones
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () => Navigator.pop(context),
          ),
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
    LengthLimitingTextInputFormatter(14),
    LettersOnlyTextFormatter(), // Aplica el formatter aquí
  ],
  maxLength: 14,
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
                maxLength: 2, // Establece el máximo de caracteres a 2
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
    LengthLimitingTextInputFormatter(14),
    LettersOnlyTextFormatter(), // Aplica el formatter aquí
  ],
  maxLength: 14,
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
                  onPressed: isLoading ? null : () async {
                    if (_selectedImages.length < 3) {
                    final picker = ImagePicker();
                    final List<XFile>? pickedFiles =
                        await picker.pickMultiImage();

                    if (pickedFiles != null && pickedFiles.isNotEmpty) {
                      int availableSlots = 3 - _selectedImages.length;
                      List<File> newImages = pickedFiles
                          .take(availableSlots)
                          .map((file) => File(file.path))
                          .toList();

                      setState(() {
                        _selectedImages.addAll(newImages);
                      });

                      if (pickedFiles.length > availableSlots) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Se ha alcanzado el límite de 3 imágenes.'),
                          ),
                        );
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Se ha alcanzado el límite de 3 imágenes.'),
                    ));
                  }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    primary: Color(0xFF5C8ECB),
                  ),
                  child: Text('Cargar Fotos de la Mascota'),
                ),
              SizedBox(height: 10),
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
              SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   ElevatedButton(
                      onPressed: isLoading ? null : () async {
                        setState(() {
                        isLoading =
                            true; // Comienza la carga al presionar el botón
                      });

                      bool camposValidos = validarCampos();

                      if (_selectedImages.length < 1) {
                        setState(() {
                          isLoading = false; // Detén la carga si hay un error
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Debe cargar al menos 1 imagen.'),
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

                        await mostrarFinalizar.Mostrar_Finalizados_Clientes(
                            context,
                            "Registro de Mascota con éxito",
                            miembroMascota!.id);
                        print("3.-" +
                            nombreController.text +
                            razaController.text +
                            edadController.text +
                            colorController.text +
                            descripcionController.text);

                        setState(() {
                          isLoading =
                              false; // Detén la carga después de completar la operación
                        });
                      }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        primary: Colors.green,
                      ),
                      child: Text('Registrar Mascota'),
                    ),
                  SizedBox(height: 10),
                  Visibility(
                    visible: isLoading,
                    child: Center(
                      child: SpinKitThreeBounce(
                        // Aquí se usa el indicador ThreeBounce
                        color: Colors
                            .blue, // Puedes cambiar el color según tus preferencias
                        size:
                            50.0, // Puedes cambiar el tamaño según tus preferencias
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: isLoading?null: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    primary: Colors.red,
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
