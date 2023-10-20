import 'dart:io';
import 'dart:typed_data';

import 'package:fluttapp/Models/Profile.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/HomeCarnetizador.dart';
import 'package:fluttapp/presentation/screens/Cliente/HomeClient.dart';
import 'package:fluttapp/presentation/screens/SearchLocation.dart';
import 'package:fluttapp/presentation/services/alert.dart';
import 'package:fluttapp/presentation/services/services_firebase.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:crypto/crypto.dart';
import 'package:image_picker/image_picker.dart'; // Importa la librería crypto
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image/image.dart' as img;

void main() => runApp(MyApp());
MostrarFinalizar mostrarFinalizar = MostrarFinalizar();
Member? carnetizadorglobal;
Mostrar_Finalizados_Update mostrarMensaje = Mostrar_Finalizados_Update();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegisterUpdate(
        isUpdate: false,
        carnetizadorMember: null,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ignore: must_be_immutable
class RegisterUpdate extends StatefulWidget {
  final Member? userData;
  late final bool isUpdate;
  Member? carnetizadorMember;

  RegisterUpdate(
      {required this.isUpdate,
      this.userData,
      required this.carnetizadorMember}) {
    print("intentando mandar los datos de name con:");
    print(carnetizadorMember?.names);
    carnetizadorglobal = this.carnetizadorMember!;

    print("Esta llegando el ID de Facebook");
    print(userData?.id);
  }
  @override
  _RegisterUpdateState createState() => _RegisterUpdateState();
}

class _RegisterUpdateState extends State<RegisterUpdate> {
  bool esCliente = false;
  final _formKey = GlobalKey<FormState>();
  String nombre = '';
  String apellido = '';
  var datebirthday;
  var dateCreation;
  String carnet = '';
  String telefono = '';
  String? selectedRole = 'Cliente';
  String latitude = '';
  String longitude = '';
  String email = '';
  String password = '';
  int status = 1;
  int? idRolSeleccionada;
  String nameJefe = "";
  int idJefe = 0;
  int idPerson = 0;
  Member? jefeDeCarnetizador;

  void initState() {
    super.initState();
    if (widget.userData?.id != null) {
      Cargar_Datos_Persona();
    }
    if (widget.userData?.role == "Cliente") {
      esCliente = true;
      print(widget.userData?.role);
    } else if (widget.userData?.role == "Carnetizador") {
      esCliente = false;
      print(widget.userData?.role);
    }
    print("probando si envia los datos ahora global");
    print(carnetizadorglobal?.id);
    print(carnetizadorglobal?.correo);
  }

  void Cargar_Datos_Persona() async {
    print("probando si llegan los datos del cliente facebook");
    print(widget.userData?.id);
    idPerson = widget.userData!.id;
    print(
        "probando si llegan los datos del cliente facebook pero con idPerson");
    print(idPerson);
    nombre = widget.userData!.names;
    apellido = widget.userData!.lastnames!;
    datebirthday = widget.userData?.fechaNacimiento;
    dateCreation = widget.userData?.fechaCreacion;
    carnet = widget.userData!.carnet!;
    telefono = widget.userData!.telefono.toString();
    selectedRole = widget.userData!.role;

    latitude = widget.userData!.latitud.toString();
    longitude = widget.userData!.longitud.toString();
    email = widget.userData!.correo;

    setState(() {});
  }

  Future<void> registerUser() async {
    final url = Uri.parse('http://181.188.191.35:3000/register');
    if (selectedRole == 'Carnetizador') {
      idRolSeleccionada = 3;
    } else if (selectedRole == 'Cliente') {
      idRolSeleccionada = 4;
    }
    String md5Password = md5.convert(utf8.encode(password)).toString();
    final response = await http.post(
      url,
      body: jsonEncode({
        'Nombres': nombre,
        'Apellidos': apellido,
        'FechaNacimiento': datebirthday.toIso8601String(),
        'FechaCreacion': dateCreation.toIso8601String(),
        'Carnet': carnet,
        'Telefono': telefono,
        'IdRol': idRolSeleccionada,
        'Latitud': latitude,
        'Longitud': longitude,
        'Correo': email,
        'Password': md5Password,
        'Status': status,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Registro exitoso
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar el usuario')),
      );
    }
  }

  Future<void> updateUser() async {
    final url = Uri.parse(
        'http://181.188.191.35:3000/update/' + idPerson.toString()); //
    if (selectedRole == 'Carnetizador') {
      idRolSeleccionada = 3;
    } else if (selectedRole == 'Cliente') {
      idRolSeleccionada = 4;
    }
    // Calcula el hash MD5 de la contraseña
    final response = await http.put(
      url,
      body: jsonEncode({
        'id': idPerson,
        'Nombres': nombre,
        'Apellidos': apellido,
        'FechaNacimiento': datebirthday.toIso8601String(),
        'Carnet': carnet,
        'Telefono': telefono,
        'IdRol': idRolSeleccionada,
        'Latitud': latitude,
        'Longitud': longitude,
        'Correo': email,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Registro exitoso
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el usuario')),
      );
    }
    miembroActual!.id == idPerson;

    print(widget.userData!.id);
    print(miembroActual!.id);
    if (miembroActual!.id == idPerson) {
      if (selectedRole == 'Carnetizador') {
        idRolSeleccionada = 3;
      } else if (selectedRole == 'Cliente') {
        idRolSeleccionada = 4;
      }
      miembroActual!.names = nombre;
      miembroActual!.lastnames = apellido;
      miembroActual!.fechaNacimiento = datebirthday;
      miembroActual!.carnet = carnet;
      miembroActual!.telefono = int.parse(telefono);
      miembroActual!.role = selectedRole;
      miembroActual!.latitud = double.parse(latitude);
      miembroActual!.longitud = double.parse(longitude);
      miembroActual!.correo = email;
    }
  }

  Future<void> Permisos() async {
    LocationPermission permiso;
    permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        return Future.error('Error');
      }
    }
  }

  File? _image;

  Future<void> _getImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      }
    });
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

  Future<bool> uploadImage(File? image, int userId) async {
    try {
      int idPerson = await getNextIdPerson();
      final firebase_storage.Reference storageRef =
          firebase_storage.FirebaseStorage.instance.ref();
      print("Ultimo ID =======" + "---" + idPerson.toString());
      String carpeta = 'cliente/$idPerson';

      if (image != null) {
        firebase_storage.Reference imageRef =
            storageRef.child('$carpeta/imagenUsuario.jpg');

        // Comprimir la imagen antes de subirla
        List<int> compressedBytes = await compressImage(image);

        await imageRef.putData(Uint8List.fromList(compressedBytes));
      }

      return true;
    } catch (e) {
      print('Error al subir la imagen: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isUpdate
        ? 'Actualizar Usuario'
        : 'Registrar Usuario'; // Título dinámico
    File? selectedImage;

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (carnetizadorglobal?.role == "Carnetizador") {
                print("volver carnetizador");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewClient(
                      userId: miembroActual!.id,
                    ),
                  ),
                );
              } else if (carnetizadorglobal?.role != "Carnetizador") {
                print("volver cliente");
                print(widget.userData!.id);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewClient(
                      userId: widget.userData!
                          .id, //El cliente entrara con la misma variable carnetizadorglobal.role pero en este caso se controla que sea diferente el Rol
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Splash.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: _getImageFromGallery,
                        child: _image == null
                            ? Text('Seleccionar Imagen')
                            : Image.file(_image!,
                                height: 100, width: 100, fit: BoxFit.cover),
                      ),
                      SizedBox(height: 20),
                      selectedImage != null
                          ? Image.file(
                              selectedImage!,
                              height: 200,
                              width: 200,
                            )
                          : Container(),
                    ],
                  ),
                ),
                _buildTextField(
                  initialData: nombre,
                  label: 'Nombres',
                  onChanged: (value) => nombre = value,
                  validator: (value) =>
                      value!.isEmpty ? 'El nombre no puede estar vacío.' : null,
                ),
                _buildTextField(
                  initialData: apellido,
                  label: 'Apellidos',
                  onChanged: (value) => apellido = value,
                  validator: (value) =>
                      value!.isEmpty ? 'El nombre no puede estar vacío.' : null,
                ),
                SizedBox(height: 10),
                Text("Fecha Nacimiento:",
                    style: TextStyle(color: Colors.white)),
                _buildDateOfBirthField(
                  label: 'Fecha Nacimiento',
                  onChanged: (value) => datebirthday = value,
                ),
                _buildTextField(
                  initialData: carnet,
                  label: 'Carnet',
                  onChanged: (value) => carnet = value,
                  validator: (value) =>
                      value!.isEmpty ? 'El carnet no puede estar vacío.' : null,
                ),
                _buildTextField(
                  initialData: telefono,
                  label: 'Teléfono',
                  onChanged: (value) => telefono = value,
                  validator: (value) => value!.isEmpty
                      ? 'El Teléfono no puede estar vacía.'
                      : null,
                  keyboardType: TextInputType.number,
                ),
                Text("Dirección:", style: TextStyle(color: Colors.white)),
                ElevatedButton(
                  child: Text("Selecciona una ubicación"),
                  onPressed: () async {
                    await Permisos();
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocationPicker(),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        latitude = result.latitude.toString();
                        longitude = result.longitude.toString();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF1A2946),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    latitude + " " + longitude,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                _buildTextField(
                  initialData: email,
                  label: 'Email',
                  onChanged: (value) => email = value,
                  validator: (value) =>
                      value!.isEmpty ? 'El email no puede estar vacío.' : null,
                  keyboardType: TextInputType.emailAddress,
                ),
                widget.isUpdate
                    ? Container()
                    : _buildTextField(
                        initialData: "",
                        label: 'Contraseña',
                        onChanged: (value) => password = value,
                        obscureText: true,
                      ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    dateCreation = new DateTime.now();
                    status = 1;
                    if (esCliente == false) {
                      if (_formKey.currentState!.validate() &&
                          latitude != '' &&
                          selectedRole != '' &&
                          datebirthday != null) {
                        if (widget.isUpdate) {
                          await updateUser();

                          mostrarMensaje.Mostrar_Finalizados_Carnetizadores(
                              context,
                              "Actializacion con exito! de Carnetizador",
                              miembroActual!.id);
                        } else if (password != "") {
                          dateCreation = new DateTime.now();
                          status = 1;
                          await registerUser();
                          idPerson = await getNextIdPerson();
                          uploadImage(_image, idPerson);
                          mostrarMensaje.Mostrar_Finalizados_Carnetizadores(
                              context,
                              "Registro carnetizador con exito!",
                              miembroActual!.id);
                        }
                      }
                    } else if (esCliente == true) {
                      if (_formKey.currentState!.validate() &&
                          latitude != '' &&
                          selectedRole != '' &&
                          datebirthday != null) {
                        if (widget.isUpdate) {
                          await updateUser();
                          if (carnetizadorglobal?.role == 'Carnetizador') {
                            mostrarMensaje.Mostrar_Finalizados_Carnetizadores(
                                context,
                                "Actializacion con exito! de Cliente con Carnetizador",
                                miembroActual!.id);
                            print(miembroActual!.role);
                          } else {
                            mostrarMensaje.Mostrar_Finalizados_Clientes(
                                context,
                                "Actializacion con exito! de Cliente",
                                widget.userData!.id);
                            print(miembroActual!.role);
                          }
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Ingrese todos los campos')),
                        );
                      }
                    }
                  },
                  child: Text(
                      widget.isUpdate ? 'Actualizar' : 'Registrar Usuario'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF1A2946),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }

  Widget _buildDateOfBirthField({
    required String label,
    required Function(DateTime?) onChanged,
  }) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              datebirthday = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );

              if (datebirthday != null) {
                onChanged(datebirthday);
                setState(() {});
              }
            },
            child: Text(
              datebirthday != null
                  ? "${datebirthday.day}/${datebirthday.month}/${datebirthday.year}"
                  : label,
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF1A2946),
            ),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget _buildTextField({
    required String initialData,
    required String label,
    required Function(String) onChanged,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Column(
      children: [
        TextFormField(
          initialValue: initialData,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.black),
          ),
          onChanged: onChanged,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
