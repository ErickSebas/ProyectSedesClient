import 'package:fluttapp/Models/Profile.dart';
import 'package:fluttapp/presentation/screens/SearchLocation.dart';
import 'package:fluttapp/presentation/services/alert.dart';
import 'package:fluttapp/presentation/services/services_firebase.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:crypto/crypto.dart'; // Importa la librería crypto

void main() => runApp(MyApp());
MostrarFinalizarLogin mostrarFinalizar = MostrarFinalizarLogin();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Register(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterUpdateState createState() => _RegisterUpdateState();
}

class _RegisterUpdateState extends State<Register> {
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
  }

  Future<void> registerUser() async {
    final url = Uri.parse('http://10.10.0.14:3000/register');
    if (selectedRole == 'Carnetizador') {
      idRolSeleccionada = 3;
    } else if (selectedRole == 'Cliente') {
      idRolSeleccionada = 4;
    }

    // Calcula el hash MD5 de la contraseña
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
        'Password': md5Password, // Envía la contraseña en formato MD5
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

  @override
  Widget build(BuildContext context) {
    final title = 'Registrar Usuario'; // Título dinámico

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: Colors.white)),
        centerTitle: true,
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
                  child: Image.asset(
                    'assets/SplashMaypivac.png',
                    height: 100,
                    width: 100,
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
                _buildTextField(
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
                    if (esCarnetizador &&
                        _formKey.currentState!.validate() &&
                        latitude != '' &&
                        selectedRole != '' &&
                        datebirthday != null) {
                      if (password != "") {
                        dateCreation = new DateTime.now();
                        status = 1;
                        await registerUser();
                        idPerson =
                            await getNextIdPerson(); //metodo que hace que el id sea el siguiente en la base de datos
                        mostrarFinalizar.Mostrar_FinalizadosLogin(
                            context, "Registro con exito!");
                      }
                      esCarnetizador = false;
                    } else {
                      if (esCarnetizador == false &&
                          _formKey.currentState!.validate() &&
                          latitude != '' &&
                          selectedRole != '' &&
                          datebirthday != null) {
                        if (password != "") {
                          dateCreation = new DateTime.now();
                          status = 1;
                          await registerUser();
                          mostrarFinalizar.Mostrar_FinalizadosLogin(
                              context, "Registro con exito!");
                        }

                        esCarnetizador = false;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Ingrese todos los campos')),
                        );
                      }
                    }
                  },
                  child: Text('Registrar'),
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
