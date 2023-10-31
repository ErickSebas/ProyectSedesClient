import 'dart:convert';
import 'dart:io';
import 'package:fluttapp/Models/Mascota.dart';
import 'package:fluttapp/presentation/littlescreens/validator.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/ListMascotas.dart';
import 'package:fluttapp/presentation/screens/Cliente/HomeClient.dart';
import 'package:fluttapp/presentation/services/alert.dart';
import 'package:fluttapp/presentation/services/services_firebase.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class UpdatePet extends StatefulWidget {
  final Mascota mascota; // Agregar este campo para recibir el objeto Mascota

  UpdatePet(this.mascota); // Constructor que recibe una Mascota

  @override
  _UpdatePetState createState() => _UpdatePetState();
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
class _UpdatePetState extends State<UpdatePet> {
  ValidadorCamposMascota validador = ValidadorCamposMascota();
  TextEditingController nombreController = TextEditingController();
  TextEditingController edadController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController razaController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  String? mensajeError;
  List<File?> _selectedImages = [];
  Mostrar_Finalizados_Update mostrarFinalizar = Mostrar_Finalizados_Update();
  List<String> _imageUrls = [];
  bool isLoadingImages = true;

  @override
  void initState() {
    super.initState();
    getImagesUrls(
            'cliente', widget.mascota.idPersona, widget.mascota.idMascotas)
        .then((urls) {
      setState(() {
        _imageUrls = urls;
      });
    });
    addImageUrlsToSelectedImages(
        'cliente', widget.mascota.idPersona, widget.mascota.idMascotas);
    // Asignar los valores de la Mascota a los controladores
    nombreController.text = widget.mascota.nombre;
    edadController.text = widget.mascota.edad.toString();
    descripcionController.text = widget.mascota.descripcion;
    razaController.text = widget.mascota.raza;
    colorController.text = widget.mascota.color;
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

  Future<List<String>> getImagesUrls(
      String carpeta, int idCliente, int idMascota) async {
    List<String> imageUrls = [];

    try {
      Reference storageRef =
          FirebaseStorage.instance.ref('$carpeta/$idCliente/$idMascota');
      ListResult result = await storageRef.list();

      for (var item in result.items) {
        String downloadURL = await item.getDownloadURL();
        imageUrls.add(downloadURL);
      }
    } catch (e) {
      print('Error al obtener URLs de imágenes: $e');
    }

    return imageUrls;
  }

  Future<void> addImageUrlsToSelectedImages(
      String carpeta, int idCliente, int idMascota) async {
    try {
      List<String> imageUrls =
          await getImagesUrls(carpeta, idCliente, idMascota);
      for (String url in imageUrls) {
        File tempImage = await _downloadImage(url);
        setState(() {
          _selectedImages.add(tempImage);
        });
      }
      setState(() {
        isLoadingImages = false;
      });
    } catch (e) {
      print('Error al obtener y descargar las imágenes: $e');
    }
  }

  Future<File> _downloadImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();
      final tempImageFile =
          File('${tempDir.path}/${DateTime.now().toIso8601String()}.jpg');
      await tempImageFile.writeAsBytes(bytes);
      return tempImageFile;
    } else {
      throw Exception('Error al descargar imagen');
    }
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

  Future<bool> uploadImages(List<File?> images, int userId, int petId) async {
    try {
      final firebase_storage.Reference storageRef =
          firebase_storage.FirebaseStorage.instance.ref();
      print("Ultimo ID ======== $userId" + "---" + petId.toString());
      String carpeta = 'cliente/$userId/$petId';

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

  Future<bool> deletePetFolder(int userId, int petId) async {
    try {
      final firebase_storage.Reference storageRef =
          firebase_storage.FirebaseStorage.instance.ref();

      String carpeta = 'cliente/$userId/$petId';

      // Listamos los elementos en la carpeta de la mascota
      firebase_storage.ListResult listResult =
          await storageRef.child(carpeta).listAll();

      // Eliminamos cada elemento individualmente
      for (var item in listResult.items) {
        await item.delete();
      }

      return true;
    } catch (e) {
      print('Error al eliminar carpeta de mascota: $e');
      return false;
    }
  }

  Future<void> updatePet() async {
    final url = Uri.parse('http://181.188.191.35:3000/updatemascota/' +
        widget.mascota.idMascotas.toString());

    final response = await http.put(
      url,
      body: jsonEncode({
        'id': widget.mascota.idMascotas,
        'Nombre': nombreController.text,
        'Raza': razaController.text,
        'Edad': int.parse(edadController.text),
        'Color': colorController.text,
        'Descripcion': descripcionController.text,
        'IdPersona': widget
            .mascota.idPersona, // Asegúrate de tener este valor disponible
        'Sexo': valorSeleccionado,
        'IdQr': widget.mascota.idQr, // Asegúrate de tener este valor disponible
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Mascota actualizada exitosamente
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar la mascota')),
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
        backgroundColor: Color.fromARGB(255, 241, 245, 255),
        title: Text('Actualizar Mascota',
            style: TextStyle(color: const Color.fromARGB(255, 70, 65, 65))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
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
                          LettersOnlyTextFormatter(), // Aplica el formatter aquí
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
                  LengthLimitingTextInputFormatter(
                      30), // Limita a 30 caracteres
                          LettersOnlyTextFormatter(), // Aplica el formatter aquí
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
                  LengthLimitingTextInputFormatter(30),
                      LettersOnlyTextFormatter(), // Aplica el formatter aquí
                ],
                maxLength: 30,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: isLoadingImages || isLoading
                    ? null
                    : () async {
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
                  primary: isLoadingImages
                      ? Color.fromARGB(255, 130, 141, 153)
                      : Color(0xFF5C8ECB),
                ),
                child: Text('Cargar Fotos de la Mascota'),
                
              ),
              SizedBox(height: 20),
              isLoadingImages
                  ? SpinKitCircle(
                      color: Color(0xFF5C8ECB),
                      size: 50.0,
                    )
                  : SingleChildScrollView(
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed:isLoadingImages || isLoading
                    ? null: () async {
                      print(miembroActual!.id);
                      setState(() {
                        isLoading =
                            true; // Comienza la carga al presionar el botón
                      });

                      bool camposValidos = validarCampos();
                      if (camposValidos) {
                        print("1.-" +
                            nombreController.text +
                            razaController.text +
                            edadController.text +
                            colorController.text +
                            descripcionController.text);
                        deletePetFolder(widget.mascota.idPersona,
                            widget.mascota.idMascotas);
                        await uploadImages(
                            _selectedImages,
                            widget.mascota.idPersona,
                            widget.mascota.idMascotas);
                        await updatePet();

                        await mostrarFinalizar.Mostrar_Finalizados_Clientes(
                            context,
                            "Mascota actualizada con éxito",
                            miembroActual!.id);
                        print("3.-" +
                            nombreController.text +
                            razaController.text +
                            edadController.text +
                            colorController.text +
                            descripcionController.text);
                      }

                      setState(() {
                        isLoading =
                            false; // Detén la carga después de completar la operación
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      primary:
                          Colors.green, // Cambiar el color del botón aquí
                    ),
                    child: Text('Actualizar Mascota'),
                  ),

                  SizedBox(
                      height:
                          16), // Espacio entre el botón y el indicador de carga

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
                onPressed: isLoading?null: () async {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),    
                  primary: Colors.red, // Cambiar el color del botón aquí
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
