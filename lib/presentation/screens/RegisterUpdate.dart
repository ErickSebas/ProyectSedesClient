import 'package:fluttapp/Models/Profile.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/HomeCarnetizador.dart';
import 'package:fluttapp/presentation/screens/Cliente/HomeClient.dart';
import 'package:fluttapp/presentation/screens/SearchLocation.dart';
import 'package:fluttapp/presentation/services/alert.dart';
import 'package:fluttapp/presentation/services/services_firebase.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());
MostrarFinalizar mostrarFinalizar = MostrarFinalizar();

Mostrar_Finalizados_Update mostrarMensaje = Mostrar_Finalizados_Update();
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegisterUpdate(
        isUpdate: false,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RegisterUpdate extends StatefulWidget {
  final Member? userData;
  late final bool isUpdate;

  RegisterUpdate({required this.isUpdate, this.userData});
  @override
  _RegisterUpdateState createState() => _RegisterUpdateState();
}

class _RegisterUpdateState extends State<RegisterUpdate> {
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
  }   

  void Cargar_Datos_Persona() async {
    idPerson = widget.userData!.id;
    nombre = widget.userData!.names;
    apellido = widget.userData!.lastnames!;
    datebirthday = widget.userData?.fechaNacimiento;
    dateCreation = widget.userData?.fechaCreacion;
    carnet = widget.userData!.carnet;
    telefono = widget.userData!.telefono.toString();
    selectedRole = widget.userData!.role;

    latitude = widget.userData!.latitud.toString();
    longitude = widget.userData!.longitud.toString();
    email = widget.userData!.correo;

    setState(() {});
  }

  Future<void> registerUser() async {
    final url =
        Uri.parse('https://backendapi-398117.rj.r.appspot.com/register');
    if (selectedRole == 'Carnetizador') {
      idRolSeleccionada = 3;
    } else if (selectedRole == 'Cliente') {
      idRolSeleccionada = 4;
    }
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
        'Password': password,
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
    final url = Uri.parse('https://backendapi-398117.rj.r.appspot.com/update/' +
        idPerson.toString()); //
    if (selectedRole == 'Carnetizador') {
      idRolSeleccionada = 3;
    } else if (selectedRole == 'Cliente') {
      idRolSeleccionada = 4;
    }
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

    if (miembroActual!.id == widget.userData!.id) {
      miembroActual!.names = nombre;
      miembroActual!.lastnames = apellido;
      miembroActual!.fechaNacimiento = datebirthday;
      miembroActual!.carnet = carnet;
      miembroActual!.telefono = int.parse(telefono);
      miembroActual!.role = "4";
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

  @override
  Widget build(BuildContext context) {
    final title = widget.isUpdate
        ? 'Actualizar Usuario'
        : 'Registrar Usuario'; // Título dinámico

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (miembroActual?.role == "Carnetizador") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeCarnetizador(
                      userId: miembroActual!.id,
                    ), // Pasa el ID del usuario aquí
                  ),
                );
              } else if (miembroActual?.role == "Cliente") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewClient(
                      userId: miembroActual!.id,
                    ), // Pasa el ID del usuario aquí
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
                    if (esCarnetizador &&
                        _formKey.currentState!.validate() &&
                        latitude != '' &&
                        selectedRole != '' &&
                        datebirthday != null) {
                      if (widget.isUpdate) {
                        await updateUser();

                        mostrarMensaje.Mostrar_Finalizados_Carnetizadores(
                            context, "Actializacion con exito!",miembroActual!.id);
                      } else if (password != "") {
                        dateCreation = new DateTime.now();
                        status = 1;
                        await registerUser();
                        idPerson = await getNextIdPerson();
                          mostrarMensaje.Mostrar_Finalizados_Carnetizadores(
                            context, "Registro con exito!",miembroActual!.id);
                      }
                      esCarnetizador = false;
                    } else {
                      if (esCarnetizador == false &&
                          _formKey.currentState!.validate() &&
                          latitude != '' &&
                          selectedRole != '' &&
                          datebirthday != null) {
                        if (widget.isUpdate) {
                          await updateUser(); 
                        mostrarMensaje.Mostrar_Finalizados_Clientes(
                            context, "Actializacion con exito!",miembroActual!.id);
                              
                        } else if (password != "") {
                          dateCreation = new DateTime.now();
                          status = 1;
                          await registerUser();
                      mostrarMensaje.Mostrar_Finalizados_Clientes(
                            context, "Registro con exito!",miembroActual!.id);
                        }

                        esCarnetizador = false;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Ingrese todos los campos')),
                        );
                      }
                    }
                  },
                  child: Text(widget.isUpdate ? 'Actualizar' : 'Registrar'),
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
